//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/06/2025.
//

import Foundation

extension KernelXML {
    public final class XMLDecoder: @unchecked Sendable {
        public var dateDecodingStrategy: DateDecodingStrategy = .secondsSince1970
        public var dataDecodingStrategy: DataDecodingStrategy = .base64
        public var nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy = .throw
        public var keyDecodingStrategy: KeyDecodingStrategy = .useDefaultKeys
        public var nodeDecodingStrategy: NodeDecodingStrategy = .deferredToDecoder
        public var userInfo: [CodingUserInfoKey: Any] = [:]
        public var errorContextLength: UInt = 0
        public var shouldProcessNamespaces: Bool = false
        public var trimValueWhitespaces: Bool
        public var removeWhitespaceElements: Bool
        
        var options: Options {
            return Options(
                dateDecodingStrategy: dateDecodingStrategy,
                dataDecodingStrategy: dataDecodingStrategy,
                nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
                keyDecodingStrategy: keyDecodingStrategy,
                nodeDecodingStrategy: nodeDecodingStrategy,
                userInfo: userInfo
            )
        }
        
        public init(trimValueWhitespaces: Bool = true, removeWhitespaceElements: Bool = false) {
            self.trimValueWhitespaces = trimValueWhitespaces
            self.removeWhitespaceElements = removeWhitespaceElements
        }
        
        public func decode<T: Decodable>(
            _ type: T.Type,
            from data: Data
        ) throws -> T {
            let topLevel: Boxable = try XMLStackParser.parse(
                with: data,
                errorContextLength: errorContextLength,
                shouldProcessNamespaces: shouldProcessNamespaces,
                trimValueWhitespaces: trimValueWhitespaces,
                removeWhitespaceElements: removeWhitespaceElements
            )
            
            let decoder = SynchronousXMLDecoder(
                referencing: topLevel,
                options: options,
                nodeDecodings: []
            )
            decoder.nodeDecodings = [
                options.nodeDecodingStrategy.nodeDecodings(
                    forType: T.self,
                    with: decoder
                ),
            ]
            
            defer {
                _ = decoder.nodeDecodings.removeLast()
            }
            
            return try decoder.unbox(topLevel)
        }
    }
}

extension KernelXML.XMLDecoder {
    public enum DateDecodingStrategy: Sendable {
        case deferredToDate
        case secondsSince1970
        case millisecondsSince1970
        @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
        case iso8601
        case formatted(DateFormatter)
        case custom(@Sendable (_ decoder: Decoder) throws -> Date)
        
        static func keyFormatted(
            _ formatterForKey: @escaping @Sendable (CodingKey) throws -> DateFormatter?
        ) -> DateDecodingStrategy {
            return .custom { decoder -> Date in
                guard let codingKey = decoder.codingPath.last else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "No Coding Path Found"
                    ))
                }
                
                guard let container = try? decoder.singleValueContainer(),
                      let text = try? container.decode(String.self)
                else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Could not decode date text"
                    ))
                }
                
                guard let dateFormatter = try formatterForKey(codingKey) else {
                    throw DecodingError.dataCorruptedError(
                        in: container,
                        debugDescription: "No date formatter for date text"
                    )
                }
                
                if let date = dateFormatter.date(from: text) {
                    return date
                } else {
                    throw DecodingError.dataCorruptedError(
                        in: container,
                        debugDescription: "Cannot decode date string \(text)"
                    )
                }
            }
        }
    }
}

extension KernelXML.XMLDecoder {
    public enum DataDecodingStrategy {
        case deferredToData
        case base64
        case custom((_ decoder: Decoder) throws -> Data)
        
        static func keyFormatted(
            _ formatterForKey: @escaping (CodingKey) throws -> Data?
        ) -> DataDecodingStrategy {
            return .custom { decoder -> Data in
                guard let codingKey = decoder.codingPath.last else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "No Coding Path Found"
                    ))
                }
                
                guard let container = try? decoder.singleValueContainer(),
                      let text = try? container.decode(String.self)
                else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Could not decode date text"
                    ))
                }
                
                guard let data = try formatterForKey(codingKey) else {
                    throw DecodingError.dataCorruptedError(
                        in: container,
                        debugDescription: "Cannot decode data string \(text)"
                    )
                }
                
                return data
            }
        }
    }
    
}

