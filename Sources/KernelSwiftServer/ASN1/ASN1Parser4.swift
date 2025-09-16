//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/09/2023.
//

import Foundation
import NIOCore
import Collections

extension KernelASN1 {
    public struct ASN1Parser4 {
        private var buffer: ByteBuffer
        private var parserTotalLength: Int = 0
        private var parserCurrentOffset: Int = 0
        private var parsingTree: Dictionary<UUID, ASN1Parser4TypeMetadata> = [:]
        private var rootId: UUID? = nil
        
        public init(bytes: [UInt8]) {
            self.buffer = .init(bytes: bytes)
            self.parserTotalLength = bytes.endIndex - bytes.startIndex
            self.parserCurrentOffset = 0
        }
        
        public init(bytes: Deque<UInt8>) {
            self.buffer = .init(bytes: bytes)
            self.parserTotalLength = bytes.endIndex - bytes.startIndex
            self.parserCurrentOffset = 0
        }
        
        @discardableResult
        public mutating func generateNextTypeMetadata(offset: Int = 0, treeLevel: ASN1Parser4TreeLevel = .root, withId: UUID? = nil, updatingTree: Bool = true, updatingParserOffset: Bool = true) throws -> ASN1Parser4TypeMetadata {
            let readerOffset = offset + parserCurrentOffset
            guard
                buffer.readableBytes > 0 + readerOffset,
                let initialByte = buffer.getBytes(at: buffer.readerIndex + readerOffset, length: 1)?.first
            else {
//                print("WE ARE HERE")
//                print(parsingTree.values.sorted(by: { v0, v1 in
//                    v0.offset < v1.offset
//                }))
                throw TypedError(.parserRanOutOfBytes)
            }
            var metadata: ASN1Parser4TypeMetadata = .init(
                id: withId ?? .init(),
                initialByte: initialByte,
                offset: parserCurrentOffset,
                contentLength: .indeterminate,
                treeLevel: treeLevel
            )
            if updatingTree { parsingTree.updateValue(metadata, forKey: metadata.id) }
//            var resolvedContentLength: Int = 0
            if rootId == nil { rootId = metadata.id }
            switch metadata.tag {
            case .contextSpecificStructured:
//                print("CONTEXT STRUCT")
                var resolvedStructuredTag = false
                var structuredTagBytes: [UInt8] = []
                var structuredTagReaderOffset = readerOffset + 1
                while !resolvedStructuredTag {
                    guard
                        buffer.readableBytes > 0 + structuredTagReaderOffset,
                        let structuredTagByte = buffer.getBytes(at: buffer.readerIndex + structuredTagReaderOffset, length: 1)?.first
                    else { throw TypedError(.parserRanOutOfBytes) }
                    structuredTagBytes.append(structuredTagByte )
                    if structuredTagByte.and(.asn1.mask.multiByteMask, not: structuredTagByte) {
                        structuredTagReaderOffset += 1
                    } else {
                        resolvedStructuredTag = true
                    }
                }
                metadata.resolveStructuredTagBytes(structuredTagBytes)
            default: break
            }
            if updatingParserOffset { parserCurrentOffset += metadata.tag.length }
//            var resolvedContentLengthBytes = false
//            var contentLengthBytes: [UInt8] = []
            let contentLengthReaderOffset = parserCurrentOffset
            switch metadata.tag {
//            case .universal(.boolean):
//                metadata.resolveContentLength(1)
//                break
            case .universal(tag: .berTerminator):
                metadata.resolveContentLength(1)
                break
            case .universal(tag: .null):
                metadata.resolveContentLength(1)
            default:
                guard buffer.readableBytes > contentLengthReaderOffset, let firstContentLengthByte = buffer.getBytes(at: buffer.readerIndex + contentLengthReaderOffset, length: 1)?.first else {
//                    print(metadata)
                    throw TypedError(.parserRanOutOfBytes)
                }

                if firstContentLengthByte == .asn1.class.contextSpecific {
                    if updatingParserOffset { parserCurrentOffset += 1 }
//                    metadata.resolveContentLengthBytes([firstContentLengthByte])
                    break
                }
                if firstContentLengthByte.and(.asn1.mask.multiByteMask, equals: firstContentLengthByte) {
                    metadata.resolveContentLengthBytes([firstContentLengthByte])
                    break
                }
                let lengthDefByteLength = firstContentLengthByte & .asn1.mask.multiByteMask
                guard buffer.readableBytes > (contentLengthReaderOffset + .init(lengthDefByteLength)),
                      let fullLengthByteArr = buffer.getBytes(at: buffer.readerIndex + contentLengthReaderOffset + 1, length: Int(lengthDefByteLength))
                else { throw KernelASN1.TypedError(.parsingFailed, reason: "V4 Failure - ran out of bytes") }
//                var len: Int = 0
//                for b in fullLengthByteArr {
//                    len = len << 8
//                    len += Int(b)
//                }
//                parserCurrentOffset += 1
                metadata.resolveContentLengthBytes([firstContentLengthByte] + fullLengthByteArr)
            }
            if updatingTree { parsingTree.updateValue(metadata, forKey: metadata.id) }
            if updatingParserOffset { parserCurrentOffset += metadata.contentLengthBytes.count }
            switch metadata.contentLength {
            case .indeterminate:
//                parserCurrentOffset += 1
                if case .universal = metadata.tag {
                    metadata.resolveContentLengthBytes([0x80])
                    
                    var reachedTerminator = false
                    var accumulatedLength = 0
                    while !reachedTerminator {
                        let item = try generateNextTypeMetadata(offset: .zero, treeLevel: .child(ancestorCount: metadata.treeLevel.ancestors + 1, parentId: metadata.id), updatingTree: updatingTree, updatingParserOffset: updatingParserOffset)
                        accumulatedLength += item.combinedLength
                        if case .universal(.berTerminator) = item.tag { reachedTerminator = true }
                    }
                    metadata.resolveContentLength(accumulatedLength)
                }
                if case .contextSpecificSimple = metadata.tag {
                    metadata.resolveContentLengthBytes([0x80])
                    var reachedTerminator = false
                    var accumulatedLength = 0
                    while !reachedTerminator {
                        let item = try generateNextTypeMetadata(offset: 0, treeLevel: .child(ancestorCount: metadata.treeLevel.ancestors + 1, parentId: metadata.id), updatingTree: updatingTree, updatingParserOffset: updatingParserOffset)
                        accumulatedLength += item.combinedLength
                        if case .universal(.berTerminator) = item.tag { reachedTerminator = true }
                    }
                    metadata.resolveContentLength(accumulatedLength)
                }
                if case .contextSpecificStructured = metadata.tag {
                    metadata.resolveContentLengthBytes([0x80])
                    var reachedTerminator = false
                    var accumulatedLength = 0
                    while !reachedTerminator {
                        let item = try generateNextTypeMetadata(offset: 0, treeLevel: .child(ancestorCount: metadata.treeLevel.ancestors + 1, parentId: metadata.id), updatingTree: updatingTree, updatingParserOffset: updatingParserOffset)
                        accumulatedLength += item.combinedLength
                        if case .universal(.berTerminator) = item.tag { reachedTerminator = true }
                    }
                    metadata.resolveContentLength(accumulatedLength)
                }
            default:
                switch metadata.tag {
                case .universal(tag: .sequence), .universal(tag: .set):
                    var accumulatedLength = 0
                    while metadata.contentLength.length > accumulatedLength {
                        let item = try generateNextTypeMetadata(offset: 0, treeLevel: .child(ancestorCount: metadata.treeLevel.ancestors + 1, parentId: metadata.id), updatingTree: updatingTree, updatingParserOffset: updatingParserOffset)
                        accumulatedLength += item.combinedLength
                    }
                case .contextSpecificSimple:
                    var accumulatedLength = 0
                    var caught: Bool = false
                    while metadata.contentLength.length > accumulatedLength {
                        let itemId: UUID = .init()
                        caught = false
                        do {
                            guard metadata.contentLength.length > 1 else { throw TypedError(.parserRanOutOfBytes) }
                            let item = try generateNextTypeMetadata(offset: 0, treeLevel: .child(ancestorCount: metadata.treeLevel.ancestors + 1, parentId: metadata.id), withId: itemId, updatingTree: updatingTree, updatingParserOffset: updatingParserOffset)
                            accumulatedLength += item.combinedLength
                            
                            if accumulatedLength > metadata.contentLength.length {
//                                print(item)
                                if updatingTree { parsingTree.removeValue(forKey: itemId) }
                                parserCurrentOffset -= item.combinedLength
                                parserCurrentOffset += metadata.contentLength.length
                                accumulatedLength = metadata.contentLength.length
                            }
                        } catch {
                            //                            print("TO REMOVE", itemId)
                            if updatingTree { parsingTree.removeValue(forKey: itemId) }
                            accumulatedLength += metadata.contentLength.length
                            caught = true
                            
                        }
                    }
                    if caught {
                        //                        print("CAUGHT", parserCurrentOffset, accumulatedLength, metadata.contentLength.length)
                        if updatingParserOffset { parserCurrentOffset += metadata.contentLength.length }
                        //                        parserCurrentOffset -= (accumulatedLength)
                    }
                case .contextSpecificStructured:
                    var accumulatedLength = 0
                    while metadata.contentLength.length > accumulatedLength {
                        let item = try generateNextTypeMetadata(offset: 0, treeLevel: .child(ancestorCount: metadata.treeLevel.ancestors + 1, parentId: metadata.id), updatingTree: updatingTree, updatingParserOffset: updatingParserOffset)
                        accumulatedLength += item.combinedLength
                    }
                default:
                    if updatingParserOffset { parserCurrentOffset += metadata.contentLength.length }
                }
                
            }
//            print(metadata)
            if updatingTree {
                parsingTree.updateValue(metadata, forKey: metadata.id)
            }
            return metadata
        }
        
