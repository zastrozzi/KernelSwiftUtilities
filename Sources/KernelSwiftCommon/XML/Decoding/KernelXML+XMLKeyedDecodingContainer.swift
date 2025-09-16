//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/06/2025.
//

import Foundation

extension KernelXML {
    struct XMLKeyedDecodingContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
        typealias Key = K
        typealias KeyedContainer = SharedBox<KeyedBox>
        typealias UnkeyedContainer = SharedBox<UnkeyedBox>
        
        private let decoder: SynchronousXMLDecoder
        private let container: KeyedContainer
        public private(set) var codingPath: [CodingKey]
        
        init(
            referencing decoder: SynchronousXMLDecoder,
            wrapping container: KeyedContainer
        ) {
            self.decoder = decoder
            container.withShared {
                $0.elements = .init($0.elements.map { (decoder.keyTransform($0), $1) })
                $0.attributes = .init($0.attributes.map { (decoder.keyTransform($0), $1) })
            }
            self.container = container
            codingPath = decoder.codingPath
        }
        
        public var allKeys: [Key] {
            let elementKeys = container.withShared { keyedBox in
                keyedBox.elements.keys.compactMap { Key(stringValue: $0) }
            }
            
            let attributeKeys = container.withShared { keyedBox in
                keyedBox.attributes.keys.compactMap { Key(stringValue: $0) }
            }
            
            return attributeKeys + elementKeys
        }
        
        public func contains(_ key: Key) -> Bool {
            let elements = container.withShared { keyedBox in
                keyedBox.elements[key.stringValue]
            }
            
            let attributes = container.withShared { keyedBox in
                keyedBox.attributes[key.stringValue]
            }
            
            return !elements.isEmpty || !attributes.isEmpty
        }
        
        public func decodeNil(forKey key: Key) throws -> Bool {
            let elements = container.withShared { keyedBox in
                keyedBox.elements[key.stringValue]
            }
            
            let attributes = container.withShared { keyedBox in
                keyedBox.attributes[key.stringValue]
            }
            
            let box = elements.first ?? attributes.first
            
            if box is SingleKeyedBox {
                return false
            }
            
            return box?.isNull ?? true
        }
        
        public func decode<T: Decodable>(
            _ type: T.Type, forKey key: Key
        ) throws -> T {
            let attributeFound = container.withShared { keyedBox in
                !keyedBox.attributes[key.stringValue].isEmpty
            }
            
            let elementFound = container.withShared { keyedBox in
                !keyedBox.elements[key.stringValue].isEmpty || keyedBox.value != nil
            }
            
            if let type = type as? KernelXML.SequenceDecodable.Type,
               !attributeFound,
               !elementFound,
               let result = type.init() as? T
            {
                return result
            }
            
            return try decodeConcrete(type, forKey: key)
        }
        
        public func nestedContainer<NestedKey>(
            keyedBy _: NestedKey.Type, forKey key: Key
        ) throws -> KeyedDecodingContainer<NestedKey> {
            decoder.codingPath.append(key)
            defer { decoder.codingPath.removeLast() }
            
            let elements = self.container.withShared { keyedBox in
                keyedBox.elements[key.stringValue]
            }
            
            let attributes = self.container.withShared { keyedBox in
                keyedBox.attributes[key.stringValue]
            }
            
            guard let value = elements.first ?? attributes.first else {
                throw DecodingError.keyNotFound(key, DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription:
                """
                Cannot get \(KeyedDecodingContainer<NestedKey>.self) -- \
                no value found for key \"\(key.stringValue)\"
                """
                ))
            }
            
            guard let container = XMLKeyedDecodingContainer<NestedKey>(box: value, decoder: decoder) else {
                throw DecodingError.typeMismatch(
                    at: codingPath,
                    expectation: [String: Any].self,
                    found: value
                )
            }
            
