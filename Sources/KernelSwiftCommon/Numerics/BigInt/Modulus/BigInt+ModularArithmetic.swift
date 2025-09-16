//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/10/2023.
//

import Foundation

extension KernelNumerics.BigInt.DoubleWord {
    public static func inverseMod64(_ d: Self) -> Self {
        var x = d
        while true {
            let t = d &* x
            if t == 1 { return x }
            x = x &* (2 &- t)
        }
    }
}

extension KernelNumerics.BigInt {
    public func mod(_ rhs: Int) -> Int {
        if rhs == .min {
            let r: Int = .init(storage[.zero] & .val.little.max63bit)
            return isNegative && r > .zero ? -(.min + r) : r
        }
        let rhsa: DoubleWord = .init(Swift.abs(rhs))
        let (_, r) = storage.divMod(rhsa)
        return .init(isNegative && r > .zero ? rhsa - r : r)
    }
    
    public func mod(_ rhs: Self) -> Self {
        let r = self % rhs
        return if rhs.isNegative { r.isNegative ? r - rhs : r }
        else { r.isNegative ? r + rhs : r }
    }
    
    public func modInverse(_ rhs: Self) -> Self {
        precondition(rhs.isPositive, "rhs must be positive")
        guard rhs > .one else { return .zero }
        let tb = rhs.trailingZeroBitCount
        if tb <= 1024 && (rhs >> tb).isOne {
            precondition(isOdd, "even inverse modulus")
            let r = self & (Self.one << tb - Self.one)
            var a = Self.zero, b = Self.one
            for i in .zero ..< tb {
                if b.storage[.zero].andEquals(1) { a.setBit(i); b -= r }
                b >>= 1
            }
            return a
        }
        let (g, a, _) = GCD.extendedDivisor(mod(rhs), rhs)
        precondition(g.isOne, "inverse modulus not found")
        return a.mod(rhs)
    }
    
    public func modInverse(_ rhs: Int) -> Int {
        precondition(rhs > .zero, "rhs must be positive")
        guard rhs > 1 else { return .zero }
        let tb = rhs.trailingZeroBitCount
        if rhs >> tb == 1 {
            precondition(isOdd, "even inverse modulus")
            let dw = storage[.zero] & (1 << tb - 1), dwr = isNegative ? -Int(dw) : Int(dw)
            var x = Int.zero, b = 1
            for i in .zero ..< tb {
                if b.andEquals(1) { x |= 1 << i; b -= dwr }
                b >>= 1
            }
            return x
        }
        var a = 1, g = mod(rhs), u = Int.zero, w = rhs
        while w > .zero {
            let (q, r) = g.quotientAndRemainder(dividingBy: w)
            (a, g, u, w) = (u, w, a - q * u, r)
        }
        precondition(g == 1, "inverse modulus not found")
        return a < .zero ? a + rhs : a
    }
    
    public static func modInverse(_ lhs: Int, _ rhs: Int) -> Int {
        var a = 1, g = lhs % rhs, u = Int.zero, w = rhs
        while w > .zero {
            let (q, r) = g.quotientAndRemainder(dividingBy: w)
            (a, g, u, w) = (u, w, a - q * u, r)
        }
        precondition(g == 1, "not coprime")
        return a < .zero ? a + rhs : a
    }
}

