//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/06/2025.
//

import Foundation

extension KernelXML {
    class SynchronousXMLDecoder: Decoder {
        var storage = XMLDecodingStorage()
        let options: XMLDecoder.Options
        public internal(set) var codingPath: [CodingKey]
        public var nodeDecodings: [(CodingKey) -> XMLDecoder.NodeDecoding?]
        
        public var userInfo: [CodingUserInfoKey: Any] {
            return options.userInfo
        }
        
        open var errorContextLength: UInt = 0
        
        init(
            referencing container: Boxable,
            options: XMLDecoder.Options,
            nodeDecodings: [(CodingKey) -> XMLDecoder.NodeDecoding?],
            codingPath: [CodingKey] = []
        ) {
            storage.push(container: container)
            self.codingPath = codingPath
            self.nodeDecodings = nodeDecodings
            self.options = options
        }
        
        internal func topContainer() throws -> Boxable {
            guard let topContainer = storage.topContainer() else {
                throw DecodingError.valueNotFound(Boxable.self, DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Cannot get decoding container -- empty container stack."
                ))
            }
            return topContainer
        }
        
        private func popContainer() throws -> Boxable {
            guard let topContainer = storage.popContainer() else {
                throw DecodingError.valueNotFound(Boxable.self, DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription:
                """
                Cannot get decoding container -- empty container stack.
                """
                ))
            }
            return topContainer
        }
        
        public func container<Key>(keyedBy keyType: Key.Type) throws -> KeyedDecodingContainer<Key> {
            if let keyed = try topContainer() as? SharedBox<KeyedBox> {
                return KeyedDecodingContainer(XMLKeyedDecodingContainer<Key>(
                    referencing: self,
                    wrapping: keyed
                ))
            }
            if Key.self is ChoiceCodingKey.Type {
                return try choiceContainer(keyedBy: keyType)
            } else {
                return try keyedContainer(keyedBy: keyType)
            }
        }
        
        public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            let topContainer = try self.topContainer()
            
            guard !topContainer.isNull else {
                throw DecodingError.valueNotFound(
                    UnkeyedDecodingContainer.self,
                    DecodingError.Context(
                        codingPath: codingPath,
                        debugDescription:
                    """
                    Cannot get unkeyed decoding container -- found null box instead.
                    """
                    )
                )
            }
            
            switch topContainer {
            case let unkeyed as SharedBox<UnkeyedBox>:
                return XMLUnkeyedDecodingContainer(referencing: self, wrapping: unkeyed)
            case let keyed as SharedBox<KeyedBox>:
                return XMLUnkeyedDecodingContainer(
                    referencing: self,
                    wrapping: SharedBox(keyed.withShared { $0.elements.map(SingleKeyedBox.init) })
                )
            default:
                throw DecodingError.typeMismatch(
                    at: codingPath,
                    expectation: [Any].self,
                    found: topContainer
                )
            }
        }
        
        public func singleValueContainer() throws -> SingleValueDecodingContainer {
            return self
        }
        
        private func keyedContainer<Key>(keyedBy _: Key.Type) throws -> KeyedDecodingContainer<Key> {
            let topContainer = try self.topContainer()
            let keyedBox: KeyedBox
            switch topContainer {
            case _ where topContainer.isNull:
                throw DecodingError.valueNotFound(
                    KeyedDecodingContainer<Key>.self,
                    DecodingError.Context(
                        codingPath: codingPath,
                        debugDescription:
                    """
                    Cannot get keyed decoding container -- found null box instead.
                    """
                    )
                )
            case let string as StringBox:
                keyedBox = KeyedBox(
                    elements: KeyedStorage([("", string)]),
                    attributes: KeyedStorage()
                )
            case let containsEmpty as SingleKeyedBox where containsEmpty.element is NullBox:
                keyedBox = KeyedBox(
                    elements: KeyedStorage([("", StringBox(""))]),
                    attributes: KeyedStorage()
                )
            case let unkeyed as SharedBox<UnkeyedBox>:
                guard let keyed = unkeyed.withShared({ $0.first }) as? KeyedBox else {
                    fallthrough
                }
                keyedBox = keyed
            default:
                throw DecodingError.typeMismatch(
                    at: codingPath,
                    expectation: [String: Any].self,
                    found: topContainer
                )
            }
            let container = XMLKeyedDecodingContainer<Key>(
                referencing: self,
                wrapping: SharedBox(keyedBox)
            )
            return KeyedDecodingContainer(container)
        }
        
        private func choiceContainer<Key>(keyedBy _: Key.Type) throws -> KeyedDecodingContainer<Key> {
            let topContainer = try self.topContainer()
            let choiceBox: ChoiceBox
            switch topContainer {
            case let choice as ChoiceBox:
                choiceBox = choice
            case let singleKeyed as SingleKeyedBox:
                choiceBox = ChoiceBox(singleKeyed)
            default:
                throw DecodingError.typeMismatch(
                    at: codingPath,
                    expectation: [String: Any].self,
                    found: topContainer
                )
            }
            let container = XMLChoiceDecodingContainer<Key>(
                referencing: self,
                wrapping: SharedBox(choiceBox)
            )
            return KeyedDecodingContainer(container)
        }
    }
}

