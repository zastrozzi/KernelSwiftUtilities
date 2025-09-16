//
//  File.swift
//
//
//  Created by Jonathan Forbes on 16/07/2023.
//

import Vapor
import Collections

extension KernelASN1 {
    public class ASN1Parser3 {
        var buffer: ByteBuffer
        var parserTotalLength: Int = 0
        var parserCurrentOffset: Int = 0
        //        var parsedTypes: Array<KernelASN1.ASN1Type.ParsedTypeWithMetadata> = []
        var parsedTypesDict: Dictionary<UUID, KernelASN1.ASN1Type.ParsedTypeWithMetadata> = [:]
        var currentPath: Deque<UUID> = []
        var rootId: UUID? = nil
        
        public init(data: [UInt8]) {
            self.buffer = .init(bytes: data)
            self.parserTotalLength = data.count
            self.parserCurrentOffset = 0
        }
        
        func generateParsingTree() throws {
            while parserTotalLength > parserCurrentOffset {
                var lengths = try calculateNextTypeLengths(readerOffset: parserCurrentOffset)
                let type = try parseNextType(readerOffset: parserCurrentOffset)
                let endIndex = parserCurrentOffset + lengths.content.length + lengths.header
                guard type.type != .berTerminator else {
                    parserCurrentOffset += 2
                    return
                }
                let isStructured: Bool = switch type.type {
                case .tag(_, _, let constructed): constructed
                case .sequence: true
                case .set: true
                default: false
                }
                let isCurrentChild = currentPath.count > 0 && (parsedTypesDict[currentPath.last!]!.metadata.endIndex > endIndex)
                let pathItemsToRemove: Int = isCurrentChild ? 0 : currentPath.reversed().reduce(0, { partialResult, id in
                    if parsedTypesDict[currentPath.last!]!.metadata.contentLength != .indeterminate {
                        (parsedTypesDict[id]!.metadata.endIndex < endIndex) ? partialResult + 1 : partialResult
                    } else {
                        partialResult
                    }
                    
                })
                
                let wasIndeterminate = lengths.content == .indeterminate
                
//                let isConstructed: Bool = switch type.type {
//                case .tag(_, _, let constructed): constructed
//                case .sequence: true
//                case .set: true
//                default: false
//                }
                
                if case .indeterminate = lengths.content {
                    if !isStructured {
                        var foundTerminator = false
                        var terminationOffset: Int = parserCurrentOffset + lengths.header
                        while !foundTerminator {
                            guard buffer.readableBytes > terminationOffset, let testBytes = buffer.getBytes(at: buffer.readerIndex + terminationOffset, length: 2) else {
                                throw KernelASN1.TypedError(.parsingFailed, reason: "V3 Failure - ran out of bytes")
                            }
                            if testBytes == [0x00, 0x00] {
                                lengths.content = .determinate(terminationOffset + 2)
                                foundTerminator = true
                            } else {
                                terminationOffset += 1
                            }
                        }
                    }
                }
                
                let isContextSpecific: Bool = switch type.type {
                case .tag(_, let contextSpecific, _): contextSpecific
                case .sequence: false
                case .set: false
                default: false
                }
                currentPath.removeLast(pathItemsToRemove)
                let meta: KernelASN1.ASN1Type.ParsingMetadata = .init(constructed: isStructured, offset: parserCurrentOffset, headerLength: lengths.header, contentLength: lengths.content, treeLevel: currentPath.count, parentId: currentPath.last ?? nil)
                if isStructured || isContextSpecific { currentPath.append(meta.id) }
                if meta.parentId == nil {
//                    print(meta, "META")
//                    print(parsedTypesDict, "DICT")
                    guard rootId == nil else { throw KernelASN1.TypedError(.parsingFailed, reason: "More than one root object detected") }
                    rootId = meta.id
                }
                let typeWithMeta: KernelASN1.ASN1Type.ParsedTypeWithMetadata = .init(type: type.type, metadata: meta)
                //                parsedTypes.append(typeWithMeta)
                parsedTypesDict.updateValue(typeWithMeta, forKey: meta.id)
                parserCurrentOffset += (isStructured ? lengths.header : lengths.header + lengths.content.length)
                parserCurrentOffset += ((wasIndeterminate && !isStructured) ? 2 : 0)
            }
        }
        
