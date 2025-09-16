//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/06/2025.
//

import Foundation

extension KernelXML {
    struct XMLUnkeyedDecodingContainer: UnkeyedDecodingContainer {
        private let decoder: SynchronousXMLDecoder
        private let container: SharedBox<UnkeyedBox>
        public private(set) var codingPath: [CodingKey]
        public private(set) var currentIndex: Int
        
        init(referencing decoder: SynchronousXMLDecoder, wrapping container: SharedBox<UnkeyedBox>) {
            self.decoder = decoder
            self.container = container
            codingPath = decoder.codingPath
            currentIndex = 0
        }
        
        public var count: Int? {
            return container.withShared { unkeyedBox in
                unkeyedBox.count
            }
        }
        
        public var isAtEnd: Bool {
            return currentIndex >= count!
        }
        
        public mutating func decodeNil() throws -> Bool {
            guard !isAtEnd else {
                throw DecodingError.valueNotFound(Any?.self, DecodingError.Context(
                    codingPath: decoder.codingPath + [XMLKey(index: currentIndex)],
                    debugDescription: "Unkeyed container is at end."
                ))
            }
            
            let isNull = container.withShared { unkeyedBox in
                unkeyedBox[self.currentIndex].isNull
            }
            
            if isNull {
                currentIndex += 1
                return true
            } else {
                return false
            }
        }
        
        public mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
            return try decode(type) { decoder, box in
                try decoder.unbox(box)
            }
        }
        
        private mutating func decode<T: Decodable>(
            _ type: T.Type,
            decode: (SynchronousXMLDecoder, Boxable) throws -> T?
        ) throws -> T {
            decoder.codingPath.append(XMLKey(index: currentIndex))
            let nodeDecodings = decoder.options.nodeDecodingStrategy.nodeDecodings(
                forType: T.self,
                with: decoder
            )
            decoder.nodeDecodings.append(nodeDecodings)
            defer {
                _ = decoder.nodeDecodings.removeLast()
                _ = decoder.codingPath.removeLast()
            }
            guard !isAtEnd else {
                throw DecodingError.valueNotFound(type, DecodingError.Context(
                    codingPath: decoder.codingPath + [XMLKey(index: currentIndex)],
                    debugDescription: "Unkeyed container is at end."
                ))
            }
            
            decoder.codingPath.append(XMLKey(index: currentIndex))
            defer { self.decoder.codingPath.removeLast() }
            
            let box = container.withShared { unkeyedBox in
                unkeyedBox[self.currentIndex]
            }
            
            var value: T?
            if let singleKeyed = box as? SingleKeyedBox {
                do {
                    value = try decode(decoder, singleKeyed)
                } catch {
                    do {
                        value = try decode(decoder, singleKeyed.element)
                    } catch {
                        value = try decode(decoder, ChoiceBox(key: singleKeyed.key, value: singleKeyed.element))
                    }
                }
            } else {
                value = try decode(decoder, box)
            }
            
            defer { currentIndex += 1 }
            
            if value == nil, let type = type as? KernelXML.XMLOptional.Type,
               let result = type.init() as? T
            {
                return result
            }
            
            guard let decoded: T = value else {
                throw DecodingError.valueNotFound(type, DecodingError.Context(
                    codingPath: decoder.codingPath + [XMLKey(index: currentIndex)],
                    debugDescription: "Expected \(type) but found null instead."
                ))
            }
            
            return decoded
        }
        
        public mutating func nestedContainer<NestedKey>(
            keyedBy _: NestedKey.Type
        ) throws -> KeyedDecodingContainer<NestedKey> {
            decoder.codingPath.append(XMLKey(index: currentIndex))
            defer { self.decoder.codingPath.removeLast() }
            
            guard !isAtEnd else {
                throw DecodingError.valueNotFound(
                    KeyedDecodingContainer<NestedKey>.self, DecodingError.Context(
                        codingPath: codingPath,
                        debugDescription: "Cannot get nested keyed container -- unkeyed container is at end."
                    )
                )
            }
            
            let value = self.container.withShared { unkeyedBox in
                unkeyedBox[self.currentIndex]
            }
            guard !value.isNull else {
                throw DecodingError.valueNotFound(KeyedDecodingContainer<NestedKey>.self, DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Cannot get keyed decoding container -- found null value instead."
                ))
            }
            
            guard let keyedContainer = value as? SharedBox<KeyedBox> else {
                throw DecodingError.typeMismatch(at: codingPath,
                                                 expectation: [String: Any].self,
                                                 found: value)
            }
            
            currentIndex += 1
            let container = XMLKeyedDecodingContainer<NestedKey>(
                referencing: decoder,
                wrapping: keyedContainer
            )
            return KeyedDecodingContainer(container)
        }
        
        public mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            decoder.codingPath.append(XMLKey(index: currentIndex))
            defer { self.decoder.codingPath.removeLast() }
            
            guard !isAtEnd else {
                throw DecodingError.valueNotFound(
                    UnkeyedDecodingContainer.self, DecodingError.Context(
                        codingPath: codingPath,
                        debugDescription: "Cannot get nested keyed container -- unkeyed container is at end."
                    )
                )
            }
            
            let value = container.withShared { unkeyedBox in
                unkeyedBox[self.currentIndex]
            }
            guard !value.isNull else {
                throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self, DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Cannot get keyed decoding container -- found null value instead."
                ))
            }
            
            guard let unkeyedContainer = value as? SharedBox<UnkeyedBox> else {
                throw DecodingError.typeMismatch(at: codingPath,
                                                 expectation: UnkeyedBox.self,
                                                 found: value)
            }
            
            currentIndex += 1
            return XMLUnkeyedDecodingContainer(referencing: decoder, wrapping: unkeyedContainer)
        }
        
        public mutating func superDecoder() throws -> Decoder {
            decoder.codingPath.append(XMLKey(index: currentIndex))
            defer { self.decoder.codingPath.removeLast() }
            
            guard !isAtEnd else {
                throw DecodingError.valueNotFound(Decoder.self, DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Cannot get superDecoder() -- unkeyed container is at end."
                ))
            }
            
            let value = container.withShared { unkeyedBox in
                unkeyedBox[self.currentIndex]
            }
            currentIndex += 1
            
            return SynchronousXMLDecoder(
                referencing: value,
                options: decoder.options,
                nodeDecodings: decoder.nodeDecodings,
                codingPath: decoder.codingPath
            )
        }
    }
}
