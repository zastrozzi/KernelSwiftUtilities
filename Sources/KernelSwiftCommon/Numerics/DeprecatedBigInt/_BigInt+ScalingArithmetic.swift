//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

extension KernelNumerics._BigInt {
    public static func /=(a: inout Self, b: Self) { a = a / b }
        /// Divide `a` by `b` storing the remainder in `a`.
    public static func %=(a: inout Self, b: Self) { a = a % b }
    
    public static func *(a: Self, b: Self) -> Self {
        return Self(sign: a.sign == b.sign ? .plus : .minus, magnitude: a.magnitude * b.magnitude)
    }

    /// Multiply `a` with `b` in place.
    public static func *=(a: inout Self, b: Self) { a = a * b }
    
    public func quotientAndRemainder(dividingBy y: Self) -> (quotient: Self, remainder: Self) {
        var a = self.magnitude
        var b = y.magnitude
         KernelNumerics.BigUInt.divide(&a, by: &b)
        return ( Self(sign: self.sign == y.sign ? .plus : .minus, magnitude: a),
                Self(sign: self.sign, magnitude: b))
    }

    /// Divide `a` by `b` and return the quotient. Traps if `b` is zero.
    public static func /(a: Self, b: Self) -> Self {
        return Self(sign: a.sign == b.sign ? .plus : .minus, magnitude: a.magnitude / b.magnitude)
    }

    /// Divide `a` by `b` and return the remainder. The result has the same sign as `a`.
    public static func %(a: Self, b: Self) -> Self {
        return Self(sign: a.sign, magnitude: a.magnitude % b.magnitude)
    }

    /// Return the result of `a` mod `b`. The result is always a nonnegative integer that is less than the absolute value of `b`.
    public func modulus(_ mod: Self) -> Self {
        let remainder = self.magnitude % mod.magnitude
        return Self(
            self.sign == .minus && !remainder.isZero
                ? mod.magnitude - remainder
                : remainder)
    }
    
    public func power(_ exponent: Int) -> Self {
        return Self(sign: self.sign == .minus && exponent & 1 != 0 ? .minus : .plus,
                      magnitude: self.magnitude.power(exponent))
    }

    /// Returns the remainder of this integer raised to the power `exponent` in modulo arithmetic under `modulus`.
    ///
    /// Uses the [right-to-left binary method][rtlb].
    ///
    /// [rtlb]: https://en.wikipedia.org/wiki/Modular_exponentiation#Right-to-left_binary_method
    ///
    /// - Complexity: O(exponent.count * modulus.count^log2(3)) or somesuch
    public func power(_ exponent: Self, modulus: Self) -> Self {
        precondition(!modulus.isZero)
        if modulus.magnitude == 1 { return 0 }
        if exponent.isZero { return 1 }
        if exponent == 1 { return self.modulus(modulus) }
        if exponent < 0 {
            precondition(!self.isZero)
            guard magnitude == 1 else { return 0 }
            guard sign == .minus else { return 1 }
            guard exponent.magnitude[0] & 1 != 0 else { return 1 }
            return Self(modulus.magnitude - 1)
        }
        let power = self.magnitude.power(exponent.magnitude,
                                         modulus: modulus.magnitude)
        if self.sign == .plus || exponent.magnitude[0] & 1 == 0 || power.isZero {
            return Self(power)
        }
        return Self(modulus.magnitude - power)
    }
    
    public func squareRoot() -> Self {
        precondition(self.sign == .plus)
        return Self(sign: .plus, magnitude: self.magnitude.squareRoot())
    }
    
    public func greatestCommonDivisor(with b: Self) -> Self {
        return Self(self.magnitude.greatestCommonDivisor(with: b.magnitude))
    }

        /// Returns the [multiplicative inverse of this integer in modulo `modulus` arithmetic][inverse],
        /// or `nil` if there is no such number.
        ///
        /// [inverse]: https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Modular_integers
        ///
        /// - Returns: If `gcd(self, modulus) == 1`, the value returned is an integer `a < modulus` such that `(a * self) % modulus == 1`. If `self` and `modulus` aren't coprime, the return value is `nil`.
        /// - Requires: modulus.magnitude > 1
        /// - Complexity: O(count^3)
    public func inverse(modulus: Self) -> Self? {
        guard let inv = self.magnitude.inverse(modulus: modulus.magnitude) else { return nil }
        return Self(self.sign == .plus || inv.isZero ? inv : modulus.magnitude - inv)
    }
}
