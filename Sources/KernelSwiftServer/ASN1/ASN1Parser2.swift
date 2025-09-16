//
//  File.swift
//
//
//  Created by Jonathan Forbes on 15/06/2023.
//
import Vapor
import Collections

extension KernelASN1 {
    public class ASN1Parser2 {
        var buffer: ByteBuffer
        var offset: Int = 0
        var total: Int = 0
        var storedTags: Deque<KernelASN1.ASN1Type.RawType> = []
        var storedConstructedTags: Deque<KernelASN1.ASN1Type.RawType> = []
        
        
        //        var retryAttempts: Int = 0
        
        public init(data: [UInt8]) {
            self.buffer = .init(bytes: data)
            self.offset = 0
            //        self.contentLength = 0
        }
        
        func getNextTypeTag(headerOffset: Int = 0) -> KernelASN1.ASN1Type.RawType {
            guard
                buffer.readableBytes > 0 + headerOffset,
                let firstByteArr = buffer.getBytes(at: buffer.readerIndex + headerOffset, length: 1),
                let firstByte = firstByteArr.first
            else {
                print("FAILING HERE")
                storedTags.append(.unknown)
                return storedTags.last!
            }
            let contextSpecific = firstByte.and(.asn1.mask.classMask, equals: .asn1.class.contextSpecific)
            let constructed = firstByte.and(.asn1.mask.constructedMask, equals: .asn1.class.constructed)
            if contextSpecific && constructed {
                //                storedConstructedTags.append(storedTags[storedTags.endIndex - 1])
                let lengths = getCurrentTypeLength()
                
                let nextTag = getNextTypeTag(headerOffset: lengths.header)
                let tag = firstByte & .asn1.mask.lowTagTypeMask
                print("CONSTR HAPPENED", tag, nextTag)
                storedTags.append(.tagged(tag, .constructed))
                //                storedTags.append(.constructedTag(firstByte & .asn1.mask.lowTagTypeMask))
            } else if contextSpecific {
                let lengths = getCurrentTypeLength()
                let nextTag = getNextTypeTag(headerOffset: lengths.header)
                let tag = firstByte & .asn1.mask.lowTagTypeMask
                print("SPEC HAPPENED", tag, nextTag)
                storedTags.append(.tagged(tag, .implicit(nextTag)))
            } else if let lowMaskedTag: KernelASN1.ASN1TypeTag = .init(rawValue: firstByte & .asn1.mask.lowTagTypeMask) {
                storedTags.append(lowMaskedTag.asn1RawType)
            } else {
                print("FAILING HERE")
                storedTags.append(.unknown)
            }
            return storedTags.last!
        }
        
        func getCurrentTypeLength() -> (header: Int, content: Int) {
            guard
                buffer.readableBytes > 0
            else { return (0, 0) }
            guard buffer.readableBytes > 1,
                  let firstLengthByteArr = buffer.getBytes(at: buffer.readerIndex + 1, length: 1),
                  let firstLengthByte = firstLengthByteArr.first
            else { return (1, 0) }
            if firstLengthByte.and(.asn1.mask.multiByteMask, equals: firstLengthByte) { return (2, .init(firstLengthByte)) }
            let lengthDefByteLength = firstLengthByte & .asn1.mask.multiByteMask
            guard buffer.readableBytes > (1 + lengthDefByteLength),
                  let fullLengthByteArr = buffer.getBytes(at: buffer.readerIndex + 2, length: Int(lengthDefByteLength))
            else { return (2 + Int(lengthDefByteLength), 0) }
            var len: Int = 0
            for b in fullLengthByteArr {
                len = len << 8
                len += Int(b)
            }
            return (2 + Int(lengthDefByteLength), len)
        }
        
        func parseObject() throws -> KernelASN1.ASN1Type {
            if total == 0 { total = buffer.readableBytes }
            guard total != offset else {
                throw KernelASN1.TypedError(.parsingFailed, reason: "Unable to parse from insufficient data", arguments: [
                    "Total Bytes: \(total)",
                    "Current Offset: \(offset)"
                ])
            }
            
            let tag = getNextTypeTag()
            let lengths = getCurrentTypeLength()
            guard let nextBytes = tag.isPrimitive ? buffer.readBytes(length: lengths.header + lengths.content) : buffer.readBytes(length: lengths.header) else { return .unknown }
            let contentBytes: [UInt8] = .init(nextBytes.dropFirst(lengths.header))
            offset += nextBytes.count
            
            
            return try parseObjectForBytes(tag: tag, nextBytes: nextBytes, contentBytes: contentBytes, lengths: lengths)
        }
        