extension KernelXML.SynchronousXMLDecoder {
    private func typedBox<T, B: KernelXML.Boxable>(_ box: KernelXML.Boxable, for valueType: T.Type) throws -> B {
        let error = DecodingError.valueNotFound(valueType, DecodingError.Context(
            codingPath: codingPath,
            debugDescription: "Expected \(valueType) but found null instead."
        ))
        switch box {
        case let typedBox as B:
            return typedBox
        case let unkeyedBox as KernelXML.SharedBox<KernelXML.UnkeyedBox>:
            guard let value = unkeyedBox.withShared({
                $0.first as? B
            }) else { throw error }
            return value
        case let keyedBox as KernelXML.SharedBox<KernelXML.KeyedBox>:
            guard
                let value = keyedBox.withShared({ $0.value as? B })
            else { throw error }
            return value
        case let singleKeyedBox as KernelXML.SingleKeyedBox:
            if let value = singleKeyedBox.element as? B {
                return value
            } else if let box = singleKeyedBox.element as? KernelXML.KeyedBox, let value = box.elements[""].first as? B {
                return value
            } else {
                throw error
            }
        case is KernelXML.NullBox:
            throw error
        case let keyedBox as KernelXML.KeyedBox:
            guard
                let value = keyedBox.value as? B
            else { fallthrough }
            return value
        default:
            throw DecodingError.typeMismatch(
                at: codingPath,
                expectation: valueType,
                found: box
            )
        }
    }
    
    func unbox(_ box: KernelXML.Boxable) throws -> Bool {
        let stringBox: KernelXML.StringBox = try typedBox(box, for: Bool.self)
        let string = stringBox.value
        
        guard let boolBox = KernelXML.BooleanBox(xmlString: string) else {
            throw DecodingError.typeMismatch(at: codingPath, expectation: Bool.self, found: box)
        }
        
        return boolBox.value
    }
    
    func unbox(_ box: KernelXML.Boxable) throws -> Decimal {
        let stringBox: KernelXML.StringBox = try typedBox(box, for: Decimal.self)
        let string = stringBox.value
        
        guard let decimalBox = KernelXML.DecimalBox(xmlString: string) else {
            throw DecodingError.typeMismatch(at: codingPath, expectation: Decimal.self, found: box)
        }
        
        return decimalBox.value
    }
    