        func parseNextType(readerOffset: Int = 0) throws -> (type: KernelASN1.ASN1Type.ParsedType, constructed: Bool) {
            guard
                buffer.readableBytes > 0 + readerOffset,
                let typeByte = buffer.getBytes(at: buffer.readerIndex + readerOffset, length: 1)?.first
            else {
                print("FAILING HERE")
                throw KernelASN1.TypedError(.parsingFailed, reason: "V3 Failure - ran out of bytes")
            }
            
            let tag = typeByte & .asn1.mask.lowTagTypeMask
            let contextSpecific = typeByte & .asn1.mask.classMask == .asn1.class.contextSpecific
            let constructed = typeByte & .asn1.mask.constructedMask == .asn1.class.constructed
            switch (contextSpecific, constructed) {
            case (true, true): return (type: .tag(resolved: tag, contextSpecific: true, constructed: true), constructed: true)
            case (true, false): return (type: .tag(resolved: tag, contextSpecific: true, constructed: false), constructed: false)
            default: break
            }
            return (type: .init(fromTag: tag), constructed: constructed)
        }
        
        func calculateNextTypeLengths(readerOffset: Int = 0) throws -> (header: Int, content: KernelASN1.ASN1Type.ParsingMetadata.ContentLength) {
            guard
                buffer.readableBytes > 0 + readerOffset
            else { throw KernelASN1.TypedError(.parsingFailed, reason: "V3 Failure - ran out of bytes") }
            guard buffer.readableBytes > 1 + readerOffset,
                  let firstLengthByte = buffer.getBytes(at: buffer.readerIndex + 1 + readerOffset, length: 1)?.first
            else { throw KernelASN1.TypedError(.parsingFailed, reason: "V3 Failure - ran out of bytes") }
            if firstLengthByte == .asn1.class.contextSpecific { return (2, .indeterminate )}
            if firstLengthByte & .asn1.mask.multiByteMask == firstLengthByte { return (2, .determinate(.init(firstLengthByte))) }
            let lengthDefByteLength = firstLengthByte & .asn1.mask.multiByteMask
            guard buffer.readableBytes > (1 + readerOffset + .init(lengthDefByteLength)),
                  let fullLengthByteArr = buffer.getBytes(at: buffer.readerIndex + readerOffset + 2, length: Int(lengthDefByteLength))
            else { throw KernelASN1.TypedError(.parsingFailed, reason: "V3 Failure - ran out of bytes") }
            var len: Int = 0
            for b in fullLengthByteArr {
                len = len << 8
                len += Int(b)
            }
            return (2 + Int(lengthDefByteLength), .determinate(len))
        }
        
