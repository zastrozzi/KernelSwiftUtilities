//
//  File.swift
//
//
//  Created by Jonathan Forbes on 18/09/2023.
//

import Foundation
import Collections
import Vapor
import KernelSwiftCommon

extension KernelCBOR {
    public struct CBORParser {
        private var buffer: ByteBuffer
        private var options: CBORCodingOptions
        
        private var parserTotalLength: Int = 0
        private var parserCurrentOffset: Int = 0
        private var parsingTree: Dictionary<UUID, CBORParserTypeMetadata> = [:]
        private var rootId: UUID? = nil
        
        public init(bytes: [UInt8], options: CBORCodingOptions = .init()) {
            self.buffer = .init(bytes: bytes)
            self.options = options
            self.parserTotalLength = bytes.endIndex - bytes.startIndex
            self.parserCurrentOffset = 0
        }
        
        public init(bytes: Deque<UInt8>, options: CBORCodingOptions = .init()) {
            self.buffer = .init(bytes: bytes)
            self.options = options
            self.parserTotalLength = bytes.endIndex - bytes.startIndex
            self.parserCurrentOffset = 0
        }
        
        public mutating func parseObject() throws -> KernelCBOR.CBORType {
            try generateParsingTree()
            guard let rootId else { throw TypedError(.noRootType) }
            return try parseTreeObject(id: rootId)
        }
        
        public static func objectFromBytes(_ bytes: [UInt8]) throws -> KernelCBOR.CBORType {
            var parser = CBORParser(bytes: bytes)
            return try parser.parseObject()
        }
        
        public mutating func generateParsingTree() throws {
            while parserTotalLength > parserCurrentOffset {
                try generateNextTypeMetadata()
            }
        }
        
        @discardableResult
        mutating func generateNextTypeMetadata(offset: Int = 0, treeLevel: Int = 0, parentId: UUID? = nil, keyId: UUID? = nil) throws -> KernelCBOR.CBORParserTypeMetadata {
            let readerOffset = offset + parserCurrentOffset
            guard
                buffer.readableBytes > 0 + readerOffset,
                let initialByte = buffer.getBytes(at: buffer.readerIndex + readerOffset, length: 1)?.first
            else { throw TypedError(.notEnoughBytes) }
            var metadata: KernelCBOR.CBORParserTypeMetadata = .init(
                initialByte: initialByte,
                offset: readerOffset,
                treeLevel: treeLevel,
                parentId: parentId,
                keyId: keyId
            )
            var resolvedContentLength: Int = 0
            if rootId == nil { rootId = metadata.id }
            parserCurrentOffset += metadata.headerLength.resolvedLength
            switch metadata.contentLength {
            case let .lengthBytes(length):
                guard
                    buffer.readableBytes > 0 + readerOffset + length,
                    let lengthBytes = buffer.getBytes(at: buffer.readerIndex + readerOffset + 1, length: length)
                else { throw TypedError(.notEnoughBytes) }
                resolvedContentLength = .init(bigEndianBytes: lengthBytes)
                parserCurrentOffset += resolvedContentLength
            case let .initialByteLength(length):
                resolvedContentLength = length
                parserCurrentOffset += resolvedContentLength
            case .terminated:
                switch metadata.rawType {
                case .array:
                    var reachedTerminator = false
                    var accumulatedLength = 0
                    while !reachedTerminator {
                        let item = try generateNextTypeMetadata(offset: 0, treeLevel: treeLevel + 1, parentId: metadata.id)
                        accumulatedLength += item.combinedLength
                        if case .break = item.rawType { reachedTerminator = true }
                    }
                    resolvedContentLength = accumulatedLength
                case .map:
                    var reachedTerminator = false
                    var accumulatedLength = 0
                    while !reachedTerminator {
                        let key = try generateNextTypeMetadata(offset: 0, treeLevel: treeLevel + 1, parentId: metadata.id)
                        accumulatedLength += key.combinedLength
                        if case .break = key.rawType { reachedTerminator = true }
                        else {
                            let value = try generateNextTypeMetadata(offset: 0, treeLevel: treeLevel + 1, parentId: metadata.id, keyId: key.id)
                            accumulatedLength += value.combinedLength
                        }
                    }
                    resolvedContentLength = accumulatedLength
                case .byteString:
                    var reachedTerminator = false
                    var accumulatedLength = 0
                    while !reachedTerminator {
                        let item = try generateNextTypeMetadata(offset: 0, treeLevel: treeLevel + 1, parentId: metadata.id)
                        accumulatedLength += item.combinedLength
                        if case .break = item.rawType { reachedTerminator = true }
                        else if case .byteString = item.rawType { continue }
                        else { throw TypedError(.invalidType) }
                    }
                    resolvedContentLength = accumulatedLength
                case .utf8String:
                    var reachedTerminator = false
                    var accumulatedLength = 0
                    while !reachedTerminator {
                        let item = try generateNextTypeMetadata(offset: 0, treeLevel: treeLevel + 1, parentId: metadata.id)
                        accumulatedLength += item.combinedLength
                        if case .break = item.rawType { reachedTerminator = true }
                        else if case .utf8String = item.rawType { continue }
                        else { throw TypedError(.invalidType) }
                    }
                    resolvedContentLength = accumulatedLength
                default: throw TypedError(.invalidType)
                    //                    guard let nextTerminator = buffer.viewBytes(at: buffer.readerIndex + readerOffset, length: buffer.readableBytes - (buffer.readerIndex - readerOffset))?.firstIndex(of: .cbor.initialByte.break) else {
                    //                        throw Error(.missingTerminator)
                    //                    }
                    //                    resolvedContentLength = nextTerminator
                    //                    parserCurrentOffset += resolvedContentLength
                }
                
            case let .lengthByteItems(length):
                guard
                    buffer.readableBytes > readerOffset + length,
                    let lengthByteItems = buffer.getBytes(at: buffer.readerIndex + readerOffset + 1, length: length)
                else { throw TypedError(.notEnoughBytes) }
                let lengthItems: Int = .init(bigEndianBytes: lengthByteItems)
                
                for _ in 0..<lengthItems {
                    if case .map = metadata.rawType {
                        let key = try generateNextTypeMetadata(offset: 0, treeLevel: treeLevel + 1, parentId: metadata.id)
                        let value = try generateNextTypeMetadata(offset: 0, treeLevel: treeLevel + 1, parentId: metadata.id, keyId: key.id)
                        resolvedContentLength += key.combinedLength
                        resolvedContentLength += value.combinedLength
                    }
                    else {
                        let item = try generateNextTypeMetadata(offset: 0, treeLevel: treeLevel + 1, parentId: metadata.id)
                        resolvedContentLength += item.combinedLength
                    }
                }
            case let .lengthItems(lengthItems):
                
                for _ in 0..<lengthItems {
                    if case .map = metadata.rawType {
                        let key = try generateNextTypeMetadata(offset: 0, treeLevel: treeLevel + 1, parentId: metadata.id)
                        let value = try generateNextTypeMetadata(offset: 0, treeLevel: treeLevel + 1, parentId: metadata.id, keyId: key.id)
                        resolvedContentLength += key.combinedLength
                        resolvedContentLength += value.combinedLength
                    }
                    else {
                        let item = try generateNextTypeMetadata(offset: 0, treeLevel: treeLevel + 1, parentId: metadata.id)
                        resolvedContentLength += item.combinedLength
                    }
                }
            case .tagged:
                let item = try generateNextTypeMetadata(offset: 0, treeLevel: treeLevel + 1, parentId: metadata.id)
                resolvedContentLength += item.combinedLength
            default: break
            }
            
            metadata.resolveContentLength(resolvedContentLength)
            parsingTree.updateValue(metadata, forKey: metadata.id)
            return metadata
        }
        
