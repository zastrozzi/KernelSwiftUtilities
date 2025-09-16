//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/08/2023.
//

import Foundation

extension String {
    public func removingCharacters(in set: CharacterSet) -> String {
        let filtered = unicodeScalars.filter { !set.contains($0) }
        return String(filtered)
    }
    
    public func removingCharacters(in sets: CharacterSet...) -> String {
        removingCharacters(in: sets)
    }
    
    public func removingCharacters(in sets: [CharacterSet]) -> String {
        let set: CharacterSet = sets.reduce(into: .init()) { res, next in
            res.formUnion(next)
        }
        let filtered = unicodeScalars.filter { !set.contains($0) }
        return String(filtered)
    }
    
    public func removingCharacters(notIn set: CharacterSet) -> String {
        removingCharacters(in: set.inverted)
    }
    
    public func isAllWhitespace() -> Bool {
        return unicodeScalars.allSatisfy(CharacterSet.whitespacesAndNewlines.contains)
    }
}

extension StringProtocol where Self.Index == String.Index {
    public func escape(_ characterSet: [(character: String, escapedCharacter: String)]) -> String {
        var string = String(self)
        
        for set in characterSet {
            string = string.replacingOccurrences(of: set.character, with: set.escapedCharacter, options: .literal)
        }
        
        return string
    }
}

extension CharacterSet {
    public static var hexadecimalDigits: CharacterSet {
        .init([
            .init(.ascii.A),    .init(.ascii.a),
            .init(.ascii.B),    .init(.ascii.b),
            .init(.ascii.C),    .init(.ascii.c),
            .init(.ascii.D),    .init(.ascii.d),
            .init(.ascii.E),    .init(.ascii.e),
            .init(.ascii.F),    .init(.ascii.f)
        ]).union(.decimalDigits)
    }
    
    public static var phoneNumberCharacters: CharacterSet {
        .init([
            .init(.ascii.zero), .init(.ascii.one), .init(.ascii.two),
            .init(.ascii.three), .init(.ascii.four), .init(.ascii.five),
            .init(.ascii.six), .init(.ascii.seven), .init(.ascii.eight),
            .init(.ascii.nine), .init(.ascii.plus)
        ])
    }
    
    public static var quotationMarks: CharacterSet {
        .init([
            .init(.ascii.doubleQuote),
            .init(.ascii.singleQuote)
        ])
    }
    
    public static var commas: CharacterSet {
        .init([
            .init(.ascii.comma)
        ])
    }
    
    public static var parentheses: CharacterSet {
        .init([
            .init(.ascii.leftParenthesis),
            .init(.ascii.rightParenthesis)
        ])
    }
}
