//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/06/2023.
//
import Vapor

extension KernelASN1 {
    public class ASN1Parser {
        var data: [UInt8]
        var cursor: Int
        var retryAttempts: Int = 0
        
        public init(data: [UInt8]) {
            self.data = data
            self.cursor = 0
            //        self.contentLength = 0
        }
        
        public convenience init(data: Data) {
            let arr = data.memoryBoundBytes()
            
            self.init(data: arr)
        }
        
        public static func objectFromBytes(_ bytes: [UInt8]) -> ASN1Type? {
            let parser = ASN1Parser(data: bytes)
            return parser.parseObject()
        }
        
        public static func objectFromPEM(pemString: String) -> ASN1Type? {
            let sections = sectionsFromPEM(pemString: pemString)
            guard sections.count == 1 else { return nil }
            return sections.first?.object
        }
        
        public static func sectionsFromPEM(pemString: String) -> [(section: String, object: ASN1Type)] {
            var sections: [(section: String, object: ASN1Type)] = []
            for (sectionName, base64) in base64Blocks(with: pemString) {
                if let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) {
                    let arr = data.memoryBoundBytes()
                    
                    let parser = ASN1Parser(data: arr)
                    if let object = parser.parseObject() {
                        sections.append(((sectionName, object)))
                    }
                }
            }
            return sections
        }
        
        public static func sectionsFromPEM(pemFile: String) -> [(section: String, object: ASN1Type)] {
            guard let pemString = try? String(contentsOfFile: pemFile, encoding: .utf8) else { return [] }
            return sectionsFromPEM(pemString: pemString)
        }
        
        func determineObjectType() -> UInt8? {
            if let t = slicedData(cursor..<cursor+1) {
                let type = t[0]
                return type
            }
            return nil
        }
        