extension KernelXML.XMLDecoder {
    public enum NonConformingFloatDecodingStrategy {
        case `throw`
        case convertFromString(positiveInfinity: String, negativeInfinity: String, nan: String)
    }
}

extension KernelXML.XMLDecoder {
    public enum KeyDecodingStrategy {
        case useDefaultKeys
        case convertFromSnakeCase
        case convertFromKebabCase
        case convertFromCapitalized
        case convertFromUppercase
        case custom((_ codingPath: [CodingKey]) -> CodingKey)
        
        static func _convertFromCapitalized(_ stringKey: String) -> String {
            guard !stringKey.isEmpty else {
                return stringKey
            }
            let firstLetter = stringKey.prefix(1).lowercased()
            let result = firstLetter + stringKey.dropFirst()
            return result
        }
        
        static func _convertFromUppercase(_ stringKey: String) -> String {
            _convert(stringKey.lowercased(), usingSeparator: "_")
        }
        
        static func _convertFromSnakeCase(_ stringKey: String) -> String {
            return _convert(stringKey, usingSeparator: "_")
        }
        
        static func _convertFromKebabCase(_ stringKey: String) -> String {
            return _convert(stringKey, usingSeparator: "-")
        }
        
        static func _convert(_ stringKey: String, usingSeparator separator: Character) -> String {
            guard !stringKey.isEmpty else {
                return stringKey
            }
            
            guard let firstNonSeparator = stringKey.firstIndex(where: { $0 != separator }) else {
                return stringKey
            }
            
            var lastNonSeparator = stringKey.index(before: stringKey.endIndex)
            while lastNonSeparator > firstNonSeparator, stringKey[lastNonSeparator] == separator {
                stringKey.formIndex(before: &lastNonSeparator)
            }
            
            let keyRange = firstNonSeparator...lastNonSeparator
            let leadingSeparatorRange = stringKey.startIndex..<firstNonSeparator
            let trailingSeparatorRange = stringKey.index(after: lastNonSeparator)..<stringKey.endIndex
            
            let components = stringKey[keyRange].split(separator: separator)
            let joinedString: String
            if components.count == 1 {
                joinedString = String(stringKey[keyRange])
            } else {
                joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
            }
            
            let result: String
            if leadingSeparatorRange.isEmpty, trailingSeparatorRange.isEmpty {
                result = joinedString
            } else if !leadingSeparatorRange.isEmpty, !trailingSeparatorRange.isEmpty {
                result = String(stringKey[leadingSeparatorRange]) + joinedString + String(stringKey[trailingSeparatorRange])
            } else if !leadingSeparatorRange.isEmpty {
                result = String(stringKey[leadingSeparatorRange]) + joinedString
            } else {
                result = joinedString + String(stringKey[trailingSeparatorRange])
            }
            return result
        }
    }
}

extension KernelXML.XMLDecoder {
    public enum NodeDecoding {
        case attribute
        case element
        case elementOrAttribute
    }
}

extension KernelXML.XMLDecoder {
    public enum NodeDecodingStrategy {
        case deferredToDecoder
        case custom((Decodable.Type, Decoder) -> ((CodingKey) -> NodeDecoding))
        
        func nodeDecodings(
            forType codableType: Decodable.Type,
            with decoder: Decoder
        ) -> ((CodingKey) -> NodeDecoding?) {
            switch self {
            case .deferredToDecoder:
                guard let dynamicType = codableType as? KernelXML.DynamicNodeDecoding.Type else {
                    return { _ in nil }
                }
                return dynamicType.nodeDecoding(for:)
            case let .custom(closure):
                return closure(codableType, decoder)
            }
        }
    }
}

extension KernelXML.XMLDecoder {
    struct Options {
        let dateDecodingStrategy: DateDecodingStrategy
        let dataDecodingStrategy: DataDecodingStrategy
        let nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy
        let keyDecodingStrategy: KeyDecodingStrategy
        let nodeDecodingStrategy: NodeDecodingStrategy
        let userInfo: [CodingUserInfoKey: Any]
    }
}

extension KernelXML.XMLDecoder {}
extension KernelXML.XMLDecoder {}
extension KernelXML.XMLDecoder {}
extension KernelXML.XMLDecoder {}
extension KernelXML.XMLDecoder {}
extension KernelXML.XMLDecoder {}
extension KernelXML.XMLDecoder {}

