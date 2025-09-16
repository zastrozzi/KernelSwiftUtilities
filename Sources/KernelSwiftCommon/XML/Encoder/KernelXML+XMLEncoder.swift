//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML {
    public final class XMLEncoder: @unchecked Sendable {
        public var charactersEscapedInAttributes = [
            ("&", "&amp;"),
            ("<", "&lt;"),
            (">", "&gt;"),
            ("'", "&apos;"),
            ("\"", "&quot;"),
        ]
        
        public var charactersEscapedInElements = [
            ("&", "&amp;"),
            ("<", "&lt;"),
            (">", "&gt;"),
            ("'", "&apos;"),
            ("\"", "&quot;"),
        ]
        
        public var outputFormatting: OutputFormatting = []
        public var prettyPrintIndentation: PrettyPrintIndentation = .spaces(4)
        public var dateEncodingStrategy: DateEncodingStrategy = .deferredToDate
        public var dataEncodingStrategy: DataEncodingStrategy = .base64
        public var nonConformingFloatEncodingStrategy: NonConformingFloatEncodingStrategy = .throw
        public var keyEncodingStrategy: KeyEncodingStrategy = .useDefaultKeys
        public var nodeEncodingStrategy: NodeEncodingStrategy = .deferredToEncoder
        public var stringEncodingStrategy: StringEncodingStrategy = .deferredToString
        public var userInfo: [CodingUserInfoKey: Any] = [:]
        
        public init() {}
    }
}
extension KernelXML.XMLEncoder {
    public enum PrettyPrintIndentation {
        case spaces(Int)
        case tabs(Int)
    }
}

extension KernelXML.XMLEncoder {
    public struct OutputFormatting: OptionSet, Sendable {
        public let rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        public static let prettyPrinted = OutputFormatting(rawValue: 1 << 0)
        public static let sortedKeys = OutputFormatting(rawValue: 1 << 1)
        public static let noEmptyElements = OutputFormatting(rawValue: 1 << 2)
    }
}
        
extension KernelXML.XMLEncoder {
    public enum NodeEncoding: Sendable {
        case attribute
        case element
        case both
        
        public static let `default`: NodeEncoding = .element
    }
}

extension KernelXML.XMLEncoder {
    public enum DateEncodingStrategy {
        case deferredToDate
        case secondsSince1970
        case millisecondsSince1970
        
        @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
        case iso8601
        case formatted(DateFormatter)
        case custom((Date, Encoder) throws -> ())
    }
}

extension KernelXML.XMLEncoder {
    public enum StringEncodingStrategy {
        case deferredToString
        case cdata
    }
}

extension KernelXML.XMLEncoder {
    public enum DataEncodingStrategy {
        case deferredToData
        case base64
        case custom((Data, Encoder) throws -> ())
    }
}

extension KernelXML.XMLEncoder {
    public enum NonConformingFloatEncodingStrategy {
        case `throw`
        case convertToString(positiveInfinity: String, negativeInfinity: String, nan: String)
    }
}
        
extension KernelXML.XMLEncoder {
    public enum KeyEncodingStrategy {
        case useDefaultKeys
        case convertToSnakeCase
        case convertToKebabCase
        case capitalized
        case uppercased
        case lowercased
        case custom((_ codingPath: [CodingKey]) -> CodingKey)
        
        static func _convertToSnakeCase(_ stringKey: String) -> String {
            return _convert(stringKey, usingSeparator: "_")
        }
        
        static func _convertToKebabCase(_ stringKey: String) -> String {
            return _convert(stringKey, usingSeparator: "-")
        }
        
        static func _convert(_ stringKey: String, usingSeparator separator: String) -> String {
            guard !stringKey.isEmpty else {
                return stringKey
            }
            
            var words: [Range<String.Index>] = []
            var wordStart = stringKey.startIndex
            var searchRange = stringKey.index(after: wordStart)..<stringKey.endIndex
            
            while let upperCaseRange = stringKey.rangeOfCharacter(from: CharacterSet.uppercaseLetters, options: [], range: searchRange) {
                let untilUpperCase = wordStart..<upperCaseRange.lowerBound
                words.append(untilUpperCase)
                
                searchRange = upperCaseRange.lowerBound..<searchRange.upperBound
                guard let lowerCaseRange = stringKey.rangeOfCharacter(from: CharacterSet.lowercaseLetters, options: [], range: searchRange) else {
                    wordStart = searchRange.lowerBound
                    break
                }
                
                let nextCharacterAfterCapital = stringKey.index(after: upperCaseRange.lowerBound)
                if lowerCaseRange.lowerBound == nextCharacterAfterCapital {
                    wordStart = upperCaseRange.lowerBound
                } else {
                    let beforeLowerIndex = stringKey.index(before: lowerCaseRange.lowerBound)
                    words.append(upperCaseRange.lowerBound..<beforeLowerIndex)
                    wordStart = beforeLowerIndex
                }
                searchRange = lowerCaseRange.upperBound..<searchRange.upperBound
            }
            words.append(wordStart..<searchRange.upperBound)
            let result = words.map { range in
                stringKey[range].lowercased()
            }.joined(separator: separator)
            return result
        }
        
        static func _convertToCapitalized(_ stringKey: String) -> String {
            return stringKey.capitalizingFirstLetter()
        }
        
        static func _convertToLowercased(_ stringKey: String) -> String {
            return stringKey.lowercased()
        }
        
        static func _convertToUppercased(_ stringKey: String) -> String {
            return stringKey.uppercased()
        }
    }
}
 
extension KernelXML.XMLEncoder {
    @available(*, deprecated, renamed: "NodeEncodingStrategy")
    public typealias NodeEncodingStrategies = NodeEncodingStrategy
    