        func parseTreeObject(id: UUID) throws -> KernelCBOR.CBORType {
            guard let treeObject = parsingTree[id] else { throw TypedError(.missingTreeObjectMetadata) }
            switch treeObject.rawType {
            case .unsignedInt:
                guard treeObject.resolvedContentLength > 0 else { return .unsignedInt(.init(treeObject.initialByte)) }
                guard let contentBytes = buffer.getBytes(at: treeObject.contentByteOffset, length: treeObject.resolvedContentLength) else { throw TypedError(.notEnoughBytes) }
                return .unsignedInt(.init(bigEndianBytes: contentBytes))
            case .negativeInt:
                guard treeObject.resolvedContentLength > 0 else { return .negativeInt(.init(treeObject.initialByte)) }
                guard let contentBytes = buffer.getBytes(at: treeObject.contentByteOffset, length: treeObject.resolvedContentLength) else { throw TypedError(.notEnoughBytes) }
                return .negativeInt(.init(bigEndianBytes: contentBytes))
            case .byteString:
                if case .terminated = treeObject.contentLength {
                    return .byteString(.init(try parsingTree.values
                        .filter { $0.parentId == id && $0.rawType == .byteString }
                        .sorted { $0.offset < $1.offset }
                        .map {
                            guard let contentBytes = buffer.getBytes(at: $0.contentByteOffset, length: $0.resolvedContentLength) else { throw TypedError(.notEnoughBytes) }
                            return contentBytes
                        }
                        .joined()
                    ))
                }
                else {
                    guard let contentBytes = buffer.getBytes(at: treeObject.contentByteOffset, length: treeObject.resolvedContentLength) else { throw TypedError(.notEnoughBytes) }
                    return .byteString(contentBytes)
                }
            case .utf8String:
                if case .terminated = treeObject.contentLength {
                    return .utf8String(.init(utf8EncodedBytes: .init(try parsingTree.values
                        .filter { $0.parentId == id && $0.rawType == .utf8String }
                        .sorted { $0.offset < $1.offset }
                        .map {
                            guard let contentBytes = buffer.getBytes(at: $0.contentByteOffset, length: $0.resolvedContentLength) else { throw TypedError(.notEnoughBytes) }
                            return contentBytes
                        }
                        .joined()
                    )))
                }
                else {
                    guard let contentBytes = buffer.getBytes(at: treeObject.contentByteOffset, length: treeObject.resolvedContentLength) else { throw TypedError(.notEnoughBytes) }
                    return .utf8String(.init(utf8EncodedBytes: contentBytes))
                }
            case .array:
                return .array(try parsingTree.values
                    .filter { $0.parentId == id && $0.rawType != .break }
                    .sorted { $0.offset < $1.offset }
                    .map { try parseTreeObject(id: $0.id) }
                )
            case .map:
                return try parsingTree
                    .filter { $0.value.parentId == id && $0.value.rawType != .break && $0.value.keyId != nil }
                    .map { valueObject in
                        let valueDecoded = try parseTreeObject(id: valueObject.key)
                        let keyDecoded = try parseTreeObject(id: valueObject.value.keyId!)
                        return (keyDecoded, valueDecoded)
                    }
                    .reduce(into: [:]) { result, next in
                        result[next.0] = next.1
                    }
            case .tagged:
                if treeObject.headerLength.resolvedLength == 1 {
                    let tag = treeObject.initialByte - .cbor.initialByteMask.tagged
                    guard let cborTag = KernelCBOR.CBORTag(rawValue: .init(tag)) else { throw TypedError(.invalidType) }
                    guard let taggedObject = try? parsingTree
                        .filter( { $0.value.parentId == id })
                        .first.map( { try parseTreeObject(id: $0.key) })
                    else { throw TypedError(.invalidType) }
                    
                    return .tagged(cborTag, taggedObject)
                } else {
                    guard let tagBytes = buffer.getBytes(at: treeObject.offset + 1, length: treeObject.headerLength.resolvedLength - 1) else { throw TypedError(.notEnoughBytes) }
                    let tag: UInt64 = .init(bigEndianBytes: tagBytes)
                    guard let cborTag = KernelCBOR.CBORTag(rawValue: .init(tag)) else { throw TypedError(.invalidType) }
                    guard let taggedObject = try? parsingTree
                        .filter( { $0.value.parentId == id })
                        .first.map( { try parseTreeObject(id: $0.key) })
                    else { throw TypedError(.invalidType) }
                    return .tagged(cborTag, taggedObject)
                }
            case .simple:
                if treeObject.resolvedContentLength == 0 {
                    let simpleValue = treeObject.initialByte - .cbor.initialByteMask.simple
                    return .simple(simpleValue)
                } else {
                    guard let simpleValue = buffer.getBytes(at: treeObject.contentByteOffset, length: treeObject.resolvedContentLength)?.first else { throw TypedError(.notEnoughBytes) }
                    return .simple(simpleValue)
                }
            case .boolean:
                switch treeObject.initialByte {
                case .cbor.initialByte.true: return .boolean(true)
                case .cbor.initialByte.false: return .boolean(false)
                default: throw TypedError(.invalidType)
                }
            case .null: return .null
            case .undefined: return .undefined
            case .half:
                guard let contentBytes = buffer.getBytes(at: treeObject.contentByteOffset, length: treeObject.resolvedContentLength) else { throw TypedError(.notEnoughBytes) }
                let half: KernelNumerics.UniversalFloat16 = Array(contentBytes.reversed()).withUnsafeBytes { $0.load(as: KernelNumerics.UniversalFloat16.self) }
                return .half(half)
            case .float:
                guard let contentBytes = buffer.getBytes(at: treeObject.contentByteOffset, length: treeObject.resolvedContentLength) else { throw TypedError(.notEnoughBytes) }
                let float: Float32 = Array(contentBytes.reversed()).withUnsafeBytes { $0.load(as: Float32.self) }
                return .float(float)
            case .double:
                guard let contentBytes = buffer.getBytes(at: treeObject.contentByteOffset, length: treeObject.resolvedContentLength) else { throw TypedError(.notEnoughBytes) }
                let double: Float64 = Array(contentBytes.reversed()).withUnsafeBytes { $0.load(as: Float64.self) }
                return .double(double)
            case .break: return .break
            default: throw TypedError(.invalidType)
            }
        }
        
        public func rootParsingTreeMetadata() throws -> CBORParserTypeMetadata {
            guard let rootId else { throw TypedError(.noRootType) }
            guard let treeObject = parsingTree[rootId] else { throw TypedError(.missingTreeObjectMetadata) }
            return treeObject
        }
        
        
    }
}
