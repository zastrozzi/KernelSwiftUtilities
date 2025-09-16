//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

import Foundation

extension UInt {
    @inlinable
    var halfShift: UInt {
        return UInt(UInt.bitWidth / 2)
    }
    
    @inlinable
    var high: UInt {
        return self &>> halfShift
    }

    @inlinable
    var low: UInt {
        let mask = 1 &<< halfShift - 1
        return self & mask
    }

    @inlinable
    var upshifted: UInt {
        return self &<< halfShift
    }

    @inlinable
    var split: (high: UInt, low: UInt) {
        return (high, low)
    }

    public init(_ value: (high: UInt, low: UInt)) {
        self = value.high.upshifted + value.low
    }
    
    @inlinable
    static func quotient(dividing u: (high: UInt, low: UInt), by vn: UInt) -> UInt {
        let (vn1, vn0) = vn.split
        let (q, r) = u.high.quotientAndRemainder(dividingBy: vn1)
        let p = q * vn0
        if q.high == 0 && p <= r.upshifted + u.low { return q }
        let r2 = r + vn1
        if r2.high != 0 { return q - 1 }
        if (q - 1).high == 0 && p - vn0 <= r2.upshifted + u.low { return q - 1 }
        return q - 2
    }
    
    @inlinable
    static func quotientAndRemainder(dividing u: (high: UInt, low: UInt), by v: UInt) -> (quotient: UInt, remainder: UInt) {
        let q = quotient(dividing: u, by: v)
        let r = UInt(u) &- q &* v
        assert(r < v)
        return (q, r)
    }
    
    @inlinable
    static func fastDividingFullWidth(_ x: UInt, dividend: (high: UInt, low: UInt)) -> (quotient: UInt, remainder: UInt) {
        precondition(dividend.high < x)

//        func quotient(dividing u: (high: UInt, low: UInt), by vn: UInt) -> UInt {
//            let (vn1, vn0) = vn.split
//            let (q, r) = u.high.quotientAndRemainder(dividingBy: vn1)
//            let p = q * vn0
//            if q.high == 0 && p <= r.upshifted + u.low { return q }
//            let r2 = r + vn1
//            if r2.high != 0 { return q - 1 }
//            if (q - 1).high == 0 && p - vn0 <= r2.upshifted + u.low { return q - 1 }
//            return q - 2
//        }
//
//        
//        func quotientAndRemainder(dividing u: (high: UInt, low: UInt), by v: UInt) -> (quotient: UInt, remainder: UInt) {
//            let q = quotient(dividing: u, by: v)
//            let r = UInt(u) &- q &* v
//            assert(r < v)
//            return (q, r)
//        }

        let z = x.leadingZeroBitCount.magnitude
        let w = UInt.bitWidth.magnitude - z
        let vn = x << z

        let un32 = (z == 0 ? dividend.high : (dividend.high &<< z) | (dividend.low &>> w)) // No bits are lost
        let un10 = dividend.low &<< z
        let (un1, un0) = un10.split

        let (q1, un21) = quotientAndRemainder(dividing: (un32, un1), by: vn)
        let (q0, rn) = quotientAndRemainder(dividing: (un21, un0), by: vn)

        let mod = rn >> z
        let div = UInt((q1, q0))
        return (div, mod)
    }

    @inlinable
    internal func fastDividingFullWidth(_ dividend: (high: UInt, low: UInt.Magnitude)) -> (quotient: UInt, remainder: UInt) {
        precondition(dividend.high < self)

        func quotient(dividing u: (high: UInt, low: UInt), by vn: UInt) -> UInt {
            let (vn1, vn0) = vn.split
            let (q, r) = u.high.quotientAndRemainder(dividingBy: vn1)
            let p = q * vn0
            if q.high == 0 && p <= r.upshifted + u.low { return q }
            let r2 = r + vn1
            if r2.high != 0 { return q - 1 }
            if (q - 1).high == 0 && p - vn0 <= r2.upshifted + u.low { return q - 1 }
            return q - 2
        }

        func quotientAndRemainder(dividing u: (high: UInt, low: UInt), by v: UInt) -> (quotient: UInt, remainder: UInt) {
            let q = quotient(dividing: u, by: v)
            let r = UInt(u) &- q &* v
            assert(r < v)
            return (q, r)
        }

        let z = UInt(self.leadingZeroBitCount)
        let w = UInt(UInt.bitWidth) - z
        let vn = self << z

        let un32 = (z == 0 ? dividend.high : (dividend.high &<< z) | (dividend.low &>> w)) // No bits are lost
        let un10 = dividend.low &<< z
        let (un1, un0) = un10.split

        let (q1, un21) = quotientAndRemainder(dividing: (un32, un1), by: vn)
        let (q0, rn) = quotientAndRemainder(dividing: (un21, un0), by: vn)

        let mod = rn >> z
        let div = UInt((q1, q0))
        return (div, mod)
    }

