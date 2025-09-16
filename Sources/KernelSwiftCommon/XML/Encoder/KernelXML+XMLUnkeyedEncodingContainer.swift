//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML {
    struct XMLUnkeyedEncodingContainer: UnkeyedEncodingContainer {
        private let encoder: SynchronousXMLEncoder
        private let container: SharedBox<UnkeyedBox>
        public private(set) var codingPath: [CodingKey]
        public var count: Int { container.withShared { $0.count } }
        
        init(
            referencing encoder: SynchronousXMLEncoder,
            codingPath: [CodingKey],
            wrapping container: SharedBox<UnkeyedBox>
        ) {
            self.encoder = encoder
            self.codingPath = codingPath
            self.container = container
        }
        
        public mutating func encodeNil() throws {
            container.withShared { container in
                container.append(encoder.box())
            }
        }
        
        public mutating func encode<T: Encodable>(_ value: T) throws {
            try encode(value) { encoder, value in
                try encoder.box(value)
            }
        }
        
        private mutating func encode<T: Encodable>(
            _ value: T,
            encode: (SynchronousXMLEncoder, T) throws -> Boxable
        ) rethrows {
            encoder.codingPath.append(XMLKey(index: count))
            defer { self.encoder.codingPath.removeLast() }
            
            try container.withShared { container in
                container.append(try encode(encoder, value))
            }
        }
        
        public mutating func nestedContainer<NestedKey>(
            keyedBy _: NestedKey.Type
        ) -> KeyedEncodingContainer<NestedKey> {
            if NestedKey.self is KernelXML.ChoiceCodingKey.Type {
                return nestedChoiceContainer(keyedBy: NestedKey.self)
            } else {
                return nestedKeyedContainer(keyedBy: NestedKey.self)
            }
        }
        
        public mutating func nestedKeyedContainer<NestedKey>(keyedBy _: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
            codingPath.append(XMLKey(index: count))
            defer { self.codingPath.removeLast() }
            
            let sharedKeyed = SharedBox(KeyedBox())
            self.container.withShared { container in
                container.append(sharedKeyed)
            }
            
            let container = XMLKeyedEncodingContainer<NestedKey>(
                referencing: encoder,
                codingPath: codingPath,
                wrapping: sharedKeyed
            )
            return KeyedEncodingContainer(container)
        }
        
        public mutating func nestedChoiceContainer<NestedKey>(keyedBy _: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
            codingPath.append(XMLKey(index: count))
            defer { self.codingPath.removeLast() }
            
            let sharedChoice = SharedBox(ChoiceBox())
            self.container.withShared { container in
                container.append(sharedChoice)
            }
            
            let container = XMLChoiceEncodingContainer<NestedKey>(
                referencing: encoder,
                codingPath: codingPath,
                wrapping: sharedChoice
            )
            return KeyedEncodingContainer(container)
        }
        
        public mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            codingPath.append(XMLKey(index: count))
            defer { self.codingPath.removeLast() }
            
            let sharedUnkeyed = SharedBox(UnkeyedBox())
            container.withShared { container in
                container.append(sharedUnkeyed)
            }
            
            return XMLUnkeyedEncodingContainer(
                referencing: encoder,
                codingPath: codingPath,
                wrapping: sharedUnkeyed
            )
        }
        
        public mutating func superEncoder() -> Encoder {
            return XMLReferencingEncoder(
                referencing: encoder,
                at: count,
                wrapping: container
            )
        }
    }
}
