//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/10/2023.
//

import Foundation

extension KernelNumerics {
    public struct BigInt: Sendable {
        public enum Sign: Sendable {
            case positive
            case negative
            
            public var isPositive: Bool { self == .positive }
            public var isNegative: Bool { self == .negative }
        }
        
        public internal(set) var storage: DoubleWords
        public internal(set) var sign: Sign
        
        public init(_ doubleWords: DoubleWords, _ sign: Sign = .positive) {
            self.storage = doubleWords
            self.storage.normalise()
            self.sign = sign
            if isZero { self.sign = .positive }
        }
        
        public init(_ doubleWords: DoubleWords, _ negative: Bool) {
            self.init(doubleWords, negative ? .negative : .positive)
        }
        
        public init(_ v: Int) {
            switch v {
            case .min: self.init([.mask.bit.big.b0], .negative)
            case ..<(.zero): self.init([.init(-v)], .negative)
            default: self.init([.init(v)], .positive)
            }
        }
        
        public init(_ d: DoubleWord) { self.init([d], .positive) }
        
        public init?(_ d: Double) {
            if d.isNaN || d.isInfinite { return nil }
            let b = d.bitPattern
            let e = Int(b >> 52) & Int(UInt64.val.little.max52bit) - 0x433
            let s = e == -0x433 ? b & .val.little.max52bit << 1 : b & .val.little.max52bit | (1 << 52)
            if e < .zero { self.init([s].shiftedRight(-e), d < .zero ? .negative : .positive) }
            else { self.init([s].shiftedLeft(e), d < .zero ? .negative : .positive) }
        }
        
        public init?(_ s: String, radix: Int = 10) {
            if radix < 2 || radix > 36 { return nil }
            var sign: Sign = .positive, s = s
            if s.hasPrefix("-") {
                sign = .negative
                s.remove(at: s.startIndex)
            } 
            else if s.hasPrefix("+") { s.remove(at: s.startIndex) }
            if s.isEmpty { return nil }
            let d = UInt64.val.little.radix.allDigits[radix]
            let dg = s.count / d
            let p = UInt64.val.little.radix.all[radix]
            var g = s.count - dg * d
            if g == .zero { g = d }
            var dw: DoubleWords = [.zero], i = Int.zero, si = s.startIndex, ei = si
            while si != s.endIndex {
                ei = s.index(after: ei)
                i += 1
                if i == g {
                    guard let w: DoubleWord = .init(s[si..<ei], radix: radix) else { return nil }
                    if radix == 16 { dw.shiftLeft(60) } else { dw.multiply(p) }
                    dw.add(w)
                    g = d; i = .zero; si = ei
                }
            }
            self.init(dw, sign)
        }
        
//        @inlinable @inline(__always)
        public init(bitWidth: Int) {
            precondition(bitWidth > .zero, "invalid bitwidth")
            let (q, r) = bitWidth.quotientAndRemainder(dividingBy: 64)
            var dw: DoubleWords = .generateSecRandom(count: (r == .zero ? q : (q + 1)))
            if r > Int.zero {
                dw[dw.count - 1] <<= (64 - r)
                dw[dw.count - 1] >>= (64 - r)
            }
            self.init(dw)
        }
        
        public init(magnitudeBytes dwb: [UInt8]) {
            precondition(!dwb.isEmpty, "empty magnitude bytes")
            var bb = dwb
            if bb[.zero] > .val.max7bit { bb.insert(.zero, at: .zero) }
            self.init(signedBytes: bb)
        }
        
        public init(signedBytes b: [UInt8]) {
            precondition(!b.isEmpty, "empty signed bytes")
            self.sign = b[.zero] > .val.max7bit ? .negative : .positive
            self.storage = []
            var bb = b
            if isNegative { while bb.count > 1 && bb[.zero] == .val.max8bit { bb.remove(at: .zero) } }
            else { while bb.count > 1 && bb[.zero] == .zero { bb.remove(at: .zero) } }
            if isNegative {
                var cry = true, bbi = bb.count
                for _ in .zero..<bb.count {
                    bbi -= 1
                    bb[bbi] = ~bb[bbi]
                    if cry {
                        if bb[bbi] == .val.max8bit { bb[bbi] = .zero }
                        else { bb[bbi] += 1; cry = false }
                    }
                }
                if cry { bb.insert(1, at: .zero) }
            }
            let ch = bb.count / 8, rem = bb.count - ch * 8
            storage = .zeroes(ch + (rem == .zero ? .zero : 1))
            var bi = Int.zero, dwi = count
            if rem > .zero { dwi -= 1 }
            for _ in .zero..<rem {
                storage[dwi] <<= 8
                storage[dwi] |= .init(bb[bi])
                bi += 1
            }
            for _ in .zero..<ch {
                dwi -= 1
                for _ in .zero..<8 {
                    storage[dwi] <<= 8
                    storage[dwi] |= .init(bb[bi])
                    bi += 1
                }
            }
        }
        
