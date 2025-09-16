//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

import Foundation

extension JSONDecoder.KeyDecodingStrategy {
    public static func withFormat(_ format: KeyCodingFormat) -> Self {
        .custom { keys in
            guard keys.last!.intValue == nil else { return keys.last! }
            return format.casedCodingKey(for: keys.last!.stringValue)
        }
    }
}

extension JSONEncoder.KeyEncodingStrategy {
    public static func withFormat(_ format: KeyCodingFormat) -> Self {
        .custom { keys in
            guard keys.last!.intValue == nil else { return keys.last! }
            return format.casedCodingKey(for: keys.last!.stringValue)
        }
    }
}


public enum KeyCodingFormat: Sendable {
    case camelCase
    case capitalisedCase
    case lowerSnakeCase
    case upperSnakeCase
    case capitalisedSnakeCase
    case lowerKebabCase
    case upperKebabCase
    case capitalisedKebabCase
    case unknownCase
}

protocol KeyCodingFormattable {
    static var formatCase: KeyCodingFormat { get }
    static func generateComponents(_ keyString: String) -> [String]
    static func makeCasedCodingKey(_ stringValue: String) -> CodingKey
}

extension KeyCodingFormat {
    public struct CasedCodingKey: CodingKey, Hashable {
        public let stringValue: String
        public let intValue: Int?
        
        public init(stringValue: String) {
            self.stringValue = KeyCodingFormat.convertKey(stringValue, to: .unknownCase)
            intValue = nil
        }
        
        public init(stringValue: String, format: KeyCodingFormat) {
            self.stringValue = KeyCodingFormat.convertKey(stringValue, to: format)
            intValue = nil
        }
        
        public init(intValue: Int) {
            stringValue = String(intValue)
            self.intValue = intValue
        }
    }
    
    var Formatter: KeyCodingFormattable.Type {
        switch self {
        case .camelCase: return KeyCodingFormat.CamelCase.self
        case .capitalisedCase: return KeyCodingFormat.CapitalisedCase.self
        case .lowerSnakeCase: return KeyCodingFormat.LowerSnakeCase.self
        case .upperSnakeCase: return KeyCodingFormat.UpperSnakeCase.self
        case .capitalisedSnakeCase: return KeyCodingFormat.CapitalisedSnakeCase.self
        case .lowerKebabCase: return KeyCodingFormat.LowerKebabCase.self
        case .upperKebabCase: return KeyCodingFormat.UpperKebabCase.self
        case .capitalisedKebabCase: return KeyCodingFormat.CapitalisedKebabCase.self
        case .unknownCase: return KeyCodingFormat.CamelCase.self
        }
    }
    
    public func casedCodingKey(for stringValue: String) -> CodingKey {
        return self.Formatter.makeCasedCodingKey(stringValue)
    }
}

extension KeyCodingFormattable {
    static func makeCasedCodingKey(_ stringValue: String) -> CodingKey {
        return KeyCodingFormat.CasedCodingKey(stringValue: stringValue, format: Self.formatCase)
    }
}

extension KeyCodingFormat {
    public struct LowerSnakeCase: KeyCodingFormattable {
        static let formatCase: KeyCodingFormat = .lowerSnakeCase
    }
    public struct UpperSnakeCase: KeyCodingFormattable {
        static let formatCase: KeyCodingFormat = .upperSnakeCase
    }
    public struct CapitalisedSnakeCase: KeyCodingFormattable {
        static let formatCase: KeyCodingFormat = .capitalisedSnakeCase
    }
    public struct LowerKebabCase: KeyCodingFormattable {
        static let formatCase: KeyCodingFormat = .lowerKebabCase
    }
    public struct UpperKebabCase: KeyCodingFormattable {
        static let formatCase: KeyCodingFormat = .upperKebabCase
    }
    public struct CapitalisedKebabCase: KeyCodingFormattable {
        static let formatCase: KeyCodingFormat = .capitalisedKebabCase
    }
    public struct CamelCase: KeyCodingFormattable {
        static let formatCase: KeyCodingFormat = .camelCase
    }
    public struct CapitalisedCase: KeyCodingFormattable {
        static let formatCase: KeyCodingFormat = .capitalisedCase
    }
}

extension KeyCodingFormat {
    public static func convertKey(_ keyString: String, to format: Self) -> String {
        let originalFormat = KeyCodingFormat.identifyFormat(keyString)
        guard originalFormat != .unknownCase else { return keyString }
        let components = originalFormat.generateComponents(keyString)
        return format.createKeyFromComponents(components)
    }
    
