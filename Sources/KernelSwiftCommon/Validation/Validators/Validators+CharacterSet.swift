//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation.Validator where T == String {
    public static var ascii: KernelValidation.Validator<T> {
        .characterSet(.ascii)
    }
    
    public static var alphanumeric: KernelValidation.Validator<T> {
        .characterSet(.alphanumerics)
    }
    
    public static func characterSet(_ characterSet: Foundation.CharacterSet) -> KernelValidation.Validator<T> {
        .init {
            KernelValidation.ValidatorResults.CharacterSet(string: $0, characterSet: characterSet)
        }
    }
}

extension KernelValidation.ValidatorResults {
    public struct CharacterSet {
        public let string: String
        public let characterSet: Foundation.CharacterSet
        
        var invalidRange: Swift.Range<String.Index>? {
            self.string.rangeOfCharacter(from: self.characterSet.inverted)
        }
        
        public var invalidSlice: String? {
            self.invalidRange.flatMap { self.string[$0] }
                .map { .init($0 )}
        }
        
        var allowedCharacterString: String {
            self.characterSet.traits.joined(separator: ", ")
        }
    }
}

extension KernelValidation.ValidatorResults.CharacterSet: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        self.invalidRange != nil
    }
    
    public var successDescription: String? {
        "contains only \(self.allowedCharacterString)"
    }
    
    public var failureDescription: String? {
        self.invalidSlice.map {
            "contains '\($0)' (allowed: \(self.allowedCharacterString))"
        }
    }
}

extension KernelValidation.Validator where T == [String] {
    public static var ascii: KernelValidation.Validator<T> {
        .characterSet(.ascii)
    }
    
    public static var alphanumeric: KernelValidation.Validator<T> {
        .characterSet(.alphanumerics)
    }
    
    public static func characterSet(_ characterSet: Foundation.CharacterSet) -> KernelValidation.Validator<T> {
        .init {
            KernelValidation.ValidatorResults.CollectionCharacterSet(strings: $0, characterSet: characterSet)
        }
    }
}

extension KernelValidation.ValidatorResults {
    public struct CollectionCharacterSet {
        public let strings: [String]
        public let characterSet: Foundation.CharacterSet
        
        var invalidRanges: [(Int, Swift.Range<String.Index>)?] {
            return self.strings.enumerated().compactMap {
                if let range = $1.rangeOfCharacter(from: self.characterSet.inverted) {
                    return ($0, range)
                }
                return nil
            }
        }
        
        var allowedCharacterString: String {
            self.characterSet.traits.joined(separator: ", ")
        }
    }
}

extension KernelValidation.ValidatorResults.CollectionCharacterSet: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        !self.invalidRanges.isEmpty
    }
    
    public var successDescription: String? {
        "contains only \(self.allowedCharacterString)"
    }
    
    public var failureDescription: String? {
        let disallowedCharacters = self.invalidRanges.compactMap { $0 }
            .map { (invalidSlice) in
                "string at index \(invalidSlice.0) contains '\(String(self.strings[invalidSlice.0][invalidSlice.1]))'"
            }
        return "\(disallowedCharacters.joined(separator: ", ")) (allowed: \(self.allowedCharacterString))"
    }
}

infix operator ∪
public func ∪ (lhs: CharacterSet, rhs: CharacterSet) -> CharacterSet { lhs.union(rhs) }

private extension CharacterSet {
    static var ascii: CharacterSet {
        .init((0..<128).map(Unicode.Scalar.init))
    }
    
    var traits: [String] {
        var desc: [String] = []
        if isSuperset(of: .newlines) {
            desc.append("newlines")
        }
        if isSuperset(of: .whitespaces) {
            desc.append("whitespace")
        }
        if isSuperset(of: .ascii) {
            desc.append("ASCII")
        }
        if isSuperset(of: .capitalizedLetters) {
            desc.append("A-Z")
        }
        if isSuperset(of: .lowercaseLetters) {
            desc.append("a-z")
        }
        if isSuperset(of: .decimalDigits) {
            desc.append("0-9")
        }
        return desc
    }
}
