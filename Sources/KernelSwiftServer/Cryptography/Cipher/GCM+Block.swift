//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.Cipher.GCM {
    public struct Block: Sendable {
        @_documentation(visibility: private)
        public typealias DoubleWord = KernelNumerics.DoubleWord
        
        public var hi: DoubleWord
        public var lo: DoubleWord
        
        public init(hi: DoubleWord, lo: DoubleWord) {
            self.hi = hi
            self.lo = lo
        }
        
        public init(_ b: [UInt8]) {
            self.hi = .init(b[.zero])
            for i in 1...7 {
                self.hi <<= 8
                self.hi |= .init(b[i])
            }
            self.lo = .init(b[8])
            for i in 9...15 {
                self.lo <<= 8
                self.lo |= .init(b[i])
            }
        }
        
        public var bytes: [UInt8] {
            var b: [UInt8] = .zeroes(16)
            var d = hi
            for i in (1...7).reversed() {
                b[i] = .init(d & 0xff)
                d >>= 8
            }
            b[.zero] = .init(d & 0xff)
            d = lo
            for i in (9...15).reversed() {
                b[i] = .init(d & 0xff)
                d >>= 8
            }
            b[8] = .init(d & 0xff)
            return b
        }
        
        public mutating func increment() {
            if lo.andEquals(.mask.bit.bitCheck32) { lo &= .mask.bit.bitSwap32 }
            else { lo += 1 }
        }
        
        public mutating func removeBytes(_ count: Int) {
            if count > 7 {
                hi >>= (count - 8) * 8
                hi <<= (count - 8) * 8
                lo = .zero
            }
            else {
                lo >>= count * 8
                lo <<= count * 8
            }
        }
        
        public mutating func shiftRight() {
            let b0 = hi.andEquals(1)
            hi >>= 1
            lo >>= 1
            if b0 { lo |= .mask.bit.big.b0 }
        }
        
        public mutating func add(_ rhs: Self) {
            hi ^= rhs.hi
            lo ^= rhs.lo
        }
        
        public mutating func double() {
            var h0 = hi >> 1
            var l0 = lo >> 1
            l0 |= hi << 63
            if lo.andEquals(1) { h0 ^= val.hiMax }
            hi = h0
            lo = l0
        }
        
        public mutating func multiply(_ rhs: Self) {
            var z = val.blockZero
            var v = rhs
            var m0: DoubleWord = .mask.bit.big.b0
            for _ in .zero..<64 {
                if hi.and(m0, not: .zero) { z.add(v) }
                m0 >>= 1
                if v.lo.andEquals(1) {
                    v.shiftRight()
                    v.add(val.blockR)
                }
                else { v.shiftRight() }
            }
            var m1: DoubleWord = .mask.bit.big.b0
            for _ in .zero..<64 {
                if lo.and(m1, not: .zero) { z.add(v) }
                m1 >>= 1
                if v.lo.andEquals(1) {
                    v.shiftRight()
                    v.add(val.blockR)
                }
                else { v.shiftRight() }
            }
            hi = z.hi
            lo = z.lo
        }
    }
}

extension KernelCryptography.Cipher.GCM {
    public typealias val = ConstantValues
    
    public enum ConstantValues {
        public static let hiMax: Block.DoubleWord = 0xe100000000000000
        public static let blockR: Block = .init(hi: hiMax, lo: .zero)
        public static let blockZero: Block = .init(hi: .zero, lo: .zero)
        
        public static let shoupTable: [Int] = [
            0b0000, 0b1000, 0b0100, 0b1100,
            0b0010, 0b1010, 0b0110, 0b1110,
            0b0001, 0b1001, 0b0101, 0b1101,
            0b0011, 0b1011, 0b0111, 0b1111
        ]
        
        static let reductionTable: [Block.DoubleWord] = [
            0x0000000000000000, 0x1c20000000000000, 0x3840000000000000, 0x2460000000000000,
            0x7080000000000000, 0x6ca0000000000000, 0x48c0000000000000, 0x54e0000000000000,
            0xe100000000000000, 0xfd20000000000000, 0xd940000000000000, 0xc560000000000000,
            0x9180000000000000, 0x8da0000000000000, 0xa9c0000000000000, 0xb5e0000000000000
        ]
    }
}