    public typealias XMLNodeEncoderClosure = (CodingKey) -> NodeEncoding?
    public typealias XMLEncodingClosure = ((Encodable.Type, Encoder) -> XMLNodeEncoderClosure)
}

extension KernelXML.XMLEncoder {
    public enum NodeEncodingStrategy {
        case deferredToEncoder
        case custom(XMLEncodingClosure)
        
        func nodeEncodings(
            forType codableType: Encodable.Type,
            with encoder: Encoder
        ) -> ((CodingKey) -> NodeEncoding?) {
            return encoderClosure(codableType, encoder)
        }
        
        var encoderClosure: XMLEncodingClosure {
            switch self {
            case .deferredToEncoder: return NodeEncodingStrategy.defaultEncoder
            case let .custom(closure): return closure
            }
        }
        
        nonisolated(unsafe) static let defaultEncoder: XMLEncodingClosure = { codableType, _ in
            guard let dynamicType = codableType as? KernelXML.DynamicNodeEncoding.Type else {
                return { _ in nil }
            }
            return dynamicType.nodeEncoding(for:)
        }
    }
}

extension KernelXML.XMLEncoder {
    struct Options {
        let dateEncodingStrategy: DateEncodingStrategy
        let dataEncodingStrategy: DataEncodingStrategy
        let nonConformingFloatEncodingStrategy: NonConformingFloatEncodingStrategy
        let keyEncodingStrategy: KeyEncodingStrategy
        let nodeEncodingStrategy: NodeEncodingStrategy
        let stringEncodingStrategy: StringEncodingStrategy
        let userInfo: [CodingUserInfoKey: Any]
    }
    
    var options: Options {
        return Options(dateEncodingStrategy: dateEncodingStrategy,
                       dataEncodingStrategy: dataEncodingStrategy,
                       nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy,
                       keyEncodingStrategy: keyEncodingStrategy,
                       nodeEncodingStrategy: nodeEncodingStrategy,
                       stringEncodingStrategy: stringEncodingStrategy,
                       userInfo: userInfo)
    }

    public func encode<T: Encodable>(
        _ value: T,
        withRootKey rootKey: String? = nil,
        rootAttributes: [String: String]? = nil,
        header: KernelXML.Header? = nil,
        doctype: KernelXML.DocumentType? = nil
    ) throws -> Data {
        let encoder = KernelXML.SynchronousXMLEncoder(options: options, nodeEncodings: [])
        encoder.nodeEncodings.append(options.nodeEncodingStrategy.nodeEncodings(forType: T.self, with: encoder))
        
        let topLevel = try encoder.box(value)
        let attributes = rootAttributes?.map(KernelXML.XMLCoderElement.Attribute.init) ?? []
        
        let elementOrNone: KernelXML.XMLCoderElement?
        
        let rootKey = rootKey ?? "\(T.self)".convert(for: keyEncodingStrategy)
        
        let isStringBoxCDATA = stringEncodingStrategy == .cdata
        
        if let keyedBox = topLevel as? KernelXML.KeyedBox {
            elementOrNone = KernelXML.XMLCoderElement(
                key: rootKey,
                isStringBoxCDATA: isStringBoxCDATA,
                box: keyedBox,
                attributes: attributes
            )
        } else if let unkeyedBox = topLevel as? KernelXML.UnkeyedBox {
            elementOrNone = KernelXML.XMLCoderElement(
                key: rootKey,
                isStringBoxCDATA: isStringBoxCDATA,
                box: unkeyedBox,
                attributes: attributes
            )
        } else if let choiceBox = topLevel as? KernelXML.ChoiceBox {
            elementOrNone = KernelXML.XMLCoderElement(
                key: rootKey,
                isStringBoxCDATA: isStringBoxCDATA,
                box: choiceBox,
                attributes: attributes
            )
        } else {
            fatalError("Unrecognized top-level element of type: \(type(of: topLevel))")
        }
        
        guard let element = elementOrNone else {
            throw EncodingError.invalidValue(value, EncodingError.Context(
                codingPath: [],
                debugDescription: "Unable to encode the given top-level value to XML."
            ))
        }
        
        return element.toXMLString(
            with: header,
            doctype: doctype,
            escapedCharacters: (
                elements: charactersEscapedInElements,
                attributes: charactersEscapedInAttributes
            ),
            formatting: outputFormatting,
            indentation: prettyPrintIndentation
        ).data(using: .utf8, allowLossyConversion: true)!
    }
#if canImport(Combine) || canImport(OpenCombine)
    public func encode<T>(_ value: T) throws -> Data where T: Encodable {
        return try encode(value, withRootKey: nil, rootAttributes: nil, header: nil)
    }
#endif
}

private extension String {
    func convert(for encodingStrategy: KernelXML.XMLEncoder.KeyEncodingStrategy) -> String {
        switch encodingStrategy {
        case .useDefaultKeys:
            return self
        case .convertToSnakeCase:
            return KernelXML.XMLEncoder.KeyEncodingStrategy._convertToSnakeCase(self)
        case .convertToKebabCase:
            return KernelXML.XMLEncoder.KeyEncodingStrategy._convertToKebabCase(self)
        case .custom:
            return self
        case .capitalized:
            return KernelXML.XMLEncoder.KeyEncodingStrategy._convertToCapitalized(self)
        case .uppercased:
            return KernelXML.XMLEncoder.KeyEncodingStrategy._convertToUppercased(self)
        case .lowercased:
            return KernelXML.XMLEncoder.KeyEncodingStrategy._convertToLowercased(self)
        }
    }
}
