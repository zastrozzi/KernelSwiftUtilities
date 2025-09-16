//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/10/2023.
//

import Foundation

extension KernelNumerics.BigInt.DoubleWords {
    public mutating func square() {
        self = switch count {
        case ..<Karatsuba.val.threshold             : Self.smallSquare(self)
        case ..<ToomCook.val.threshold              : Karatsuba.square(self)
        case ..<FourierFastTransform.val.threshold  : ToomCook.square(self)
        default                                     : FourierFastTransform.square(self)
        }
        self.normalise()
    }
    
//    @inlinable @inline(__always)
    public static func smallSquare(_ lhs: borrowing Self) -> Self {
        let c = lhs.count
        var dw: Self = .zeroes(c * 2), cry = Element.zero, o0 = false, o1 = false, o2 = false
        dw.withUnsafeMutableBufferPointer { bp in
            for i0 in .zero..<c {
                cry = .zero
                for i1 in i0 + 1 ..< c {
                    let i0i1 = i0 + i1
                    let (hi, lo) = lhs[i0].multipliedFullWidth(by: lhs[i1])
                    (bp[i0i1], o0) = bp[i0i1].addingReportingOverflow(lo)
                    (bp[i0i1], o1) = bp[i0i1].addingReportingOverflow(cry)
                    cry = hi
                    if o0 { cry &+= 1 }
                    if o1 { cry &+= 1 }
                }
                bp[i0 + c] = cry
            }
        }
        dw.shiftLeftOne()
        dw.withUnsafeMutableBufferPointer { bp in
            cry = .zero
            for i0 in .zero ..< c {
                let i1 = i0 << 1, i2 = i1 + 1
                let (hi, lo) = lhs[i0].multipliedFullWidth(by: lhs[i0])
                (bp[i1], o0) = bp[i1].addingReportingOverflow(lo)
                (bp[i1], o1) = bp[i1].addingReportingOverflow(cry)
                (bp[i2], o2) = bp[i2].addingReportingOverflow(hi)
                if o0 { (bp[i2], o0) = bp[i2].addingReportingOverflow(1) }
                if o1 { (bp[i2], o1) = bp[i2].addingReportingOverflow(1) }
                cry = .zero
                if o0 { cry &+= 1 }
                if o1 { cry &+= 1 }
                if o2 { cry &+= 1 }
                assert(cry < 2)
            }
        }
        return dw
    }
    
    public func squared() -> Self {
        var dw = self
        dw.square()
        return dw
    }
    
    public func raised(_ rhs: Int) -> Self {
        if rhs == .zero { return .fill(1, with: 1) }
        if rhs == 1 { return self }
        var lhs = self, e = rhs, m = Self.fill(1, with: 1)
        while e > 1 {
            if e.and(1, not: .zero) { m.multiply(lhs) }
            lhs.square()
            e >>= 1
        }
        return lhs.multiplied(m)
    }
}

extension KernelNumerics.BigInt {
    @inlinable
    public static func **(lhs: Self, rhs: Int) -> Self {
        precondition(rhs >= .zero, "illegal exponent")
        return if rhs == 2 {
            if lhs.count > 16 { .init(lhs.storage.squared()) }
            else { lhs * lhs }
        }
        else { .init(lhs.storage.raised(rhs), lhs.isNegative && rhs.andEquals(1) ? .negative : .positive) }
    }
    
    @inlinable
    public func expMod(_ rhs: Self, _ m: Self) -> Self {
        precondition(m.isPositive, "illegal modulus")
        if m.isOne { return .zero }
        let e = rhs.isNegative ? -rhs : rhs
        var res: Self
        if e.count <= 32 { res = Modulus.Barrett(self, m).expMod(e) }
        else if m.isOdd { res = Modulus.Montgomery(self, m).expMod(e) }
        else {
            let t = m.trailingZeroBitCount, om = m >> t, sqm = Self.one << t
            let m0 = Modulus.Montgomery(self, om).expMod(e), m1 = Modulus.Square(self, sqm).expMod(e)
            let i0 = sqm.modInverse(om)
            let i1 = om.modInverse(sqm)
           res = (m0 * sqm * i0 + m1 * om * i1).mod(m)
        }
        if rhs.isNegative { res = res.modInverse(m) }
        if isNegative { return rhs.isEven || res.isZero ? res : m - res }
        else { return res }
    }
    
    @inlinable
    public func expMod(_ rhs: Self, _ m: Int) -> Int {
        precondition(m > .zero, "illegal modulus")
        if m == 1 { return .zero }
        var e = rhs.isNegative ? -rhs : rhs, res = 1, b = abs.mod(m)
        while e.isPositive {
            if e.isOdd { res = m.dividingFullWidth(res.multipliedFullWidth(by: b)).remainder }
            e >>= 1
            b = m.dividingFullWidth(b.multipliedFullWidth(by: b)).remainder
        }
        if rhs.isNegative { res = Self.modInverse(res, m) }
        if isNegative { return rhs.isEven || res == .zero ? res : m - res }
        else { return res }
    }
    
    @inlinable
    public static func quickExpMod(_ lhs: Int, _ rhs: Int, _ m: Int) -> Int {
        assert(m > .zero)
        assert(rhs >= .zero)
        if m == 1 { return .zero }
        var e = rhs, result = 1
        var base = Swift.abs(lhs) % m
        while e > .zero {
            if e.andEquals(1) { result = m.dividingFullWidth(result.multipliedFullWidth(by: base)).remainder }
            e >>= 1
            base = m.dividingFullWidth(base.multipliedFullWidth(by: base)).remainder
        }
        return result
    }
}
