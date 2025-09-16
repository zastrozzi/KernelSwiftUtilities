//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML {
    class SynchronousXMLEncoder: Encoder {
        var storage: EncodingStorage
        let options: XMLEncoder.Options
        public var codingPath: [CodingKey]
        public var nodeEncodings: [(CodingKey) -> XMLEncoder.NodeEncoding?]
        public var userInfo: [CodingUserInfoKey: Any] {
            return options.userInfo
        }
        
        init(
            options: XMLEncoder.Options,
            nodeEncodings: [(CodingKey) -> XMLEncoder.NodeEncoding?],
            codingPath: [CodingKey] = []
        ) {
            self.options = options
            storage = EncodingStorage()
            self.codingPath = codingPath
            self.nodeEncodings = nodeEncodings
        }
        
        var canEncodeNewValue: Bool { storage.count == codingPath.count }
        
        public func container<Key>(keyedBy _: Key.Type) -> KeyedEncodingContainer<Key> {
            guard canEncodeNewValue else {
                return mergeWithExistingKeyedContainer(keyedBy: Key.self)
            }
            if Key.self is KernelXML.ChoiceCodingKey.Type {
                return choiceContainer(keyedBy: Key.self)
            } else {
                return keyedContainer(keyedBy: Key.self)
            }
        }
        
        public func unkeyedContainer() -> UnkeyedEncodingContainer {
            let topContainer: SharedBox<UnkeyedBox>
            if canEncodeNewValue {
                topContainer = storage.pushUnkeyedContainer()
            } else {
                guard let container = storage.lastContainer as? SharedBox<UnkeyedBox> else {
                    preconditionFailure(
                    """
                    Attempt to push new unkeyed encoding container when already previously encoded \
                    at this path.
                    """
                    )
                }
                
                topContainer = container
            }
            
            return XMLUnkeyedEncodingContainer(referencing: self, codingPath: codingPath, wrapping: topContainer)
        }
        
        public func singleValueContainer() -> SingleValueEncodingContainer {
            return self
        }
        
        private func keyedContainer<Key>(keyedBy _: Key.Type) -> KeyedEncodingContainer<Key> {
            let container = XMLKeyedEncodingContainer<Key>(
                referencing: self,
                codingPath: codingPath,
                wrapping: storage.pushKeyedContainer()
            )
            return KeyedEncodingContainer(container)
        }
        
        private func choiceContainer<Key>(keyedBy _: Key.Type) -> KeyedEncodingContainer<Key> {
            let container = XMLChoiceEncodingContainer<Key>(
                referencing: self,
                codingPath: codingPath,
                wrapping: storage.pushChoiceContainer()
            )
            return KeyedEncodingContainer(container)
        }
        
        private func mergeWithExistingKeyedContainer<Key>(keyedBy _: Key.Type) -> KeyedEncodingContainer<Key> {
            switch storage.lastContainer {
            case let keyed as SharedBox<KeyedBox>:
                let container = XMLKeyedEncodingContainer<Key>(
                    referencing: self,
                    codingPath: codingPath,
                    wrapping: keyed
                )
                return KeyedEncodingContainer(container)
            case let choice as SharedBox<ChoiceBox>:
                _ = storage.popContainer()
                let keyed = KeyedBox(
                    elements: KeyedBox.Elements([choice.withShared { ($0.key, $0.value) }]),
                    attributes: []
                )
                let container = XMLKeyedEncodingContainer<Key>(
                    referencing: self,
                    codingPath: codingPath,
                    wrapping: storage.pushKeyedContainer(keyed)
                )
                return KeyedEncodingContainer(container)
            default:
                preconditionFailure(
                """
                No existing keyed encoding container to merge with.
                """
                )
            }
        }
    }
}

extension KernelXML.SynchronousXMLEncoder {
    func box() -> KernelXML.SimpleBoxable {
        return KernelXML.NullBox()
    }
    
    func box(_ value: Bool) -> KernelXML.SimpleBoxable {
        return KernelXML.BooleanBox(value)
    }
    