    public static func identifyFormat(_ keyString: String) -> Self {
        guard !keyString.isEmptyOrBlank else { return .unknownCase }
        let hasUnderscore = keyString.contains("_")
        let hasHyphen = keyString.contains("-")
        let isLowerOnly = keyString.lowercased() == keyString
        let isUpperOnly = keyString.uppercased() == keyString
        let firstChar = String(keyString.first!)
        let isCapitalisedFirst = firstChar.uppercased() == firstChar
        if !isCapitalisedFirst && !isUpperOnly && !hasUnderscore && !hasHyphen { return .camelCase }
        if isCapitalisedFirst && !isUpperOnly && !hasUnderscore && !hasHyphen { return .capitalisedCase }
        if isLowerOnly && hasUnderscore { return .lowerSnakeCase }
        if isUpperOnly && hasUnderscore { return .upperSnakeCase }
        if isCapitalisedFirst && !isUpperOnly && hasUnderscore { return .capitalisedSnakeCase }
        if isLowerOnly && hasHyphen { return .lowerKebabCase }
        if isUpperOnly && hasHyphen { return .upperKebabCase }
        if isCapitalisedFirst && !isUpperOnly && hasHyphen { return .capitalisedKebabCase }
        else { return .unknownCase }
    }
    
    public func generateComponents(_ keyString: String) -> [String] {
        guard !keyString.isEmptyOrBlank else { return [] }
        return self.Formatter.generateComponents(keyString)
    }
    
    public func createKeyFromComponents(_ components: [String]) -> String {
        guard !components.isEmpty else { return "" }
        switch self {
        case .camelCase:
            let lowered = components.map { $0.lowercased() }
            let capitalisedNonFirst = lowered.dropFirst().map { $0.capitalisingFirstLetter() }
            return [[lowered.first!], capitalisedNonFirst].flatMap { $0 }.joined()
        case .capitalisedCase:
            return components.map { $0.lowercased().capitalisingFirstLetter() }.joined()
        case .lowerSnakeCase:  return components.map { $0.lowercased() }.joined(separator: "_")
        case .upperSnakeCase: return components.map { $0.uppercased() }.joined(separator: "_")
        case .capitalisedSnakeCase: return components.map { $0.lowercased().capitalisingFirstLetter() }.joined(separator: "_")
        case .lowerKebabCase: return components.map { $0.lowercased() }.joined(separator: "-")
        case .upperKebabCase: return components.map { $0.uppercased() }.joined(separator: "-")
        case .capitalisedKebabCase: return components.map { $0.lowercased().capitalisingFirstLetter() }.joined(separator: "-")
        case .unknownCase: return ""
        }
    }
}

extension KeyCodingFormat.CamelCase {
    public static func generateComponents(_ keyString: String) -> [String] {
        guard !keyString.isEmptyOrBlank else { return [] }
        var words : [Range<String.Index>] = []
        var wordStart = keyString.startIndex
        var searchRange = keyString.index(after: wordStart)..<keyString.endIndex
        while let upperCaseRange = keyString[searchRange].rangeOfCharacter(from: .uppercaseLetters, options: []) {
            let untilUpperCase = wordStart..<upperCaseRange.lowerBound
            words.append(untilUpperCase)
            searchRange = upperCaseRange.lowerBound..<searchRange.upperBound
            guard let lowerCaseRange = keyString[searchRange].rangeOfCharacter(from: .lowercaseLetters, options: []) else {
                wordStart = searchRange.lowerBound
                break
            }
            
            let nextCharacterAfterCapital = keyString.index(after: upperCaseRange.lowerBound)
            if lowerCaseRange.lowerBound == nextCharacterAfterCapital {
                wordStart = upperCaseRange.lowerBound
            } else {
                let beforeLowerIndex = keyString.index(before: lowerCaseRange.lowerBound)
                words.append(upperCaseRange.lowerBound..<beforeLowerIndex)
                wordStart = beforeLowerIndex
            }
            searchRange = lowerCaseRange.upperBound..<searchRange.upperBound
        }
        words.append(wordStart..<searchRange.upperBound)
        return words.map { String(keyString[$0]) }
    }
}

extension KeyCodingFormat.CapitalisedCase {
    public static func generateComponents(_ keyString: String) -> [String] {
        guard !keyString.isEmptyOrBlank else { return [] }
        let convertedKeyString = keyString.prefix(1).lowercased() + keyString.dropFirst()
        let components = KeyCodingFormat.CamelCase.generateComponents(convertedKeyString)
        guard !components.isEmpty else { return [] }
        let convertedComponents = [[components.first!.capitalisingFirstLetter()], components.dropFirst().map { String($0) }].flatMap { $0 }
        return convertedComponents
    }
}

extension KeyCodingFormat.LowerSnakeCase {
    public static func generateComponents(_ keyString: String) -> [String] {
        guard !keyString.isEmptyOrBlank else { return [] }
        return keyString.split(separator: "_").map { String($0) }
    }
}

extension KeyCodingFormat.UpperSnakeCase {
    public static func generateComponents(_ keyString: String) -> [String] {
        guard !keyString.isEmptyOrBlank else { return [] }
        return keyString.split(separator: "_").map { String($0) }
    }
}

