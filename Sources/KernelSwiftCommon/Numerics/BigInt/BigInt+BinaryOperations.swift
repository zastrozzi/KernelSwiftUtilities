//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/10/2023.
//

import Foundation

extension KernelNumerics.BigInt.DoubleWords {
    @inlinable
    public func trailingZeroBitCount() -> Int {
        if self == [.zero] { return .zero }
        var i: Int = .zero
        while self[i] == .zero { i += 1 }
        return i * 64 + self[i].trailingZeroBitCount
    }
    
    public var bitWidth: Int {
        var lc: Int = .zero
        var l = last!
        while l != .zero {
            l >>= 1
            lc += 1
        }
        return (count - 1) * 64 + lc
    }
    
    @inlinable
    public func testBit(_ i: Int) -> Bool {
        if i < .zero { return false }
        let dwi = i >> 6
        return dwi < count ? self[dwi].and(.mask.bit.little.all[i & 0x3f], not: .zero) : false
    }
    
    @inlinable
    public mutating func clearBit(_ i: Index) {
        if i < .zero { return }
        let dwi = i >> 6
        if dwi < count {
            self[dwi] &= ~.mask.bit.little.all[i & 0x3f]
            normalise()
        }
    }
    
    @inlinable
    public mutating func setBit(_ i: Index) {
        if i < .zero { return }
        let dwi = i >> 6
        ensureSize(dwi + 1)
        self[dwi] |= .mask.bit.little.all[i & 0x3f]
    }
    
    @inlinable
    public mutating func flipBit(_ i: Index) {
        if i < .zero { return }
        let dwi = i >> 6
        ensureSize(dwi + 1)
        self[dwi] ^= .mask.bit.little.all[i & 0x3f]
        normalise()
    }
    
    @inlinable
    public mutating func shiftLeft(_ amount: Int) {
        if equalTo(.zero) { return }
        let ws = amount >> 6
        let bs = amount & 0x3f
        var w = self[.zero] >> (0x40 - bs)
        if bs > .zero {
            withUnsafeMutableBufferPointer { bp in
                bp[.zero] <<= bs
                for i in 1 ..< bp.count {
                    let bw = bp[i] >> (0x40 - bs)
                    bp[i] <<= bs
                    bp[i] |= w
                    w = bw
                }
            }
        }
        if w != .zero { append(w) }
        prepend(.zeroes(ws))
//        for _ in .zero ..< ws { insert(.zero, at: .zero) }
    }
    
    @inlinable
    public func shiftedLeft(_ amount: Int) -> Self {
        var res = self
        res.shiftLeft(amount)
        return res
    }
    
    @inlinable
    public mutating func shiftLeftOne() {
        var dw = self[.zero].and(.mask.bit.big.b0, not: .zero)
        withUnsafeMutableBufferPointer { bp in
            bp[.zero] <<= 1
            for i in 1 ..< bp.count {
                let w = bp[i].and(.mask.bit.big.b0, not: .zero)
                bp[i] <<= 1
                if dw { bp[i] |= 1 }
                dw = w
            }
        }
        if dw { append(.val.little.base16.one) }
    }
    
    @inlinable
    public func shiftedLeftOne() -> Self {
        var res = self
        res.shiftLeftOne()
        return res
    }
    
    @inlinable
    public mutating func shiftRight(_ amount: Int) {
        let ws = Swift.min(amount >> 6, count)
        removeFirst(ws)
        let bs = amount & 0x3f
        if bs > .zero {
            withUnsafeMutableBufferPointer { bp in
                for i in .zero ..< bp.count {
                    if i > .zero { bp[i - 1] |= bp[i] << (0x40 - bs) }
                    bp[i] >>= bs
                }
            }
        }
        normalise()
    }
    
    @inlinable
    public func shiftedRight(_ amount: Int) -> Self {
        var res = self
        res.shiftRight(amount)
        return res
    }
    
    @inlinable
    public mutating func shiftRightOne() {
        withUnsafeMutableBufferPointer { bp in
            for i in .zero ..< bp.count {
                if i > .zero && bp[i].andEquals(.mask.bit.little.b0) {
                    bp[i - 1] |= .mask.bit.big.b0
                }
                bp[i] >>= 1
            }
        }
        normalise()
    }
    
    @inlinable
    public func shiftedRightOne() -> Self {
        var res = self
        res.shiftLeftOne()
        return res
    }
}

