//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/06/2025.
//

import Foundation

extension KernelXML {
    struct XMLChoiceDecodingContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
        typealias Key = K
        private let decoder: SynchronousXMLDecoder
        private let container: SharedBox<ChoiceBox>
        public private(set) var codingPath: [CodingKey]
        
        init(referencing decoder: SynchronousXMLDecoder, wrapping container: SharedBox<ChoiceBox>) {
            self.decoder = decoder
            container.withShared { $0.key = decoder.keyTransform($0.key) }
            self.container = container
            codingPath = decoder.codingPath
        }
        
        public var allKeys: [Key] {
            return container.withShared { [Key(stringValue: $0.key)!] }
        }
        
        public func contains(_ key: Key) -> Bool {
            return container.withShared { $0.key == key.stringValue }
        }
        
        public func decodeNil(forKey key: Key) throws -> Bool {
            return container.withShared { $0.value.isNull }
        }
        
        public func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
            guard container.withShared({ $0.key == key.stringValue }), key is KernelXML.ChoiceCodingKey else {
                throw DecodingError.typeMismatch(
                    at: codingPath,
                    expectation: type,
                    found: container
                )
            }
            return try decoder.unbox(container.withShared { $0.value })
        }
        
        public func nestedContainer<NestedKey>(
            keyedBy _: NestedKey.Type, forKey key: Key
        ) throws -> KeyedDecodingContainer<NestedKey> {
            guard container.value.key == key.stringValue else {
                throw DecodingError.typeMismatch(
                    at: codingPath,
                    expectation: NestedKey.self,
                    found: container
                )
            }
            
            let value = container.value.value
            guard let container = XMLKeyedDecodingContainer<NestedKey>(box: value, decoder: decoder) else {
                throw DecodingError.typeMismatch(
                    at: codingPath,
                    expectation: [String: Any].self,
                    found: value
                )
            }
            
            return KeyedDecodingContainer(container)
        }
        
        public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            throw DecodingError.typeMismatch(
                at: codingPath,
                expectation: Key.self,
                found: container
            )
        }
        
        public func superDecoder() throws -> Decoder {
            throw DecodingError.typeMismatch(
                at: codingPath,
                expectation: Key.self,
                found: container
            )
        }
        
        public func superDecoder(forKey key: Key) throws -> Decoder {
            throw DecodingError.typeMismatch(
                at: codingPath,
                expectation: Key.self,
                found: container
            )
        }
    }
}