        public func parseObject() -> ASN1Type? {
            let startCursor = cursor
            if let t = self.slicedData(cursor..<cursor+1) {
                var tag = t[.zero]
                cursor += 1
                let contextSpecific = tag.and(.asn1.mask.classMask, equals: .asn1.class.contextSpecific)
                
                tag = tag & .asn1.mask.lowTagTypeMask
                if let low = self.slicedData(cursor..<cursor + 1) {
                    var contentLength = Int(low[.zero])
                    
                    cursor += 1
                    if contentLength.and(0x80, not: .zero) {
//                        print(low, contextSpecific, String(contentLength, radix: 16))
                        let numLengthBytes = contentLength & 0x7f
                        if numLengthBytes > 8 {

                            assertionFailure("Error: ASN1 content length larger than 64 bit is not supported - \(low)")
                        }
                        contentLength = 0
                        if let lengthBytes = self.slicedData(cursor..<cursor + numLengthBytes) {
                            for b in lengthBytes
                            {
                                contentLength <<= 8
                                contentLength += Int(b)
                            }
                            cursor += numLengthBytes
                        }
                    }
                    
                    if contextSpecific {
//                        self.cursor += contentLength
                        if let object = parseObject() {
                            return .tagged(UInt(tag), .explicit(object))
                        } else {
                            return nil
                        }
                    }
                    
                    if let asn1Tag: ASN1TypeTag = .init(rawValue: tag) {
                        var asn1Type: (any ASN1Codable)? = nil
                        switch asn1Tag {
                        case .boolean:
                            if let data = self.slicedData(cursor..<cursor + 1) {
                                asn1Type = ASN1Boolean(value: data[0] == UInt8(0xff))
                                self.cursor += contentLength
                            }
                            
                        case .integer:
                            if let data = self.slicedData(cursor..<cursor + contentLength) {
                                asn1Type = ASN1Integer(data: [UInt8](data))
                                self.cursor += contentLength
                            }
                            
                        case .bitString:
                            if let unused = self.slicedData(cursor..<cursor + 1) {
                                let unusedBits = Int(unused[0])
                                if let data = self.slicedData(cursor+1..<cursor + contentLength) {
                                    asn1Type = ASN1BitString(unusedBits: unusedBits, data: [UInt8](data))
                                }
                            }
                            
                            self.cursor += contentLength
                            
                        case .octetString:
                            if let data = self.slicedData(cursor..<(cursor + contentLength)) {
                                asn1Type = ASN1OctetString(data: data)
                                self.cursor += contentLength
                            }
                            
                        case .null:
                            asn1Type = ASN1Null()
                            self.cursor += contentLength
                            
                        case .objectIdentifier:
                            if let data = self.slicedData(cursor..<cursor + contentLength) {
                                var identifier = [Int]()
                                let v1 = Int(data[0]) % 40
                                let v0 = (Int(data[0]) - v1) / 40
                                identifier.append(v0)
                                identifier.append(v1)
                                
                                var value = 0
                                for byte in data[1..<data.count] {
                                    if UInt8(byte).and(0x80, equals: .zero) {
                                        value = value << 7 + Int(byte)
                                        identifier.append(value)
                                        value = 0
                                    }
                                    else {
                                        value = value << 7 + Int(byte & 0x7f)
                                    }
                                }
                                
                                asn1Type = ASN1ObjectIdentifier(identifier: identifier)
                                self.cursor += contentLength
                            }
                            
                        case .sequence:
                            var objects : [ASN1Type] = []
                            let end = self.cursor + contentLength
                            while true {
                                if self.cursor == end {
                                    break
                                }
                                if let object = parseObject()
                                {
                                    objects.append(object)
                                }
                                else {
                                    break
                                }
                            }
                            asn1Type = ASN1Sequence(objects: objects)
                            
                        case .set:
                            var objects : [ASN1Type] = []
                            let end = self.cursor + contentLength
                            while true {
                                if self.cursor == end {
                                    break
                                }
                                if let object = parseObject()
                                {
                                    objects.append(object)
                                }
                                else {
                                    break
                                }
                            }
                            asn1Type = ASN1Set(objects: objects)
                            
                            break
                            
                        case .printableString, .utf8String, .t61String, .ia5String, .graphicString, .generalString:
                            if let data = self.slicedData(cursor..<cursor + contentLength) {
                                let s = String(utf8EncodedBytes: data)
                                    switch asn1Tag
                                    {
                                    case .utf8String:
                                        asn1Type = ASN1UTF8String(string: s as String)
                                        
                                    case .printableString:
                                        asn1Type = ASN1PrintableString(string: s as String)
                                        
                                    case .t61String:
                                        asn1Type = ASN1T61String(string: s as String)
                                        
                                    case .ia5String:
                                        asn1Type = ASN1IA5String(string: s as String)
                                        
                                    case .graphicString:
                                        asn1Type = ASN1GraphicString(string: s as String)
                                        
                                    case .generalString:
                                        asn1Type = ASN1GeneralString(string: s as String)
                                        
                                    default:
                                        break
                                    }
                                
                            }
                            self.cursor += contentLength
                            
                            break
//                            
                        case .utcTime, .generalisedTime:
                            if let data = self.slicedData(cursor..<cursor + contentLength) {
                                let s = String(utf8EncodedBytes: data)
                                    switch asn1Tag
                                    {
                                    case .utcTime:
                                        asn1Type = ASN1UTCTime(s)
                                        
                                    case .generalisedTime:
                                        asn1Type = ASN1GeneralisedTime(s)
                                        
                                    default:
                                        break
                                    }
                                
                            }
                            self.cursor += contentLength
                            
                            break
                            
                        default:
                            asn1Type = ASN1Object(anyData: [])
                            let newLow = self.slicedData((cursor - 3)..<(cursor - 2))?[0] ?? 0
                            let newLowInt = Int(newLow)
                            contentLength = newLowInt
                            self.cursor += (contentLength - 2)
                            break
//                            print(contentLength, newLow)
//                            self.cursor += min(contentLength, ((contentLength >> 4) + startCursor + 1))
                            
                            
//                            print("Error: unhandled ASN1 tag \(asn1Tag)")
                        }
                        
//                        asn1Type?.underlyingData = slicedData(startCursor..<self.cursor)
                        
                        asn1Type?.underlyingData = self.slicedData(startCursor..<self.cursor) ?? []
                        guard let asn1Type else { return nil }
                        switch tag {
                        case .asn1.typeTag.boolean: return .boolean(asn1Type as! ASN1Boolean)
                        case .asn1.typeTag.integer: return .integer(asn1Type as! ASN1Integer)
                        case .asn1.typeTag.bitString: return .bitString(asn1Type as! ASN1BitString)
                        case .asn1.typeTag.octetString: return .octetString(asn1Type as! ASN1OctetString)
                        case .asn1.typeTag.null: return .null(asn1Type as! ASN1Null)
                        case .asn1.typeTag.objectIdentifier: return .objectIdentifier(asn1Type as! ASN1ObjectIdentifier)
                        case .asn1.typeTag.printableString: return .printableString(asn1Type as! ASN1PrintableString)
                        case .asn1.typeTag.utf8String: return .utf8String(asn1Type as! ASN1UTF8String)
                        case .asn1.typeTag.t61String: return .t61String(asn1Type as! ASN1T61String)
                        case .asn1.typeTag.ia5String: return .ia5String(asn1Type as! ASN1IA5String)
                        case .asn1.typeTag.graphicString: return .graphicString(asn1Type as! ASN1GraphicString)
                        case .asn1.typeTag.generalString: return .generalString(asn1Type as! ASN1GeneralString)
                        case .asn1.typeTag.utcTime: return .utcTime(asn1Type as! ASN1UTCTime)
                        case .asn1.typeTag.generalisedTime: return .generalisedTime(asn1Type as! ASN1GeneralisedTime)
                        case .asn1.typeTag.sequence: return .sequence((asn1Type as! ASN1Sequence).objects)
                        case .asn1.typeTag.set: return .set((asn1Type as! ASN1Set).objects)
                            //                    case .asn1.typeTag.external:
                        default: return .any(asn1Type as! ASN1Object)
//                            if asn1Type.underlyingData!.isEmpty && retryAttempts < 5 {
//                                retryAttempts += 1
//                                self.cursor -= contentLength
//                                self.cursor -= 2
//                                print(self.cursor, contentLength)
//                                contentLength = 0
//                                if let object = parseObject() { return object }
//                            } else {
//                               
//                            }
                            
                        }
                    }
                }
            }
            return nil
        }

        
        func slicedData(_ range: Range<Int>) -> [UInt8]? {
            let length = self.data.count
            if 0..<length ~= range.lowerBound && range.upperBound <= length {
                return [UInt8](self.data[range])
            }
            return nil
        }
        
        static func base64Blocks(with base64: String) -> [(String, String)] {
            var base64Str = base64[base64.startIndex...]
            var result: [(String, String)] = []
            let beginPrefix = "-----BEGIN "
            let beginSuffix = "-----\n"
            let endPrefix   = "-----END "
            let endSuffix   = "-----"
            
            while true {
                guard
                    let beginPrefixRange = base64Str.range(of: beginPrefix),
                    let beginSuffixRange = base64Str[beginPrefixRange.upperBound...].range(of: beginSuffix)
                else {
                    break
                }
                
                let name = String(base64Str[beginPrefixRange.upperBound..<beginSuffixRange.lowerBound])
                
                guard
                    let endPrefixRange = base64Str.range(of: endPrefix),
                    let endSuffixRange = base64Str[endPrefixRange.upperBound...].range(of: endSuffix)
                else {
                    break
                }
                
                let base64Block = String(base64Str[beginSuffixRange.upperBound..<endPrefixRange.lowerBound])
                result.append((name, base64Block))
                base64Str = base64Str[endSuffixRange.upperBound...]
            }
            
            return result
        }
    }
}