extension KernelNumerics.BigInt: BitwiseComparableInteger {}

extension KernelNumerics.BigInt {
    
    public static func <<(lhs: KernelNumerics.BigInt, rhs: Int) -> KernelNumerics.BigInt {
        if rhs < .zero { return rhs == .min ? (lhs >> Int.max) >> 1 : lhs >> -rhs }
        return .init(rhs == 1 ? lhs.storage.shiftedLeftOne() : lhs.storage.shiftedLeft(rhs), lhs.sign)
    }
    
    public static func <<(lhs: Int, rhs: KernelNumerics.BigInt) -> KernelNumerics.BigInt {
        if lhs < .zero { return lhs == .min ? (rhs >> Int.max) >> 1 : rhs >> -lhs }
        return .init(lhs == 1 ? rhs.storage.shiftedLeftOne() : rhs.storage.shiftedLeft(lhs), rhs.sign)
    }
    
    public static func <<=(lhs: inout KernelNumerics.BigInt, rhs: Int) {
        if rhs < .zero {
            if rhs == .min {
                lhs.storage.shiftRight(.max)
                lhs.storage.shiftRightOne()
            }
            else { lhs.storage.shiftRight(-rhs) }
        }
        else if rhs == 1 { lhs.storage.shiftLeftOne() }
        else { lhs.storage.shiftLeft(rhs) }
    }
    
    public static func >>(lhs: KernelNumerics.BigInt, rhs: Int) -> KernelNumerics.BigInt {
        if rhs < .zero {
            return rhs == Int.min ? (lhs << Int.max) << 1 : lhs << -rhs
        }
        return .init(rhs == 1 ? lhs.storage.shiftedRightOne() : lhs.storage.shiftedRight(rhs), lhs.sign)
    }
    
    public static func >>=(lhs: inout KernelNumerics.BigInt, rhs: Int) {
        if rhs < .zero {
            if rhs == .min {
                lhs.storage.shiftLeft(Int.max)
                lhs.storage.shiftLeftOne()
            } else {
                lhs.storage.shiftLeft(-rhs)
            }
        } else if rhs == 1 {
            lhs.storage.shiftRightOne()
        } else {
            lhs.storage.shiftRight(rhs)
        }
        if lhs.isZero { lhs.sign = .positive }
    }
    
    public static func |(lhs: KernelNumerics.BigInt, rhs: KernelNumerics.BigInt) -> KernelNumerics.BigInt {
        var (blhs, brhs) = DoubleWords.signed(lhs, rhs)
        for i in .zero ..< blhs.count { blhs[i] = blhs[i] | brhs[i] }
        return fromSigned(&blhs)
    }
    
    public static func |=(lhs: inout KernelNumerics.BigInt, rhs: KernelNumerics.BigInt) {
        lhs = lhs | rhs
    }
    
    public static func &(lhs: KernelNumerics.BigInt, rhs: KernelNumerics.BigInt) -> KernelNumerics.BigInt {
        var (blhs, brhs) = DoubleWords.signed(lhs, rhs)
        for i in .zero..<blhs.count { blhs[i] = blhs[i] & brhs[i] }
        return fromSigned(&blhs)
    }
    
    public static func &=(lhs: inout KernelNumerics.BigInt, rhs: KernelNumerics.BigInt) {
        lhs = lhs & rhs
    }
    
    public static func ^(lhs: KernelNumerics.BigInt, rhs: KernelNumerics.BigInt) -> KernelNumerics.BigInt {
        var (blhs, brhs) = DoubleWords.signed(lhs, rhs)
        for i in .zero ..< blhs.count { blhs[i] = blhs[i] ^ brhs[i] }
        return fromSigned(&blhs)
    }
    
    public static func ^=(lhs: inout KernelNumerics.BigInt, rhs: KernelNumerics.BigInt) {
        lhs = lhs ^ rhs
    }
    
    public static prefix func ~(lhs: KernelNumerics.BigInt) -> KernelNumerics.BigInt {
        -lhs - .one
    }
    
    public mutating func clearBit(_ i: Int) { storage.clearBit(i) }
    public mutating func flipBit(_ i: Int) { storage.flipBit(i) }
    public mutating func setBit(_ i: Int) { storage.setBit(i) }
    public func testBit(_ i: Int) -> Bool { storage.testBit(i) }
}
