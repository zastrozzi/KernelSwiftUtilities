//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

extension Array where Element == UInt {
    mutating func twosComplement() {
        var increment = true
        for i in 0 ..< self.count {
            if increment {
                (self[i], increment) = (~self[i]).addingReportingOverflow(1)
            }
            else {
                self[i] = ~self[i]
            }
        }
    }
}

extension KernelNumerics._BigInt {
    public static prefix func ~(x: Self) -> Self {
        switch x.sign {
        case .plus:
            return Self(sign: .minus, magnitude: x.magnitude + 1)
        case .minus:
            return Self(sign: .plus, magnitude: x.magnitude - 1)
        }
    }
    
    public static func &(lhs: inout Self, rhs: Self) -> Self {
        let left = lhs.words
        let right = rhs.words
        // Note we aren't using left.count/right.count here; we account for the sign bit separately later.
        let count = Swift.max(lhs.magnitude.count, rhs.magnitude.count)
        var words: [UInt] = []
        words.reserveCapacity(count)
        for i in 0 ..< count {
            words.append(left[i] & right[i])
        }
        if lhs.sign == .minus && rhs.sign == .minus {
            words.twosComplement()
            return Self(sign: .minus, magnitude: KernelNumerics.BigUInt(words: words))
        }
        return Self(sign: .plus, magnitude: KernelNumerics.BigUInt(words: words))
    }
    
    public static func |(lhs: inout Self, rhs: Self) -> Self {
        let left = lhs.words
        let right = rhs.words
        // Note we aren't using left.count/right.count here; we account for the sign bit separately later.
        let count = Swift.max(lhs.magnitude.count, rhs.magnitude.count)
        var words: [UInt] = []
        words.reserveCapacity(count)
        for i in 0 ..< count {
            words.append(left[i] | right[i])
        }
        if lhs.sign == .minus || rhs.sign == .minus {
            words.twosComplement()
            return Self(sign: .minus, magnitude: KernelNumerics.BigUInt(words: words))
        }
        return Self(sign: .plus, magnitude: KernelNumerics.BigUInt(words: words))
    }
    
    public static func ^(lhs: inout Self, rhs: Self) -> Self {
        let left = lhs.words
        let right = rhs.words
        // Note we aren't using left.count/right.count here; we account for the sign bit separately later.
        let count = Swift.max(lhs.magnitude.count, rhs.magnitude.count)
        var words: [UInt] = []
        words.reserveCapacity(count)
        for i in 0 ..< count {
            words.append(left[i] ^ right[i])
        }
        if (lhs.sign == .minus) != (rhs.sign == .minus) {
            words.twosComplement()
            return Self(sign: .minus, magnitude: KernelNumerics.BigUInt(words: words))
        }
        return Self(sign: .plus, magnitude: KernelNumerics.BigUInt(words: words))
    }
    
    public static func &=(lhs: inout Self, rhs: Self) {
        lhs = lhs & rhs
    }
    
    public static func |=(lhs: inout Self, rhs: Self) {
        lhs = lhs | rhs
    }
    
    public static func ^=(lhs: inout Self, rhs: Self) {
        lhs = lhs ^ rhs
    }
}


extension KernelNumerics._BigInt {
    func shiftedLeft(by amount: Word) -> Self {
        return Self(sign: self.sign, magnitude: self.magnitude.shiftedLeft(by: amount))
    }
    
    mutating func shiftLeft(by amount: Word) {
        self.magnitude.shiftLeft(by: amount)
    }
    
    func shiftedRight(by amount: Word) -> Self {
        let m = self.magnitude.shiftedRight(by: amount)
        return Self(sign: self.sign, magnitude: self.sign == .minus && m.isZero ? 1 : m)
    }
    
    mutating func shiftRight(by amount: Word) {
        magnitude.shiftRight(by: amount)
        if sign == .minus, magnitude.isZero {
            magnitude.load(1)
        }
    }
    
    public static func &<<(left: Self, right: Self) -> Self {
        return left.shiftedLeft(by: right.words[0])
    }
    
    public static func &<<=(left: inout Self, right: Self) {
        left.shiftLeft(by: right.words[0])
    }
    
    public static func &>>(left: Self, right: Self) -> Self {
        return left.shiftedRight(by: right.words[0])
    }
    
    public static func &>>=(left: inout Self, right: Self) {
        left.shiftRight(by: right.words[0])
    }
    
    public static func <<<Other: BinaryInteger>(lhs: Self, rhs: Other) -> Self {
        guard rhs >= (0 as Other) else { return lhs >> (0 - rhs) }
        return lhs.shiftedLeft(by: Word(rhs))
    }
    
    public static func <<=<Other: BinaryInteger>(lhs: inout Self, rhs: Other) {
        if rhs < (0 as Other) {
            lhs >>= (0 - rhs)
        }
        else {
            lhs.shiftLeft(by: Word(rhs))
        }
    }
    
    public static func >><Other: BinaryInteger>(lhs: Self, rhs: Other) -> Self {
        guard rhs >= (0 as Other) else { return lhs << (0 - rhs) }
        return lhs.shiftedRight(by: Word(rhs))
    }
    
    public static func >>=<Other: BinaryInteger>(lhs: inout Self, rhs: Other) {
        if rhs < (0 as Other) {
            lhs <<= (0 - rhs)
        }
        else {
            lhs.shiftRight(by: Word(rhs))
        }
    }
}
