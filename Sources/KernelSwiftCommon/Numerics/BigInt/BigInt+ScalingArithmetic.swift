//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/10/2023.
//

import Foundation

extension KernelNumerics.BigInt.DoubleWords {
    @inlinable
    public mutating func multiply(_ rhs: Self) {
        let m = count, n = rhs.count
        self = switch (m, n) {
        case (..<Karatsuba.val.threshold, _), (_, ..<Karatsuba.val.threshold): Self.smallMultiply(self, rhs)
        case (..<ToomCook.val.threshold, _), (_, ..<ToomCook.val.threshold): Karatsuba.multiply(self, rhs)
        case (..<FourierFastTransform.val.threshold, _), (_, ..<FourierFastTransform.val.threshold): ToomCook.multiply(self, rhs)
        default: FourierFastTransform.multiply(self, rhs)
        }
        self.normalise()
    }
    
    @inlinable
    public mutating func multiply(_ rhs: KernelNumerics.BigInt.DoubleWord) {
        let c = count
        var dw: Self = .zeroes(c + 1), o = false
        dw.withUnsafeMutableBufferPointer { bp in
            for i in .zero..<c {
                let (hi, lo) = self[i].multipliedFullWidth(by: rhs)
                (bp[i], o) = bp[i].addingReportingOverflow(lo)
                bp[i + 1] = hi
                if o { bp[i + 1] &+= 1 }
            }
        }
        dw.normalise()
        self = dw
    }
    
    @inlinable
    public static func smallMultiply(_ lhs: borrowing Self, _ rhs: Self) -> Self {
        let lc = lhs.count, rc = rhs.count
        var dw: Self = .zeroes(lc + rc), cry = Element.zero, o0 = false, o1 = false
        dw.withUnsafeMutableBufferPointer { bp in
            for i0 in .zero..<lc {
                cry = .zero
                for i1 in .zero..<rc {
                    let i0i1 = i0 + i1
                    let (hi, lo) = lhs[i0].multipliedFullWidth(by: rhs[i1])
                    (bp[i0i1], o0) = bp[i0i1].addingReportingOverflow(lo)
                    (bp[i0i1], o1) = bp[i0i1].addingReportingOverflow(cry)
                    cry = hi
                    if o0 { cry &+= 1 }
                    if o1 { cry &+= 1 }
                }
                bp[i0 + rc] = cry
            }
        }
        return dw
    }
    
    public func multiplied(_ rhs: Self) -> Self {
        var lhs = self
        lhs.multiply(rhs)
        return lhs
    }
    
    public func multiplied(_ rhs: Element) -> Self {
        var lhs = self
        lhs.multiply(rhs)
        return lhs
    }
    
    public func divExact(_ rhs: Self) -> Self {
        precondition(!rhs.equalTo(.zero), "cannot divide by zero")
        if equalTo(.zero) { return .zeroes(1) }
        var lhs = self, rhs = rhs
        let t = rhs.trailingZeroBitCount()
        lhs.shiftRight(t); rhs.shiftRight(t)
        let a1 = Element.inverseMod64(rhs[.zero]), k = lhs.count - rhs.count + 1
        var res: Self = .zeroes(k)
        for ki in .zero ..< k {
            let bk = a1 &* lhs[ki]
            res[ki] = bk
            let n = Swift.min(rhs.count, k - ki)
            var w: Self = .zeroes(n + 1), o = false
            w.withUnsafeMutableBufferPointer { wbp in
                for i in .zero ..< n {
                    let (hi, lo) = rhs[i].multipliedFullWidth(by: bk)
                    (wbp[i], o) = wbp[i].addingReportingOverflow(lo)
                    wbp[i + 1] = hi
                    if o { wbp[i + 1] &+= 1 }
                }
            }
            lhs.subtract(w, ki)
        }
        return res
    }
}

extension KernelNumerics.BigInt {
    public static func *(lhs: Self, rhs: Self) -> Self {
        var prod = lhs
        prod *= rhs
        return prod
    }

    public static func *(lhs: Int, rhs: Self) -> Self {
        var prod = rhs
        prod *= lhs
        return prod
    }

    public static func *(lhs: Self, rhs: Int) -> Self {
        var prod = lhs
        prod *= rhs
        return prod
    }

    public static func *=(lhs: inout Self, rhs: Self) {
        lhs.storage.multiply(rhs.storage)
        lhs.setSign(lhs.isNegative == rhs.isNegative ? .positive : .negative)
    }

    public static func *=(lhs: inout Self, rhs: Int) {
        if rhs > .zero { lhs.storage.multiply(DoubleWord(rhs)) }
        else if rhs < .zero {
            if rhs == Int.min { lhs.storage.shiftLeft(63) }
            else { lhs.storage.multiply(DoubleWord(-rhs)) }
            lhs.setSign(lhs.isNegative ? .positive : .negative)
        }
        else { lhs = .zero }
    }
    
    public static func /(lhs: Self, rhs: Self) -> Self { lhs.quotientAndRemainder(dividingBy: rhs).q }
    
