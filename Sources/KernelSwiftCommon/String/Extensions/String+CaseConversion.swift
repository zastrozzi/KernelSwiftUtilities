//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/04/2023.
//

import Foundation

public extension String {
    internal var kebabOrSnakeCaseConversionRegex: NSRegularExpression? {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        return regex
    }
    
    internal var caseConversionRegexRange: NSRange { NSRange(location: 0, length: count) }
    
    func capitalisingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    func snakeCased() -> String {
        return kebabOrSnakeCaseConversionRegex?.stringByReplacingMatches(in: self, options: [], range: caseConversionRegexRange, withTemplate: "$1_$2").replacingOccurrences(of: "-", with: "_") ?? self
    }
    
    func kebabCased() -> String {
        kebabOrSnakeCaseConversionRegex?.stringByReplacingMatches(in: self, options: [], range: caseConversionRegexRange, withTemplate: "$1-$2").replacingOccurrences(of: "_", with: "-") ?? self
    }
    
    func lowercaseSnakeCased() -> String {
        return snakeCased().lowercased()
    }
    
    func uppercaseSnakeCased() -> String {
        snakeCased().uppercased()
    }
    
    func lowercaseKebabCased() -> String {
        kebabCased().lowercased()
    }
    
    func uppercaseKebabCased() -> String {
        kebabCased().uppercased()
    }
    
    func camelCased() -> String {
        lowercased().split { ["_", "-"].contains($0) }.enumerated().map { $0.offset > 0 ? $0.element.capitalized : $0.element.lowercased() }.joined()
    }
}


extension StringProtocol {
    public func capitalizingFirstLetter() -> Self {
        guard !isEmpty else {
            return self
        }
        return Self(prefix(1).uppercased() + dropFirst())!
    }
    
    public mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }
    
    public func lowercasingFirstLetter() -> Self {
        guard count > 1, !(String(prefix(2)) == prefix(2).lowercased()) else {
            return self
        }
        return Self(prefix(1).lowercased() + dropFirst())!
    }
    
    public mutating func lowercaseFirstLetter() {
        self = lowercasingFirstLetter()
    }
}
