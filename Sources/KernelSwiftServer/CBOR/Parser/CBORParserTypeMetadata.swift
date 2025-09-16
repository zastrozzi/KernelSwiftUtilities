//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/09/2023.
//

import Foundation

extension KernelCBOR {
    public struct CBORParserTypeMetadata {
        public let id: UUID
        public let initialByte: UInt8
        public var resolvedContentLength: Int = 0
        public var offset: Int
        public var treeLevel: Int
        public var parentId: UUID?
        public var keyId: UUID?
        
        public init(
            id: UUID = .init(),
            initialByte: UInt8,
            offset: Int,
            treeLevel: Int,
            parentId: UUID? = nil,
            keyId: UUID? = nil
        ) {
            self.id = id
            self.initialByte = initialByte
            self.offset = offset
            self.treeLevel = treeLevel
            self.parentId = parentId
            self.keyId = keyId
        }
        
        public mutating func resolveContentLength(_ length: Int) {
            resolvedContentLength = length
        }
        
        public mutating func attachParent(_ newParentId: UUID) {
            parentId = newParentId
        }
        
        public var rawType: CBORRawType { .init(initialByte: initialByte) }
        public var headerLength: CBORParserHeaderLength { .init(initialByte: initialByte) }
        public var contentLength: CBORParserContentLength { .init(initialByte: initialByte) }
        
        public var combinedLength: Int { headerLength.resolvedLength + resolvedContentLength }
        
        public var contentByteOffset: Int { offset + headerLength.resolvedLength }
    }
}
