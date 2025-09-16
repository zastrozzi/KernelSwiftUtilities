//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

extension KernelNumerics.BigUInt {
    @inlinable
    static func charsPerWord(forRadix radix: Int) -> (chars: Int, power: Word) {
        var power: Word = 1
        var overflow = false
        var count = 0
        while !overflow {
            let (high,low) = power.multipliedFullWidth(by: Word(radix))
            if high > 0 {
              overflow = true
            }

            if !overflow || (high == 1 && low == 0) {
                count += 1
                power = low
            }
        }
        return (count, power)
    }

    @inlinable
    public init?<S: StringProtocol>(_ text: S, radix: Int = 10) {
        precondition(radix > 1 && radix < 36)
        guard !text.isEmpty else { return nil }
        let (charsPerWord, power) = KernelNumerics.BigUInt.charsPerWord(forRadix: radix)

        var words: [Word] = []
        var end = text.endIndex
        var start = end
        var count = 0
        while start != text.startIndex {
            start = text.index(before: start)
            count += 1
            if count == charsPerWord {
                guard let d = Word.init(text[start ..< end], radix: radix) else { return nil }
                words.append(d)
                end = start
                count = 0
            }
        }
        if start != end {
            guard let d = Word.init(text[start ..< end], radix: radix) else { return nil }
            words.append(d)
        }

        if power == 0 {
            self.init(words: words)
        }
        else {
            self.init()
            for d in words.reversed() {
                self.multiply(byWord: power)
                self.addWord(d)
            }
        }
    }
}

extension KernelNumerics.BigUInt: ExpressibleByStringLiteral {
    @inlinable
    public init(unicodeScalarLiteral value: UnicodeScalar) {
        self = KernelNumerics.BigUInt(String(value), radix: 10)!
    }

    @inlinable
    public init(extendedGraphemeClusterLiteral value: String) {
        self = KernelNumerics.BigUInt(value, radix: 10)!
    }
    
    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        if value.hasPrefix("0x") { self = KernelNumerics.BigUInt(value.dropFirst(2), radix: 16)! }
        else if value.hasPrefix("0b") { self = KernelNumerics.BigUInt(value.dropFirst(2), radix: 2)! }
        else { self = KernelNumerics.BigUInt(value, radix: 10)! }
    }
}

extension KernelNumerics.BigUInt: CustomStringConvertible {
    @inlinable
    public var description: String {
        return String(self, radix: 10)
    }
}

extension String {
    public init(_ v: KernelNumerics.BigUInt) { self.init(v, radix: 10, uppercase: false) }
    
    public init(_ v: KernelNumerics.BigUInt, radix: Int, uppercase: Bool = false) {
        precondition(radix > 1)
        let (charsPerWord, power) = KernelNumerics.BigUInt.charsPerWord(forRadix: radix)
        
        guard !v.isZero else { self = "0"; return }
        
        var parts: [String]
        if power == 0 {
            parts = v.words.map { String($0, radix: radix, uppercase: uppercase) }
        }
        else {
            parts = []
            var rest = v
            while !rest.isZero {
                let mod = rest.divide(byWord: power)
                parts.append(String(mod, radix: radix, uppercase: uppercase))
            }
        }
        assert(!parts.isEmpty)
        
        self = ""
        var first = true
        for part in parts.reversed() {
            let zeroes = charsPerWord - part.count
            assert(zeroes >= 0)
            if !first && zeroes > 0 {
                // Insert leading zeroes for mid-Words
                self += String(repeating: "0", count: zeroes)
            }
            first = false
            self += part
        }
    }
}