        public mutating func generateParsingTree() throws {
            while parserTotalLength > parserCurrentOffset {
                try generateNextTypeMetadata()
            }
        }
        
        func parseTreeObject(id: UUID? = nil) throws -> KernelASN1.ASN1Type.VerboseTypeWithMetadata {
            let id = id ?? rootId
            guard let id else { throw KernelASN1.TypedError(.parsingFailed, reason: "Cannot parse tree without a root id") }
            guard let treeObject = parsingTree[id] else { throw KernelASN1.TypedError(.parsingFailed, reason: "Cannot parse tree without a root id") }
            if treeObject.constructed {
                let children: [KernelASN1.ASN1Type.VerboseTypeWithMetadata] = try parsingTree.values.filter({ child in
                    child.treeLevel.parentId == treeObject.id &&
                    child.tag != .universal(tag: .berTerminator)
                }).sorted(by: { c0, c1 in
                    c0.offset < c1.offset
                }).map { child in
                    try parseTreeObject(id: child.id)
                }
                switch treeObject.tag {
                case .universal(tag: .sequence): return .sequence(children).writing()
                case .universal(tag: .set): return .set(children).writing()
                case let .contextSpecificSimple(tag): return .tag(.init(tag), constructed: treeObject.constructed, nil, children).writing()
                case let .contextSpecificStructured(tagBytes):
                    var len: UInt = 0
                    for b in tagBytes {
                        len = len << 7
                        len += UInt(b & 0x7f)
                    }
                    return .tag(len, constructed: treeObject.constructed, nil, children).writing()
                case .universal(tag: .octetString):
                    var octets: [UInt8] = []
                    for child in children {
                        if case .berTerminator = child.type { continue }
                        guard case let .octetString(octet) = child.type else { throw KernelASN1.TypedError(.decodingFailed) }
                        octets.append(contentsOf: octet.value)
                    }
                    return .octetString(.init(data: octets)).writing()
//                case let .universal(tag):
//                    return .tag(.init(tag), constructed: treeObject.constructed)
                default:
//                    print("NO ITS HERE")
//                    print(parsingTree.values.sorted(by: { v0, v1 in
//                        v0.offset < v1.offset
//                    }))
                    throw KernelASN1.TypedError(.parsingFailed, reason: "Cannot parse tree without a root id")
                }
            } else {
                guard
                    let fullBytes = buffer.getBytes(
                        at: buffer.readerIndex + treeObject.offset,
                        length: treeObject.contentLength.length + treeObject.headerLength
                    ),
                    let contentBytes = buffer.getBytes(
                        at: buffer.readerIndex + treeObject.offset + treeObject.headerLength,
                        length: treeObject.contentLength.length
                    )
                else { throw KernelASN1.TypedError(.parsingFailed, reason: "Ran out of bytes") }
                switch treeObject.tag {
                case .universal(tag: .bitString):
                    var obj = ASN1BitString(unusedBits: .init(contentBytes[0] % 8), data: .init(contentBytes.dropFirst()))
                    obj.underlyingData = fullBytes
                    return .bitString(obj).writing()
                case .universal(tag: .bmpString):
                    var obj = ASN1BMPString(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .bmpString(obj).writing()
                case .universal(tag: .boolean):
                    var obj = ASN1Boolean(value: contentBytes[0] == .max)
                    obj.underlyingData = fullBytes
                    return .boolean(obj).writing()
                case .universal(tag: .integer):
                    var obj = ASN1Integer(data: contentBytes)
                    obj.underlyingData = fullBytes
                    return .integer(obj).writing()
                case .universal(tag: .generalString):
                    var obj = ASN1GeneralString(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .generalString(obj).writing()
                case .universal(tag: .generalisedTime):
                    var obj = ASN1GeneralisedTime(.init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .generalisedTime(obj).writing()
                case .universal(tag: .graphicString):
                    var obj = ASN1GraphicString(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .graphicString(obj).writing()
                case .universal(tag: .ia5String):
                    var obj = ASN1IA5String(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .ia5String(obj).writing()
                case .universal(tag: .null):
                    var obj = ASN1Null()
                    obj.underlyingData = fullBytes
                    return .null(obj).writing()
                case .universal(tag: .objectIdentifier):
                    var identifier = [Int]()
                    let v1 = Int(contentBytes[0]) % 0x28
                    let v0 = (Int(contentBytes[0]) - v1) / 0x28
                    identifier.append(v0)
                    identifier.append(v1)
                    
                    var value = 0
                    for byte in contentBytes[1..<contentBytes.count] {
                        if UInt8(byte).and(.asn1.class.contextSpecific, equals: .zero) {
                            value = value << 7 + Int(byte)
                            identifier.append(value)
                            value = 0
                        }
                        else { value = value << 7 + Int(byte & .asn1.mask.multiByteMask) }
                    }
                    var obj = ASN1ObjectIdentifier(identifier: identifier)
                    obj.underlyingData = fullBytes
                    return .objectIdentifier(obj).writing()
                case .universal(tag: .octetString):
                    var obj = ASN1OctetString(data: .init(contentBytes))
                    obj.underlyingData = fullBytes
                    return .octetString(obj).writing()
                case .universal(tag: .printableString):
                    var obj = ASN1PrintableString(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .printableString(obj).writing()
                case .universal(tag: .t61String):
                    var obj = ASN1T61String(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .t61String(obj).writing()
                case .universal(tag: .utcTime):
                    var obj = ASN1UTCTime(.init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .utcTime(obj).writing()
                case .universal(tag: .utf8String):
                    var obj = ASN1UTF8String(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .utf8String(obj).writing()
                case .universal(tag: .visibleString):
                    var obj = ASN1VisibleString(string: .init(utf8EncodedBytes: contentBytes))
                    obj.underlyingData = fullBytes
                    return .visibleString(obj).writing()
                case let .contextSpecificSimple(tag):
                    do {
                        let taggedObject = try parsingTree.values.filter({ child in
                            child.treeLevel.parentId == treeObject.id
                        }).first.map { child in
                            try parseTreeObject(id: child.id)
                        }
                        guard let taggedObject else { throw KernelASN1.TypedError(.parsingFailed) }
                        return .tag(.init(tag), constructed: false, taggedObject).writing()
                    }
                    catch {
//                        print(contentBytes, "CONTENT BYTES")
                        let taggedAny: KernelASN1.ASN1Type.VerboseTypeWithMetadata = .any(.init(anyData: contentBytes)).writing()
                        return .tag(.init(tag), constructed: false, taggedAny).writing()
                    }
                    
                case let .contextSpecificStructured(tagBytes):
                    let taggedObject = try parsingTree.values.filter({ child in
                        child.treeLevel.parentId == treeObject.id
                    }).first.map { child in
                        try parseTreeObject(id: child.id)
                    }
                    var len: UInt = 0
                    for b in tagBytes {
                        len = len << 7
                        len += UInt(b & 0x7f)
                    }
                    guard let taggedObject else { throw KernelASN1.TypedError(.decodingFailed) }
                    return .tag(len, constructed: false, taggedObject).writing()
                   
                case .universal(tag: .berTerminator): 
                    return .berTerminator().writing()
                default:
                    throw KernelASN1.TypedError(.parsingFailed, reason: "Unknown object encountered: \(treeObject.tag)" )
                }
            }
        }
        
        
        public mutating func parseObject() throws -> KernelASN1.ASN1Type.VerboseTypeWithMetadata {
            try generateParsingTree()
            return try parseTreeObject()
        }
        
        public static func objectFromBytes(_ bytes: [UInt8]) throws -> ASN1Type.VerboseTypeWithMetadata {
            var parser = ASN1Parser4(bytes: bytes)
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
                    var parser = ASN1Parser4(bytes: arr)
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