    @inlinable
    static func approximateQuotient(dividing x: (UInt, UInt, UInt), by y: (UInt, UInt)) -> UInt {
        var q: UInt
        var r: UInt
        if x.0 == y.0 {
            q = UInt.max
            let (s, o) = x.0.addingReportingOverflow(x.1)
            if o { return q }
            r = s
        }
        else {
            (q, r) = y.0.fastDividingFullWidth((x.0, x.1))
        }

        let (ph, pl) = q.multipliedFullWidth(by: y.1)
        if ph < r || (ph == r && pl <= x.2) { return q }

        let (r1, ro) = r.addingReportingOverflow(y.0)
        if ro { return q - 1 }

        let (pl1, so) = pl.subtractingReportingOverflow(y.1)
        let ph1 = (so ? ph - 1 : ph)

        if ph1 < r1 || (ph1 == r1 && pl1 <= x.2) { return q - 1 }
        return q - 2
    }
}
//
//
//extension FixedWidthInteger {
//    private var halfShift: Self {
//        return Self(Self.bitWidth / 2)
//
//    }
//    private var high: Self {
//        return self &>> halfShift
//    }
//
//    private var low: Self {
//        let mask: Self = 1 &<< halfShift - 1
//        return self & mask
//    }
//
//    private var upshifted: Self {
//        return self &<< halfShift
//    }
//
//    private var split: (high: Self, low: Self) {
//        return (self.high, self.low)
//    }
//
//    private init(_ value: (high: Self, low: Self)) {
//        self = value.high.upshifted + value.low
//    }
//
//    internal func fastDividingFullWidth(_ dividend: (high: Self, low: Self.Magnitude)) -> (quotient: Self, remainder: Self) {
//        precondition(dividend.high < self)
//
//        func quotient(dividing u: (high: Self, low: Self), by vn: Self) -> Self {
//            let (vn1, vn0) = vn.split
//            let (q, r) = u.high.quotientAndRemainder(dividingBy: vn1)
//            let p = q * vn0
//            if q.high == 0 && p <= r.upshifted + u.low { return q }
//            let r2 = r + vn1
//            if r2.high != 0 { return q - 1 }
//            if (q - 1).high == 0 && p - vn0 <= r2.upshifted + u.low { return q - 1 }
//            return q - 2
//        }
//
//        func quotientAndRemainder(dividing u: (high: Self, low: Self), by v: Self) -> (quotient: Self, remainder: Self) {
//            let q = quotient(dividing: u, by: v)
//            let r = Self(u) &- q &* v
//            assert(r < v)
//            return (q, r)
//        }
//
//        let z = Self(self.leadingZeroBitCount)
//        let w = Self(Self.bitWidth) - z
//        let vn = self << z
//
//        let un32 = (z == 0 ? dividend.high : (dividend.high &<< z) | ((dividend.low as! Self) &>> w)) // No bits are lost
//        let un10 = dividend.low &<< z
//        let (un1, un0) = un10.split
//
//        let (q1, un21) = quotientAndRemainder(dividing: (un32, (un1 as! Self)), by: vn)
//        let (q0, rn) = quotientAndRemainder(dividing: (un21, (un0 as! Self)), by: vn)
//
//        let mod = rn >> z
//        let div = Self((q1, q0))
//        return (div, mod)
//    }
//
//    static func approximateQuotient(dividing x: (Self, Self, Self), by y: (Self, Self)) -> Self {
//        var q: Self
//        var r: Self
//        if x.0 == y.0 {
//            q = Self.max
//            let (s, o) = x.0.addingReportingOverflow(x.1)
//            if o { return q }
//            r = s
//        }
//        else {
//            (q, r) = y.0.fastDividingFullWidth((x.0, (x.1 as! Magnitude)))
//        }
//
//        let (ph, pl) = q.multipliedFullWidth(by: y.1)
//        if ph < r || (ph == r && pl <= x.2) { return q }
//
//        let (r1, ro) = r.addingReportingOverflow(y.0)
//        if ro { return q - 1 }
//
//        let (pl1, so) = pl.subtractingReportingOverflow((y.1 as! Magnitude))
//        let ph1 = (so ? ph - 1 : ph)
//
//        if ph1 < r1 || (ph1 == r1 && pl1 <= x.2) { return q - 1 }
//        return q - 2
//    }
//}