        public var abs: Self { .init(self.storage) }
        public func toAbs() -> Self { .init(magnitudeBytes: self.magnitudeBytes()) }
        public var bitWidth: Int { storage.bitWidth }
        public var count: Int { storage.count }
        public var description: String { toString() }
        public var isEven: Bool { storage[.zero].and(.mask.bit.little.b0, equals: .zero) }
        public var isOdd: Bool { storage[.zero].andEquals(.mask.bit.little.b0) }
        public var isZero: Bool { count == 1 && storage[.zero] == .zero }
        public var isNotZero: Bool { count > 1 || storage[.zero] > .zero }
        public var isOne: Bool { count == 1 && storage[.zero] == .val.little.base10.one && isPositive }
        public var isNegative: Bool {
            get { sign == .negative }
            mutating set { sign = newValue ? .negative : .positive }
        }
        public var isPositive: Bool {
            get { sign == .positive }
            mutating set { sign = newValue ? .positive : .negative }
        }
        public var leadingZeroBitCount: Int { isZero ? .zero : storage.last!.leadingZeroBitCount }
        public var trailingZeroBitCount: Int { storage.trailingZeroBitCount() }
        public var population: Int { storage.map { $0.population() }.reduce(0, +) }
        public var signum: Int { isZero ? .zero : isNegative ? -1 : 1 }
        
        public mutating func setSign(_ s: Sign) { sign = isZero ? .positive : s }
        public mutating func negate() { if isNotZero { isNegative.toggle() } }
        public func negated() -> Self {
            var s = self
            s.negate()
            return s
        }
        
        public func toDouble() -> Double {
            storage.reversed()
                .reduce(into: .zero) { $0 = $0 * Self.util.d2pow64 + .init($1) }
                .negated(isNegative)
        }
        
        public func toInt() -> Int? {
            if self.storage.count > 1 { return nil }
            let dw0 = self.storage[.zero]
            if self.isNegative { return dw0 > .mask.bit.little.b63 ? nil : (dw0 == .mask.bit.little.b63 ? .min : -Int(dw0)) }
            else { return dw0 < .mask.bit.little.b63 ? Int(dw0) : nil }
//            else { return dw0 < 0x8000000000000000 ? Int(dw0) : nil }
        }
        
        public func toString(radix: Int = 10, uppercase: Bool = false) -> String {
            precondition(radix >= 2 && radix <= 36, "Invalid radix \(radix)")
            if isZero { return "0" }
            let r: UInt64 = .val.little.radix.all[radix]
            var rg: [String] = [], dw = storage
            while !dw.equalTo(0) {
                let (q, rem) = dw.divMod(r)
                rg.append(.init(rem, radix: radix, uppercase: uppercase))
                dw = q
            }
            var res = isNegative ? "-" : ""
            res += rg.last!
            for i in (.zero..<(rg.count - 1)).reversed() {
                let lzc = UInt64.val.little.radix.allDigits[radix] - rg[i].count
                res += Self.util.zeroPadding.prefix(lzc) + rg[i]
            }
            return res
        }
        
        @inlinable
        public static func randomLessThan(_ lhs: borrowing BigInt) -> BigInt {
            precondition(lhs.isPositive, "Must be positive")
            var res: BigInt
            repeat {
                res = .init(bitWidth: lhs.bitWidth)
            } while res >= lhs
            return res
        }
        
        public static func binomial(_ n: Int, _ k: Int) -> Self {
            precondition(n >= k && k >= .zero)
            if k == .zero || k == n { return .one }
            let k1 = min(k, n - k), nk1: DoubleWord = .init(n - k1)
            var c: DoubleWords = .fill(1, with: 1)
            for i in 1...k1 {
                c.multiply(nk1 + .init(i))
                c = c.divMod(.init(i)).q
            }
            return .init(c)
        }
    }
}