    public static func /(lhs: Int, rhs: Self) -> Self { .init(lhs) / rhs }
    public static func /(lhs: Self, rhs: Int) -> Self { lhs.quotientAndRemainder(dividingBy: rhs).q }
    public static func /=(lhs: inout Self, rhs: Self) { lhs = lhs / rhs }
    public static func /=(lhs: inout Self, rhs: Int) { lhs = lhs / rhs }
    public static func %(lhs: Self, rhs: Self) -> Self { lhs.quotientAndRemainder(dividingBy: rhs).r }
    public static func %(lhs: Int, rhs: Self) -> Self { .init(lhs) % rhs }
    public static func %(lhs: Self, rhs: Int) -> Self { lhs % .init(rhs) }
    public static func %=(lhs: inout Self, rhs: Self) { lhs = lhs % rhs }
    public static func %=(lhs: inout Self, rhs: Int) { lhs = lhs % rhs }
    
    public func quotientAndRemainder(dividingBy d: Self) -> (q: Self, r: Self) {
        var q = Self.zero, r = Self.zero
        if d.count > Self.val.bz.divLimit && count > d.count + Self.val.bz.divLimit {
            (q, r) = BurnikelZiegler.divMod(self, d)
        }
        else { (q.storage, r.storage) = storage.divMod(d.storage) }
        q.setSign(isNegative != d.isNegative ? .negative : .positive)
        r.setSign(sign)
        return (q, r)
    }
    
    public func quotientAndRemainder(dividingBy d: Self, _ q: inout Self, _ r: inout Self) {
        (q, r) = quotientAndRemainder(dividingBy: d)
    }
    
    public func quotientAndRemainder(dividingBy d: Int) -> (q: Self, r: Int) {
        var w: DoubleWord, r: DoubleWord
        if d < .zero { w = d == .min ? .mask.bit.little.b63 : .init(-d) }
        else { w = .init(d) }
        var q = Self.zero
        (q.storage, r) = storage.divMod(w)
        q.setSign(isNegative && d > .zero || isPositive && d < .zero ? .negative : .positive)
        let rem: Int = isNegative ? -.init(r) : .init(r)
        return (q, rem)
    }
    
    public func quotientAndRemainder(dividingBy d: Int, _ q: inout Self, _ r: inout Int) {
        (q, r) = quotientAndRemainder(dividingBy: d)
    }
    
    public func quotientExact(dividingBy d: Self) -> Self {
        .init(storage.divExact(d.storage), isNegative != d.isNegative)
    }
    
    public static func lowestCommonMultiple(_ lhs: Self, _ rhs: Self) -> Self {
        lhs.isZero || rhs.isZero ? .zero : (lhs * rhs).abs.quotientExact(dividingBy: GCD.divisor(lhs, rhs))
    }
}

extension KernelNumerics.BigInt {
    public static func mulMod(_ lhs: Int, _ rhs: Int, _ m: Int) -> Int {
        m.dividingFullWidth(lhs.multipliedFullWidth(by: rhs)).remainder
    }
}

extension KernelNumerics.BigInt.DoubleWords {
    public func divMod(_ rhs: Element) -> (q: Self, r: Element) {
        precondition(rhs > .zero, "cannot divide by zero")
        if equalTo(.zero) { return ([.zero], .zero) }
        let rl = rhs.leadingZeroBitCount, rd = rhs << rl
        let rq = rd.dividingFullWidth((.val.little.max64bit - rd, .val.little.max64bit)).quotient
        var ls = shiftedLeft(rl), r = Element.zero
        for i in (.zero..<ls.count).reversed() { (ls[i], r) = Granlund.divTwoDoubleWord(r, ls[i], rd, rq) }
        ls.normalise()
        return (ls, r >> rl)
    }
    
    public func divMod(_ rhs: Self) -> (q: Self, r: Self) {
        if lessThan(rhs) { return (.zeroes(1), self) }
        else if rhs.count == 1 {
            let (q, r) = divMod(rhs[.zero])
            return (q, [r])
        } else {
            var lhs = self, rhs = rhs
            let rc = rhs.count, lc = lhs.count, d = rhs[rc - 1].leadingZeroBitCount
            rhs.shiftLeft(d); lhs.shiftLeft(d)
            lhs.append(.zero)
            var h0 = Element.zero, h1 = Element.zero, k = lc - rc
            let r0 = rhs[rc - 1], r1 = r0.dividingFullWidth((.val.little.max64bit - r0, .val.little.max64bit)).quotient
            var q: Self = .zeroes(k + 1), o: Bool
            repeat {
                if r0 == lhs[k + rc] {
                    h0 = .val.little.max64bit
                    (h1, o) = lhs[k + rc].addingReportingOverflow(lhs[k + rc - 1])
                } else {
                    (h0, h1) = Granlund.divTwoDoubleWord(lhs[k + rc], lhs[k + rc - 1], r0, r1)
                    o = false
                }
                while !o {
                    let (hi, lo) = h0.multipliedFullWidth(by: rhs[rc - 2])
                    if hi < h1 || (hi == h1 && lo <= lhs[k + rc - 2]) { break }
                    h0 -= 1
                    (h1, o) = h1.addingReportingOverflow(r0)
                }
                if h0 != .zero {
                    let b = lhs.subtract(rhs.multiplied(h0), k)
                    if b { h0 -= 1; lhs.add(rhs, k, false) }
                }
                q[k] = h0
                k -= 1
            } while k >= Int.zero
            lhs.shiftRight(d)
            q.normalise()
            return (q, lhs)
        }
    }
}