extension KeyCodingFormat.CapitalisedSnakeCase {
    public static func generateComponents(_ keyString: String) -> [String] {
        guard !keyString.isEmptyOrBlank else { return [] }
        return keyString.split(separator: "_").map { String($0) }
    }
}

extension KeyCodingFormat.LowerKebabCase {
    public static func generateComponents(_ keyString: String) -> [String] {
        guard !keyString.isEmptyOrBlank else { return [] }
        return keyString.split(separator: "-").map { String($0) }
    }
}

extension KeyCodingFormat.UpperKebabCase {
    public static func generateComponents(_ keyString: String) -> [String] {
        guard !keyString.isEmptyOrBlank else { return [] }
        return keyString.split(separator: "-").map { String($0) }
    }
}

extension KeyCodingFormat.CapitalisedKebabCase {
    public static func generateComponents(_ keyString: String) -> [String] {
        guard !keyString.isEmptyOrBlank else { return [] }
        return keyString.split(separator: "-").map { String($0) }
    }
}
//
//extension KeyCodingFormat.CamelCase {
//    public struct CasedCodingKey: CodingKey {
//        public let stringValue: String
//        public let intValue: Int?
//
//        public init(stringValue: String) {
//            self.stringValue = KeyCodingFormat.convertKey(stringValue, to: .camelCase)
//            intValue = nil
//        }
//
//        public init(intValue: Int) {
//            stringValue = String(intValue)
//            self.intValue = intValue
//        }
//    }
//}
//
//extension KeyCodingFormat.CapitalisedCase {
//    public struct CasedCodingKey: CodingKey {
//        public let stringValue: String
//        public let intValue: Int?
//
//        public init(stringValue: String) {
//            self.stringValue = KeyCodingFormat.convertKey(stringValue, to: .capitalisedCase)
//            intValue = nil
//        }
//
//        public init(intValue: Int) {
//            stringValue = String(intValue)
//            self.intValue = intValue
//        }
//    }
//}
//
//extension KeyCodingFormat.LowerSnakeCase {
//    public struct CasedCodingKey: CodingKey {
//        public let stringValue: String
//        public let intValue: Int?
//
//        public init(stringValue: String) {
//            self.stringValue = KeyCodingFormat.convertKey(stringValue, to: .lowerSnakeCase)
//            intValue = nil
//        }
//
//        public init(intValue: Int) {
//            stringValue = String(intValue)
//            self.intValue = intValue
//        }
//    }
//}
//
//extension KeyCodingFormat.UpperSnakeCase {
//    public struct CasedCodingKey: CodingKey {
//        public let stringValue: String
//        public let intValue: Int?
//
//        public init(stringValue: String) {
//            self.stringValue = KeyCodingFormat.convertKey(stringValue, to: .upperSnakeCase)
//            intValue = nil
//        }
//
//        public init(intValue: Int) {
//            stringValue = String(intValue)
//            self.intValue = intValue
//        }
//    }
//}
//
//extension KeyCodingFormat.CapitalisedSnakeCase {
//    public struct CasedCodingKey: CodingKey {
//        public let stringValue: String
//        public let intValue: Int?
//
//        public init(stringValue: String) {
//            self.stringValue = KeyCodingFormat.convertKey(stringValue, to: .capitalisedSnakeCase)
//            intValue = nil
//        }
//
//        public init(intValue: Int) {
//            stringValue = String(intValue)
//            self.intValue = intValue
//        }
//    }
//}
//
//extension KeyCodingFormat.LowerKebabCase {
//    public struct CasedCodingKey: CodingKey {
//        public let stringValue: String
//        public let intValue: Int?
//
//        public init(stringValue: String) {
//            self.stringValue = KeyCodingFormat.convertKey(stringValue, to: .lowerKebabCase)
//            intValue = nil
//        }
//
//        public init(intValue: Int) {
//            stringValue = String(intValue)
//            self.intValue = intValue
//        }
//    }
//}
//
//extension KeyCodingFormat.UpperKebabCase {
//    public struct CasedCodingKey: CodingKey {
//        public let stringValue: String
//        public let intValue: Int?
//
//        public init(stringValue: String) {
//            self.stringValue = KeyCodingFormat.convertKey(stringValue, to: .upperKebabCase)
//            intValue = nil
//        }
//
//        public init(intValue: Int) {
//            stringValue = String(intValue)
//            self.intValue = intValue
//        }
//    }
//}
//
//extension KeyCodingFormat.CapitalisedKebabCase {
//    public struct CasedCodingKey: CodingKey {
//        public let stringValue: String
//        public let intValue: Int?
//
//        public init(stringValue: String) {
//            self.stringValue = KeyCodingFormat.convertKey(stringValue, to: .capitalisedKebabCase)
//            intValue = nil
//        }
//
//        public init(intValue: Int) {
//            stringValue = String(intValue)
//            self.intValue = intValue
//        }
//    }
//}