            return KeyedDecodingContainer(container)
        }
        
        public func nestedUnkeyedContainer(
            forKey key: Key
        ) throws -> UnkeyedDecodingContainer {
            decoder.codingPath.append(key)
            defer { decoder.codingPath.removeLast() }
            
            let elements = container.value.elements[key.stringValue]
            
            if let containsKeyed = elements as? [KeyedBox], containsKeyed.count == 1, let keyed = containsKeyed.first {
                return XMLUnkeyedDecodingContainer(
                    referencing: decoder,
                    wrapping: SharedBox(keyed.elements.map(SingleKeyedBox.init))
                )
            } else {
                return XMLUnkeyedDecodingContainer(
                    referencing: decoder,
                    wrapping: SharedBox(elements)
                )
            }
        }
        
        public func superDecoder() throws -> Decoder {
            return try _superDecoder(forKey: XMLKey.super)
        }
        
        public func superDecoder(forKey key: Key) throws -> Decoder {
            return try _superDecoder(forKey: key)
        }
    }
}

extension KernelXML.XMLKeyedDecodingContainer {
    internal init?(box: KernelXML.Boxable, decoder: KernelXML.SynchronousXMLDecoder) {
        switch box {
        case let keyedContainer as KeyedContainer:
            self.init(
                referencing: decoder,
                wrapping: keyedContainer
            )
        case let keyedBox as KernelXML.KeyedBox:
            self.init(
                referencing: decoder,
                wrapping: KernelXML.SharedBox(keyedBox)
            )
        case let singleBox as KernelXML.SingleKeyedBox:
            let element = (singleBox.key, singleBox.element)
            let keyedContainer = KernelXML.KeyedBox(elements: [element], attributes: [])
            self.init(
                referencing: decoder,
                wrapping: KernelXML.SharedBox(keyedContainer)
            )
        default:
            return nil
        }
    }
}

extension KernelXML.XMLKeyedDecodingContainer {
    private func _errorDescription(of key: CodingKey) -> String {
        switch decoder.options.keyDecodingStrategy {
        case .convertFromSnakeCase:
            let original = key.stringValue
            let converted = KernelXML.XMLEncoder.KeyEncodingStrategy
                ._convertToSnakeCase(original)
            if converted == original {
                return "\(key) (\"\(original)\")"
            } else {
                return "\(key) (\"\(original)\"), converted to \(converted)"
            }
        default:
            return "\(key) (\"\(key.stringValue)\")"
        }
    }
    
    private func decodeSignedInteger<T>(
        _ type: T.Type,
        forKey key: Key
    ) throws -> T where T: BinaryInteger & SignedInteger & Decodable {
        return try decodeConcrete(type, forKey: key)
    }
    
    private func decodeUnsignedInteger<T>(
        _ type: T.Type,
        forKey key: Key
    ) throws -> T where T: BinaryInteger & UnsignedInteger & Decodable {
        return try decodeConcrete(type, forKey: key)
    }
    
    private func decodeFloatingPoint<T>(
        _ type: T.Type,
        forKey key: Key
    ) throws -> T where T: BinaryFloatingPoint & Decodable {
        return try decodeConcrete(type, forKey: key)
    }
    