    func unbox<T: BinaryInteger & SignedInteger & Decodable>(_ box: KernelXML.Boxable) throws -> T {
        let stringBox: KernelXML.StringBox = try typedBox(box, for: T.self)
        let string = stringBox.value
        
        guard let intBox = KernelXML.IntBox(xmlString: string) else {
            throw DecodingError.typeMismatch(at: codingPath, expectation: T.self, found: box)
        }
        
        guard let int: T = intBox.unbox() else {
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Parsed XML number <\(string)> does not fit in \(T.self)."
            ))
        }
        
        return int
    }
    
    func unbox<T: BinaryInteger & UnsignedInteger & Decodable>(_ box: KernelXML.Boxable) throws -> T {
        let stringBox: KernelXML.StringBox = try typedBox(box, for: T.self)
        let string = stringBox.value
        
        guard let uintBox = KernelXML.UIntBox(xmlString: string) else {
            throw DecodingError.typeMismatch(at: codingPath, expectation: T.self, found: box)
        }
        
        guard let uint: T = uintBox.unbox() else {
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Parsed XML number <\(string)> does not fit in \(T.self)."
            ))
        }
        
        return uint
    }
    
    func unbox(_ box: KernelXML.Boxable) throws -> Float {
        let stringBox: KernelXML.StringBox = try typedBox(box, for: Float.self)
        let string = stringBox.value
        
        guard let floatBox = KernelXML.FloatBox(xmlString: string) else {
            throw DecodingError.typeMismatch(at: codingPath, expectation: Float.self, found: box)
        }
        
        return floatBox.value
    }
    
    func unbox(_ box: KernelXML.Boxable) throws -> Double {
        let stringBox: KernelXML.StringBox = try typedBox(box, for: Double.self)
        let string = stringBox.value
        
        guard let doubleBox = KernelXML.DoubleBox(xmlString: string) else {
            throw DecodingError.typeMismatch(at: codingPath, expectation: Double.self, found: box)
        }
        
        return doubleBox.value
    }
    
    func unbox(_ box: KernelXML.Boxable) throws -> String {
        do {
            let stringBox: KernelXML.StringBox = try typedBox(box, for: String.self)
            return stringBox.value
        } catch {
            if box is KernelXML.NullBox {
                return ""
            }
        }
        
        return ""
    }
    
    func unbox(_ box: KernelXML.Boxable) throws -> Date {
        switch options.dateDecodingStrategy {
        case .deferredToDate:
            storage.push(container: box)
            defer { storage.popContainer() }
            return try Date(from: self)
            
        case .secondsSince1970:
            let stringBox: KernelXML.StringBox = try typedBox(box, for: Date.self)
            let string = stringBox.value
            
            guard let dateBox = KernelXML.DateBox(secondsSince1970: string) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Expected date string to be formatted in seconds since 1970."
                ))
            }
            return dateBox.value
        case .millisecondsSince1970:
            let stringBox: KernelXML.StringBox = try typedBox(box, for: Date.self)
            let string = stringBox.value
            
            guard let dateBox = KernelXML.DateBox(millisecondsSince1970: string) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Expected date string to be formatted in milliseconds since 1970."
                ))
            }
            return dateBox.value
        case .iso8601:
            let stringBox: KernelXML.StringBox = try typedBox(box, for: Date.self)
            let string = stringBox.value
            
            guard let dateBox = KernelXML.DateBox(iso8601: string) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Expected date string to be ISO8601-formatted."
                ))
            }
            return dateBox.value
        case let .formatted(formatter):
            let stringBox: KernelXML.StringBox = try typedBox(box, for: Date.self)
            let string = stringBox.value
            
            guard let dateBox = KernelXML.DateBox(xmlString: string, formatter: formatter) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Date string does not match format expected by formatter."
                ))
            }
            return dateBox.value
        case let .custom(closure):
            storage.push(container: box)
            defer { storage.popContainer() }
            return try closure(self)
        }
    }
    
    func unbox(_ box: KernelXML.Boxable) throws -> Data {
        switch options.dataDecodingStrategy {
        case .deferredToData:
            storage.push(container: box)
            defer { storage.popContainer() }
            return try Data(from: self)
        case .base64:
            let stringBox: KernelXML.StringBox = try typedBox(box, for: Data.self)
            let string = stringBox.value
            
            guard let dataBox = KernelXML.DataBox(base64: string) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Encountered Data is not valid Base64"
                ))
            }
            return dataBox.value
        case let .custom(closure):
            storage.push(container: box)
            defer { storage.popContainer() }
            return try closure(self)
        }
    }
    
    func unbox(_ box: KernelXML.Boxable) throws -> URL {
        let stringBox: KernelXML.StringBox = try typedBox(box, for: URL.self)
        let string = stringBox.value
        
        guard let urlBox = KernelXML.URLBox(xmlString: string) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Encountered Data is not valid Base64"
            ))
        }
        
        return urlBox.value
    }
    
    func unbox<T: Decodable>(_ box: KernelXML.Boxable) throws -> T {
        let decoded: T?
        let type = T.self
        
        if type == Date.self || type == NSDate.self {
            let date: Date = try unbox(box)
            decoded = date as? T
        } else if type == Data.self || type == NSData.self {
            let data: Data = try unbox(box)
            decoded = data as? T
        } else if type == URL.self || type == NSURL.self {
            let data: URL = try unbox(box)
            decoded = data as? T
        } else if type == Decimal.self || type == NSDecimalNumber.self {
            let decimal: Decimal = try unbox(box)
            decoded = decimal as? T
        } else if
            type == String.self || type == NSString.self,
            let value = (try unbox(box) as String) as? T
        {
            decoded = value
        } else {
            storage.push(container: box)
            defer {
                storage.popContainer()
            }
            
            do {
                decoded = try type.init(from: self)
            } catch {
                guard case DecodingError.valueNotFound = error,
                      let type = type as? KernelXML.XMLOptional.Type,
                      let result = type.init() as? T
                else {
                    throw error
                }
                
                return result
            }
        }
        
        guard let result = decoded else {
            throw DecodingError.typeMismatch(
                at: codingPath, expectation: type, found: box
            )
        }
        
        return result
    }
}

extension KernelXML.SynchronousXMLDecoder {
    var keyTransform: (String) -> String {
        switch options.keyDecodingStrategy {
        case .convertFromSnakeCase:
            return KernelXML.XMLDecoder.KeyDecodingStrategy._convertFromSnakeCase
        case .convertFromCapitalized:
            return KernelXML.XMLDecoder.KeyDecodingStrategy._convertFromCapitalized
        case .convertFromUppercase:
            return KernelXML.XMLDecoder.KeyDecodingStrategy._convertFromUppercase
        case .convertFromKebabCase:
            return KernelXML.XMLDecoder.KeyDecodingStrategy._convertFromKebabCase
        case .useDefaultKeys:
            return { key in key }
        case let .custom(converter):
            return { key in
                converter(self.codingPath + [KernelXML.XMLKey(stringValue: key, intValue: nil)]).stringValue
            }
        }
    }
}
