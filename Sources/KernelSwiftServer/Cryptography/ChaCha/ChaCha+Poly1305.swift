//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.ChaCha {
    public struct Poly1305 {
        public var r: KernelNumerics.DoubleWords128
        public var s: KernelNumerics.DoubleWords128
        public var h: KernelNumerics.DoubleWords192
        
        public init(_ rs: KernelNumerics.DoubleWords256) {
            self.r = (rs.0, rs.1)
            self.s = (rs.2, rs.3)
            self.h = val.polyZero
        }
        
        func add(
            _ x: KernelNumerics.DoubleWord,
            _ y: KernelNumerics.DoubleWord,
            _ carry: Bool = false
        ) -> (KernelNumerics.DoubleWord, Bool) {
            let (a, o) = x.addingReportingOverflow(y)
            if o { return (a &+ (carry ? 1 : .zero), true) }
            else if carry { return a.addingReportingOverflow(1) }
            else { return (a, false) }
        }
        
        func subtract(
            _ x: KernelNumerics.DoubleWord,
            _ y: KernelNumerics.DoubleWord,
            _ borrow: Bool = false
        ) -> (KernelNumerics.DoubleWord, Bool) {
            let (a, o) = x.subtractingReportingOverflow(y)
            if o { return (a &- (borrow ? 1 : .zero), true) }
            else if borrow { return a.subtractingReportingOverflow(1) }
            else { return (a, false) }
        }
        
        public mutating func blockFunction(_ b: KernelNumerics.DoubleWords128, _ lastBlock: Bool) {
            var carry: Bool
            (h.0, carry) = add(h.0, b.0)
            (h.1, carry) = add(h.1, b.1, carry)
            h.2 += carry ? lastBlock ? 1 : 2 : lastBlock ? .zero : 1
            
            let h0r0 = KernelNumerics.UInt128(h.0.multipliedFullWidth(by: r.0))
            let h1r0 = KernelNumerics.UInt128(h.1.multipliedFullWidth(by: r.0))
            let h2r0 = KernelNumerics.UInt128(h.2.multipliedFullWidth(by: r.0))
            let h0r1 = KernelNumerics.UInt128(h.0.multipliedFullWidth(by: r.1))
            let h1r1 = KernelNumerics.UInt128(h.1.multipliedFullWidth(by: r.1))
            let h2r1 = KernelNumerics.UInt128(h.2.multipliedFullWidth(by: r.1))
            assert(h2r0.hi == .zero && h2r1.hi == .zero)
            let m0 = h0r0, m1 = h1r0.add(h0r1), m2 = h2r0.add(h1r1), m3 = h2r1, t0 = m0.lo
            let (t1, c1) = add(m1.lo, m0.hi), (t2, c2) = add(m2.lo, m1.hi, c1), (t3, _) = add(m3.lo, m2.hi, c2)
            var cc = KernelNumerics.UInt128(t3, t2 & 0xfffffffffffffffc)
            h = (t0, t1, t2 & 0x3)
            (h.0, carry) = add(h.0, cc.lo)
            (h.1, carry) = add(h.1, cc.hi, carry)
            if carry { h.2 += 1 }
            cc = cc.shiftedRightTwo()
            (h.0, carry) = add(h.0, cc.lo)
            (h.1, carry) = add(h.1, cc.hi, carry)
            if carry { h.2 += 1 }
        }
        
        public mutating func computeTag(_ input: [UInt8]) -> [UInt8] {
            var rem = input.count, index = Int.zero, b: KernelNumerics.DoubleWords128
            while rem >= 16 {
                b = (.zero, .zero)
                for i in (.zero..<8).reversed() { b.0 = b.0 << 8 | .init(input[index + i]) }
                for i in (8..<16).reversed() { b.1 = b.1 << 8 | .init(input[index + i]) }
                blockFunction(b, false)
                rem -= 16
                index += 16
            }
            if rem > .zero {
                b = (.zero, .zero)
                for i in (.zero..<min(8, rem)).reversed() { b.0 = b.0 << 8 | .init(input[index + i]) }
                if rem >= 8 { for i in (.zero..<min(16, rem)).reversed() { b.1 = b.1 << 8 | .init(input[index + i]) } }
                if rem < 8 { b.0 |= 1 << (8 * rem) }
                else { b.1 |= 1 << (8 * rem - 8) }
                blockFunction(b, true)
            }
            var t: KernelNumerics.DoubleWords128, borrow, carry: Bool
            (t.0, borrow) = subtract(h.0, val.poly1305.0)
            (t.1, borrow) = subtract(h.1, val.poly1305.1, borrow)
            (_, borrow) = subtract(h.2, val.poly1305.2, borrow)
            if !borrow { h = (t.0, t.1, h.2) }
            (h.0, carry) = add(h.0, s.0)
            (h.1, _) = add(h.1, s.1, carry)
            var tag: [UInt8] = .zeroes(16)
            for i in .zero..<8 {
                tag[i] = .init(h.0 & 0xff)
                h.0 >>= 8
            }
            for i in 8..<16 {
                tag[i] = .init(h.1 & 0xff)
                h.1 >>= 8
            }
            return tag
        }
    }
}
