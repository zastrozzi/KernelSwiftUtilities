//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

extension KernelNumerics._BigInt {
        /// Add `a` to `b` and return the result.
    public static func +(a: Self, b: Self) -> Self {
        switch (a.sign, b.sign) {
        case (.plus, .plus):
            return Self(sign: .plus, magnitude: a.magnitude + b.magnitude)
        case (.minus, .minus):
            return Self(sign: .minus, magnitude: a.magnitude + b.magnitude)
        case (.plus, .minus):
            if a.magnitude >= b.magnitude {
                return Self(sign: .plus, magnitude: a.magnitude - b.magnitude)
            }
            else {
                return Self(sign: .minus, magnitude: b.magnitude - a.magnitude)
            }
        case (.minus, .plus):
            if b.magnitude >= a.magnitude {
                return Self(sign: .plus, magnitude: b.magnitude - a.magnitude)
            }
            else {
                return Self(sign: .minus, magnitude: a.magnitude - b.magnitude)
            }
        }
    }

    /// Add `b` to `a` in place.
    public static func +=(a: inout Self, b: Self) {
        a = a + b
    }
    
    public mutating func negate() {
        guard !magnitude.isZero else { return }
        self.sign = self.sign == .plus ? .minus : .plus
    }

    /// Subtract `b` from `a` and return the result.
    public static func -(a: Self, b: Self) -> Self {
        return a + (b * -1)
    }

    /// Subtract `b` from `a` in place.
    public static func -=(a: inout Self, b: Self) { a = a - b }
}
