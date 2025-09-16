//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation


extension KernelNetworking {
    final class URIValueToNodeEncoder {
        struct CodingStackEntry {
            var key: URICoderCodingKey
            var storage: URIEncodedNode
        }
        
        enum GeneralError: Swift.Error {
            case nilNotSupported
            case dataNotSupported
            case integerOutOfRange
        }
        
        private var _codingPath: [CodingStackEntry]
        
        var currentStackEntry: CodingStackEntry
        
        init() {
            self._codingPath = []
            self.currentStackEntry = CodingStackEntry(key: .init(stringValue: ""), storage: .unset)
        }
        
        func encodeValue(_ value: some Encodable) throws -> URIEncodedNode {
            defer {
                _codingPath = []
                currentStackEntry = CodingStackEntry(key: .init(stringValue: ""), storage: .unset)
            }
            
            if let date = value as? Date {
                var container = singleValueContainer()
                try container.encode(date)
            } else {
                try value.encode(to: self)
            }
            
            let encodedValue = currentStackEntry.storage
            return encodedValue
        }
    }
}

extension KernelNetworking.URIValueToNodeEncoder {
    func push(key: KernelNetworking.URICoderCodingKey, newStorage: KernelNetworking.URIEncodedNode) {
        _codingPath.append(currentStackEntry)
        currentStackEntry = .init(key: key, storage: newStorage)
    }
    
    func pop() throws {
        let current = currentStackEntry
        var newCurrent = _codingPath.removeLast()
        try newCurrent.storage.insert(current.storage, atKey: current.key)
        currentStackEntry = newCurrent
    }
}

extension KernelNetworking.URIValueToNodeEncoder: Encoder {
    
    var codingPath: [any CodingKey] {
        (_codingPath.dropFirst().map(\.key) + [currentStackEntry.key]).map { $0 as any CodingKey }
    }
    
    var userInfo: [CodingUserInfoKey: Any] { [:] }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        KeyedEncodingContainer(KernelNetworking.URIKeyedEncodingContainer(encoder: self))
    }
    
    func unkeyedContainer() -> any UnkeyedEncodingContainer { KernelNetworking.URIUnkeyedEncodingContainer(encoder: self) }
    
    func singleValueContainer() -> any SingleValueEncodingContainer { KernelNetworking.URISingleValueEncodingContainer(encoder: self) }
}