    private func decodeConcrete<T: Decodable>(
        _ type: T.Type,
        forKey key: Key
    ) throws -> T {
        guard let strategy = decoder.nodeDecodings.last else {
            preconditionFailure(
                """
                Attempt to access node decoding strategy from empty stack.
                """
            )
        }
        
        let elements = container
            .withShared { keyedBox -> [KernelXML.KeyedBox.Element] in
                return (key.isInlined ? keyedBox.elements.values : keyedBox.elements[key.stringValue]).map {
                    if let singleKeyed = $0 as? KernelXML.SingleKeyedBox {
                        return singleKeyed.element.isNull ? singleKeyed : singleKeyed.element
                    } else {
                        return $0
                    }
                }
            }
        
        let attributes = container.withShared { keyedBox in
            key.isInlined ? keyedBox.attributes.values : keyedBox.attributes[key.stringValue]
        }
        
        decoder.codingPath.append(key)
        let nodeDecodings = decoder.options.nodeDecodingStrategy.nodeDecodings(
            forType: T.self,
            with: decoder
        )
        decoder.nodeDecodings.append(nodeDecodings)
        defer {
            _ = decoder.nodeDecodings.removeLast()
            decoder.codingPath.removeLast()
        }
        
        if strategy(key) != .attribute && elements.isEmpty,
           let empty = (type as? KernelXML.SequenceDecodable.Type)?.init() as? T
        {
            return empty
        }
        
        if strategy(key) != .attribute, elements.isEmpty, attributes.isEmpty, type == String.self, key.stringValue == "", let emptyString = "" as? T {
            let cdata = container.withShared { keyedBox in
                keyedBox.elements["#CDATA"].map {
                    return ($0 as? KernelXML.KeyedBox)?.value ?? $0
                }
            }.first
            return ((cdata as? KernelXML.StringBox)?.value as? T) ?? emptyString
        }
        
        let box: KernelXML.Boxable
        if key.isInlined {
            box = container.typeErasedUnbox()
        } else {
            switch strategy(key) {
            case .attribute?:
                box = try getAttributeBox(for: type, attributes, key)
            case .element?:
                box = try getElementBox(for: type, elements, key)
            case .elementOrAttribute?:
                box = try getAttributeOrElementBox(attributes, elements, key)
            default:
                switch type {
                case is KernelXML.Attributable.Type:
                    box = try getAttributeBox(for: type, attributes, key)
                case is KernelXML.ElementRepresentable.Type:
                    box = try getElementBox(for: type, elements, key)
                default:
                    box = try getAttributeOrElementBox(attributes, elements, key)
                }
            }
        }
        
        let value: T?
        if !(type is KernelXML.SequenceDecodable.Type), let unkeyedBox = box as? KernelXML.UnkeyedBox,
           let first = unkeyedBox.first
        {
            if let singleKeyed = first as? KernelXML.SingleKeyedBox {
                if singleKeyed.element.isNull {
                    value = try decoder.unbox(singleKeyed)
                } else {
                    value = try decoder.unbox(singleKeyed.element)
                }
            } else {
                value = try decoder.unbox(first)
            }
        } else if box.isNull, let type = type as? KernelXML.OptionalAttributable.Type, let nullAttribute = type.init() as? T {
            value = nullAttribute
        } else {
            value = try decoder.unbox(box)
        }
        
        if value == nil, let type = type as? KernelXML.XMLOptional.Type,
           let result = type.init() as? T
        {
            return result
        }
        
        guard let unwrapped = value else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription:
                    "Expected \(type) value but found null instead."
            ))
        }
        return unwrapped
    }
    
    private func getAttributeBox<T: Decodable>(
        for type: T.Type,
        _ attributes: [KernelXML.KeyedBox.Attribute],
        _ key: Key
    ) throws -> KernelXML.Boxable {
        if let box = attributes.first { return box }
        if type is KernelXML.XMLOptional.Type || type is KernelXML.OptionalAttributable.Type { return KernelXML.NullBox() }
        
        throw DecodingError.keyNotFound(key, DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "No attribute found for key \(_errorDescription(of: key))."
        ))
    }
    
    private func getElementBox<T: Decodable>(
        for type: T.Type,
        _ elements: [KernelXML.KeyedBox.Element],
        _ key: Key
    ) throws -> KernelXML.Boxable {
        guard elements.isEmpty else { return elements }
        if type is KernelXML.XMLOptional.Type || type is KernelXML.SequenceDecodable.Type { return elements }
        
        throw DecodingError.keyNotFound(key, DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "No element found for key \(_errorDescription(of: key))."
        ))
    }
    
    private func getAttributeOrElementBox(
        _ attributes: [KernelXML.KeyedBox.Attribute],
        _ elements: [KernelXML.KeyedBox.Element],
        _ key: Key
    ) throws -> KernelXML.Boxable {
        guard
            let anyBox = elements.isEmpty ? attributes.first : elements as KernelXML.Boxable?
        else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription:
                """
                No attribute or element found for key \
                \(_errorDescription(of: key)).
                """
            ))
        }
        return anyBox
    }
    
    private func _superDecoder(forKey key: CodingKey) throws -> Decoder {
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        let elements = container.withShared { keyedBox in
            keyedBox.elements[key.stringValue]
        }
        
        let attributes = container.withShared { keyedBox in
            keyedBox.attributes[key.stringValue]
        }
        
        let box: KernelXML.Boxable = elements.first ?? attributes.first ?? KernelXML.NullBox()
        return KernelXML.SynchronousXMLDecoder(
            referencing: box,
            options: decoder.options,
            nodeDecodings: decoder.nodeDecodings,
            codingPath: decoder.codingPath
        )
    }
}