        internal func parseObjectForBytes(tag: KernelASN1.ASN1Type.RawType, nextBytes: [UInt8], contentBytes: [UInt8], lengths: (header: Int, content: Int)) throws -> KernelASN1.ASN1Type {
            
            
            switch tag {
            case .any:
                var obj = ASN1Object(anyData: contentBytes)
                obj.underlyingData = nextBytes
                return .any(obj)
            case .bitString:
                var obj = ASN1BitString(unusedBits: .init(contentBytes[.zero]), data: .init(contentBytes.dropFirst()))
                obj.underlyingData = nextBytes
                return .bitString(obj)
            case .bmpString:
                var obj = ASN1BMPString(string: .init(utf8EncodedBytes: contentBytes))
                obj.underlyingData = nextBytes
                return .bmpString(obj)
            case .boolean:
                var obj = ASN1Boolean(value: contentBytes[.zero] == .max)
                obj.underlyingData = nextBytes
                return .boolean(obj)
            case .integer:
                var obj = ASN1Integer(data: contentBytes)
                obj.underlyingData = nextBytes
                return .integer(obj)
            case .tagged(let constrTag, let taggedType):
                print("USING TWO")
                switch taggedType {
                case .explicit(let wrapped):
                    let lengths = getCurrentTypeLength()
                    guard let nextBytes = wrapped.isPrimitive ? buffer.readBytes(length: lengths.header + lengths.content) : buffer.readBytes(length: lengths.header) else { return .unknown }
                    let contentBytes: [UInt8] = .init(nextBytes.dropFirst(lengths.header))
                    offset += nextBytes.count
                    let tagged = try parseObjectForBytes(tag: wrapped, nextBytes: nextBytes, contentBytes: contentBytes, lengths: lengths)
                    if case let .sequence(items) = tagged {
                        return .tagged(UInt(constrTag), .constructed(items))
                    } else if case let .set(items) = tagged {
                        return .tagged(UInt(constrTag), .constructed(items))
                    } else {
                        return .tagged(UInt(constrTag), .explicit(tagged))
                    }
                case .constructed:
                    let previousTag = storedConstructedTags[storedConstructedTags.endIndex - 1]
                    let tagged = try parseObjectForBytes(tag: previousTag, nextBytes: nextBytes, contentBytes: contentBytes, lengths: lengths)
                    if case let .sequence(items) = tagged {
                        return .tagged(UInt(constrTag), .constructed(items))
                    } else if case let .set(items) = tagged {
                        return .tagged(UInt(constrTag), .constructed(items))
                    } else {
                        throw KernelASN1.TypedError(.parsingFailed)
                    }
                case .implicit(let wrapped):
                    let tagged = try parseObjectForBytes(tag: wrapped, nextBytes: nextBytes, contentBytes: contentBytes, lengths: lengths)
                    if case let .sequence(items) = tagged {
                        return .tagged(UInt(constrTag), .constructed(items))
                    } else if case let .set(items) = tagged {
                        return .tagged(UInt(constrTag), .constructed(items))
                    } else {
                        return .tagged(UInt(constrTag), .implicit(tagged))
                    }
                }
            case .generalString:
                var obj = ASN1GeneralString(string: .init(utf8EncodedBytes: contentBytes))
                obj.underlyingData = nextBytes
                return .generalString(obj)
            case .generalisedTime:
                var obj = ASN1GeneralisedTime(.init(utf8EncodedBytes: contentBytes))
                obj.underlyingData = nextBytes
                return .generalisedTime(obj)
            case .graphicString:
                var obj = ASN1GraphicString(string: .init(utf8EncodedBytes: contentBytes))
                obj.underlyingData = nextBytes
                return .graphicString(obj)
            case .ia5String:
                var obj = ASN1IA5String(string: .init(utf8EncodedBytes: contentBytes))
                obj.underlyingData = nextBytes
                return .ia5String(obj)
            case .null:
                var obj = ASN1Null()
                obj.underlyingData = nextBytes
                return .null(obj)
            case .objectIdentifier:
                var identifier = [Int]()
                let v1 = Int(contentBytes[0]) % 0x28
                let v0 = (Int(contentBytes[0]) - v1) / 0x28
                identifier.append(v0)
                identifier.append(v1)
                
                var value = 0
                for byte in contentBytes[1..<contentBytes.count] {
                    if UInt8(byte) & .asn1.class.contextSpecific == .zero {
                        value = value << 7 + Int(byte)
                        identifier.append(value)
                        value = 0
                    }
                    else { value = value << 7 + Int(byte & .asn1.mask.multiByteMask) }
                }
                var obj = ASN1ObjectIdentifier(identifier: identifier)
                obj.underlyingData = nextBytes
                return .objectIdentifier(obj)
            case .octetString:
                var obj = ASN1OctetString(data: .init(contentBytes))
                obj.underlyingData = nextBytes
                return .octetString(obj)
            case .primitiveTag(let primTag):
                var obj = ASN1Object(anyData: contentBytes)
                obj.underlyingData = nextBytes
                return .tagged(UInt(primTag), .explicit(.any(obj)))
            case .printableString:
                var obj = ASN1PrintableString(string: .init(utf8EncodedBytes: contentBytes))
                obj.underlyingData = nextBytes
                return .printableString(obj)
            case .sequence:
                var seqItems: [ASN1Type] = []
                let currentOffset = lengths.content + offset
                while offset < currentOffset {
                    let nextObj = try parseObject()
                    seqItems.append(nextObj)
                }
                var obj = ASN1Sequence(objects: seqItems)
                obj.underlyingData = nextBytes
                return .sequence(obj.objects)
            case .set:
                var setItems: [ASN1Type] = []
                let currentOffset = lengths.content + offset
                while offset < currentOffset {
                    let nextObj = try parseObject()
                    setItems.append(nextObj)
                }
                var obj = ASN1Set(objects: setItems)
                obj.underlyingData = nextBytes
                return .set(obj.objects)
            case .t61String:
                var obj = ASN1T61String(string: .init(utf8EncodedBytes: contentBytes))
                obj.underlyingData = nextBytes
                return .t61String(obj)
            case .utcTime:
                var obj = ASN1UTCTime(.init(utf8EncodedBytes: contentBytes))
                obj.underlyingData = nextBytes
                return .utcTime(obj)
            case .utf8String:
                var obj = ASN1UTF8String(string: .init(utf8EncodedBytes: contentBytes))
                obj.underlyingData = nextBytes
                return .utf8String(obj)
            case .visibleString:
                var obj = ASN1VisibleString(string: .init(utf8EncodedBytes: contentBytes))
                obj.underlyingData = nextBytes
                return .visibleString(obj)
                
            default:
                
                return .unknown
            }
        }
        
        
        public static func objectFromBytes(_ bytes: [UInt8]) throws -> ASN1Type {
            let parser = ASN1Parser2(data: bytes)
            return try parser.parseObject()
        }
        
        public static func objectFromPEM(pemString: String) throws -> ASN1Type? {
            let sections = try sectionsFromPEM(pemString: pemString)
            guard sections.count == 1 else { return nil }
            return sections.first?.object
        }
        
        public static func sectionsFromPEM(pemString: String) throws -> [(section: String, object: ASN1Type)] {
            var sections: [(section: String, object: ASN1Type)] = []
            for (sectionName, base64) in base64Blocks(with: pemString) {
                if let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) {
                    let arr = data.memoryBoundBytes()
                    let parser = ASN1Parser2(data: arr)
                    let parsed = try parser.parseObject()
                    sections.append(((sectionName, parsed)))
                }
            }
            return sections
        }
        
        public static func sectionsFromPEM(pemFile: String) throws -> [(section: String, object: ASN1Type)] {
            guard let pemString = try? String(contentsOfFile: pemFile, encoding: .utf8) else { return [] }
            return try sectionsFromPEM(pemString: pemString)
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