        func parseTreeObject(id: UUID? = nil) throws -> KernelASN1.ASN1Type.VerboseTypeWithMetadata {
            let id = id ?? rootId
            guard let id else { throw KernelASN1.TypedError(.parsingFailed, reason: "Cannot parse tree without a root id") }
            guard let treeObject = parsedTypesDict[id] else { throw KernelASN1.TypedError(.parsingFailed, reason: "Cannot parse tree without a root id") }
            //            if treeObject.metadata.constructed {
            //                print(treeObject)
            //            }
            if treeObject.metadata.constructed {
                let children: [KernelASN1.ASN1Type.VerboseTypeWithMetadata] = try parsedTypesDict.values.filter({ child in
                    child.metadata.parentId == treeObject.metadata.id
                }).map { child in
                    try parseTreeObject(id: child.metadata.id)
                }.sorted { c0, c1 in
                    guard let parsingMetadataC0 = c0.parsingMetadata, let parsingMetadataC1 = c1.parsingMetadata else { throw KernelASN1.TypedError(.parsingFailed) }
                    return parsingMetadataC0.offset < parsingMetadataC1.offset
                }
                switch treeObject.type {
                case .sequence: return .sequence(children).parsing(treeObject.metadata)
                case .set: return .set(children).parsing(treeObject.metadata)
                case let .tag(resolved, _, _): return .tag(.init(resolved), constructed: true, nil, children).parsing(treeObject.metadata)
                default: throw KernelASN1.TypedError(.parsingFailed, reason: "Cannot parse tree without a root id")
                }
            } else {
                
                guard
                    let fullBytes = buffer.getBytes(
                        at: buffer.readerIndex + treeObject.metadata.offset,
                        length: treeObject.metadata.contentLength.length + treeObject.metadata.headerLength
                    ),
                    let contentBytes = buffer.getBytes(
                        at: buffer.readerIndex + treeObject.metadata.offset + treeObject.metadata.headerLength,
                        length: treeObject.metadata.contentLength.length
                    )
                else { throw KernelASN1.TypedError(.parsingFailed, reason: "Ran out of bytes") }
                switch treeObject.type {
                case .any:
                    var obj = ASN1Object(anyData: contentBytes)
                    obj.underlyingData = fullBytes
                    return .any(obj).parsing(treeObject.metadata)
                case .bitString:
                    var obj = ASN1BitString(unusedBits: .init(contentBytes[0]), data: .init(contentBytes.dropFirst()))
                    obj.underlyingData = fullBytes
                    return .bitString(obj).parsing(treeObject.metadata)
                case .bmpString:
                    var obj = ASN1BMPString(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .bmpString(obj).parsing(treeObject.metadata)
                case .boolean:
                    var obj = ASN1Boolean(value: contentBytes[0] == .max)
                    obj.underlyingData = fullBytes
                    return .boolean(obj).parsing(treeObject.metadata)
                case .integer:
                    var obj = ASN1Integer(data: contentBytes)
                    obj.underlyingData = fullBytes
                    return .integer(obj).parsing(treeObject.metadata)
                case .generalString:
                    var obj = ASN1GeneralString(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .generalString(obj).parsing(treeObject.metadata)
                case .generalisedTime:
                    var obj = ASN1GeneralisedTime(.init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .generalisedTime(obj).parsing(treeObject.metadata)
                case .graphicString:
                    var obj = ASN1GraphicString(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .graphicString(obj).parsing(treeObject.metadata)
                case .ia5String:
                    var obj = ASN1IA5String(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .ia5String(obj).parsing(treeObject.metadata)
                case .null:
                    var obj = ASN1Null()
                    obj.underlyingData = fullBytes
                    return .null(obj).parsing(treeObject.metadata)
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
                    obj.underlyingData = fullBytes
                    return .objectIdentifier(obj).parsing(treeObject.metadata)
                case .octetString:
                    var obj = ASN1OctetString(data: .init(contentBytes))
                    obj.underlyingData = fullBytes
                    return .octetString(obj).parsing(treeObject.metadata)
                case .printableString:
                    var obj = ASN1PrintableString(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .printableString(obj).parsing(treeObject.metadata)
                case .t61String:
                    var obj = ASN1T61String(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .t61String(obj).parsing(treeObject.metadata)
                case .utcTime:
                    var obj = ASN1UTCTime(.init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .utcTime(obj).parsing(treeObject.metadata)
                case .utf8String:
                    var obj = ASN1UTF8String(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .utf8String(obj).parsing(treeObject.metadata)
                case .visibleString:
                    var obj = ASN1VisibleString(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .visibleString(obj).parsing(treeObject.metadata)
                case let .tag(resolved, contextSpecific, constructed):
                    guard !constructed else { throw KernelASN1.TypedError(.parsingFailed, reason: "Cannot parse a constructed tag from this context") }
                    guard contextSpecific else { throw KernelASN1.TypedError(.parsingFailed, reason: "Cannot parse a non context-specific tag from this context") }
                    var obj = ASN1Object(anyData: contentBytes)
                    obj.underlyingData = fullBytes
                    //                    print("USING THREE")
                    return .tag(.init(resolved), constructed: false, .any(obj).parsing(treeObject.metadata)).parsing(treeObject.metadata)
                case .berTerminator: return .berTerminator().parsing(treeObject.metadata)
                default:
                    throw KernelASN1.TypedError(.parsingFailed, reason: "Unknown object encountered" )
                }
            }
        }
        
        
        func parseObject() throws -> KernelASN1.ASN1Type.VerboseTypeWithMetadata {
            try generateParsingTree()
            return try parseTreeObject()
            //            return .unknown
        }
        
        public static func objectFromBytes(_ bytes: [UInt8]) throws -> ASN1Type.VerboseTypeWithMetadata {
            let parser = ASN1Parser3(data: bytes)
            return try parser.parseObject()
        }
        
        public static func objectFromPEM(pemString: String) throws -> ASN1Type.VerboseTypeWithMetadata? {
            let sections = try sectionsFromPEM(pemString: pemString)
            guard sections.count == 1 else { return nil }
            return sections.first?.object
        }
        
        public static func sectionsFromPEM(pemString: String) throws -> [(section: KernelASN1.PEMFile.Format, object: ASN1Type.VerboseTypeWithMetadata)] {
            var sections: [(section: KernelASN1.PEMFile.Format, object: ASN1Type.VerboseTypeWithMetadata)] = []
            for block in try KernelASN1.PEMFile.allBase64ContentBlocksWithFormat(pemString) {
                if let data = Data(base64Encoded: block.base64Content, options: .ignoreUnknownCharacters) {
                    let arr = data.memoryBoundBytes()
                    let parser = ASN1Parser3(data: arr)
                    let parsed = try parser.parseObject()
                    sections.append(((block.format, parsed)))
                }
            }
            return sections
        }
        
        public static func sectionsFromPEM(pemFile: String) throws -> [(section: KernelASN1.PEMFile.Format, object: ASN1Type.VerboseTypeWithMetadata)] {
            guard let pemString = try? String(contentsOfFile: pemFile, encoding: .utf8) else { return [] }
            return try sectionsFromPEM(pemString: pemString)
        }
    }
}