    func box(_ value: Decimal) -> KernelXML.SimpleBoxable {
        return KernelXML.DecimalBox(value)
    }
    
    func box<T: BinaryInteger & SignedInteger & Encodable>(_ value: T) -> KernelXML.SimpleBoxable {
        return KernelXML.IntBox(value)
    }
    
    func box<T: BinaryInteger & UnsignedInteger & Encodable>(_ value: T) -> KernelXML.SimpleBoxable {
        return KernelXML.UIntBox(value)
    }
    
    func box(_ value: Float) throws -> KernelXML.SimpleBoxable {
        return try box(value, KernelXML.FloatBox.self)
    }
    
    func box(_ value: Double) throws -> KernelXML.SimpleBoxable {
        return try box(value, KernelXML.DoubleBox.self)
    }
    
    func box<T: BinaryFloatingPoint & Encodable, B: KernelXML.ValueBoxable>(
        _ value: T,
        _: B.Type
    ) throws -> KernelXML.SimpleBoxable where B.Value == T {
        guard value.isInfinite || value.isNaN else {
            return B(value)
        }
        guard case let .convertToString(
            positiveInfinity: posInfString,
            negativeInfinity: negInfString,
            nan: nanString
        ) = options.nonConformingFloatEncodingStrategy else {
            throw EncodingError._invalidFloatingPointValue(value, at: codingPath)
        }
        if value == T.infinity {
            return KernelXML.StringBox(posInfString)
        } else if value == -T.infinity {
            return KernelXML.StringBox(negInfString)
        } else {
            return KernelXML.StringBox(nanString)
        }
    }
    
    func box(_ value: String) -> KernelXML.SimpleBoxable {
        return KernelXML.StringBox(value)
    }
    
    func box(_ value: Date) throws -> KernelXML.Boxable {
        switch options.dateEncodingStrategy {
        case .deferredToDate:
            try value.encode(to: self)
            return storage.popContainer()
        case .secondsSince1970:
            return KernelXML.DateBox(value, format: .secondsSince1970)
        case .millisecondsSince1970:
            return KernelXML.DateBox(value, format: .millisecondsSince1970)
        case .iso8601:
            return KernelXML.DateBox(value, format: .iso8601)
        case let .formatted(formatter):
            return KernelXML.DateBox(value, format: .formatter(formatter))
        case let .custom(closure):
            let depth = storage.count
            try closure(value, self)
            
            guard storage.count > depth else {
                return KernelXML.KeyedBox()
            }
            
            return storage.popContainer()
        }
    }
    
    func box(_ value: Data) throws -> KernelXML.Boxable {
        switch options.dataEncodingStrategy {
        case .deferredToData:
            try value.encode(to: self)
            return storage.popContainer()
        case .base64:
            return KernelXML.DataBox(value, format: .base64)
        case let .custom(closure):
            let depth = storage.count
            try closure(value, self)
            
            guard storage.count > depth else {
                return KernelXML.KeyedBox()
            }
            
            return storage.popContainer()
        }
    }
    
    func box(_ value: URL) -> KernelXML.SimpleBoxable {
        return KernelXML.URLBox(value)
    }
    
    func box<T: Encodable>(_ value: T) throws -> KernelXML.Boxable {
        if T.self == Date.self || T.self == NSDate.self,
           let value = value as? Date
        {
            return try box(value)
        } else if T.self == Data.self || T.self == NSData.self,
                  let value = value as? Data
        {
            return try box(value)
        } else if T.self == URL.self || T.self == NSURL.self,
                  let value = value as? URL
        {
            return box(value)
        } else if T.self == Decimal.self || T.self == NSDecimalNumber.self,
                  let value = value as? Decimal
        {
            return box(value)
        }
        
        let depth = storage.count
        try value.encode(to: self)
        
        guard storage.count > depth else {
            return KernelXML.KeyedBox()
        }
        
        let lastContainer = storage.popContainer()
        
        guard let sharedBox = lastContainer as? KernelXML.TypeErasedSharedBoxable else {
            return lastContainer
        }
        
        return sharedBox.typeErasedUnbox()
    }
}
