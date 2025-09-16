//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/10/2023.
//

import Foundation

extension KernelNumerics.BigInt {
    public enum GCD {
        @_documentation(visibility: private)
        public typealias BigInt = KernelNumerics.BigInt
        
        public static func divisor(_ lhs: borrowing BigInt, _ rhs: BigInt) -> BigInt {
            let (lhsa, rhsa) = (lhs.abs, rhs.abs)
            var (u, v) = lhsa < rhsa ? (rhsa, lhsa) : (lhsa, rhsa)
            while v >= .util.b62 {
                let s = u.bitWidth - 62
                var (x, y) = ((u >> s).toInt()!, (v >> s).toInt()!)
                var a = 1, b = Int.zero, c = Int.zero, d = 1
                while true {
                    let yc = y + c, yd = y + d
                    if yc == .zero || yd == .zero { break }
                    let xac = (x + a) / yc, xbd = (x + b) / yd
                    if xac != xbd { break }
                    (a, b, x, c, d, y) = (c, d, y, a - xac * c, b - xac * d, x - xac * y)
                }
                if b == .zero { (u, v) = (v, u.mod(v)) }
                else { (u, v) = (a * u + b * v, c * u + d * v) }
            }
            if v.isZero { return u }
            if u.count > 1 {
                let ur = u.quotientAndRemainder(dividingBy: v).r
                u = v; v = ur
                if v.isZero { return u }
            }
            assert(u < .min2dw)
            assert(v < .min2dw)
            return .init([binaryDivisor(u.storage[.zero], v.storage[.zero])])
        }
        
        public static func extendedDivisor(_ lhs: BigInt, _ rhs: BigInt) -> (g: BigInt, a: BigInt, b: BigInt) {
            let lhsa = lhs.toAbs()
            let rhsa = rhs.toAbs()
            if lhs.isZero { return (rhsa, .zero, rhs.isNegative ? -.one : .one) }
            if rhs.isZero { return (lhsa, lhs.isNegative ? -.one : .one, .zero) }
            var u0: BigInt
            var v0: BigInt
            if lhsa < rhsa {
                u0 = rhsa
                v0 = lhsa
            } else {
                u0 = lhsa
                v0 = rhsa
            }
            var u1 = BigInt.zero
            var v1 = BigInt.one
            var u2 = u0
            var v2 = v0
            bigLoop: while v0 >= .util.b62 {
                let s = u0.bitWidth - 62
                if s == 1 { break bigLoop }
                var x = (u0 >> s).toInt()!
                var y = (v0 >> s).toInt()!
                var a = 1, b = 0, c = 0, d = 1
                smallLoop: while true {
                    let yc = y + c, yd = y + d
                    if yc == .zero || yd == .zero { break smallLoop }
                    let xac = (x + a) / yc, xbd = (x + b) / yd
                    if xac != xbd { break smallLoop }
                    (a, b, x, c, d, y) = (c, d, y, a - xac * c, b - xac * d, x - xac * y)
                }
                if b == .zero {
                    (u0, v0) = (v0, u0.mod(v0))
                    let q = u2 / v2
                    (u1, v1) = (v1, u1 - q * v1)
                    (u2, v2) = (v2, u2 - q * v2)
                }
                else {
                    (u0, v0) = (a * u0 + b * v0, c * u0 + d * v0)
                    (u1, v1) = (a * u1 + b * v1, c * u1 + d * v1)
                    (u2, v2) = (a * u2 + b * v2, c * u2 + d * v2)
                }
            }
            while v2.isNotZero {
                let q = u2 / v2
                (u1, v1) = (v1, u1 - v1 * q)
                (u2, v2) = (v2, u2 - v2 * q)
            }
            var ux: BigInt
            
            if lhsa < rhsa {
                ux = (u2 - u1 * lhsa) / rhsa
                (ux, u1) = (u1, ux)
            }
            else { ux = (u2 - u1 * rhsa) / lhsa }
            if rhs.isNegative { u1 = -u1 }
            if lhs.isNegative { ux = -ux }
            return (u2, ux, u1)
        }
        
        public static func binaryDivisor(_ lhs: DoubleWord, _ rhs: DoubleWord) -> DoubleWord {
            assert(lhs > .zero)
            assert(rhs > .zero)
            let lhsz = lhs.trailingZeroBitCount, rhsz = rhs.trailingZeroBitCount
            var lhs = lhs >> lhsz, rhs = rhs >> rhsz
            while lhs != rhs {
                if lhs > rhs {
                    lhs -= rhs
                    lhs >>= lhs.trailingZeroBitCount
                }
                else {
                    rhs -= lhs
                    rhs >>= rhs.trailingZeroBitCount
                }
            }
            return lhs << (lhsz < rhsz ? lhsz : rhsz)
        }
    }
}
