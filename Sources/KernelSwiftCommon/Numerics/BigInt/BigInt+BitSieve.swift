//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/10/2023.
//

import Foundation

extension KernelNumerics.BigInt {
    public class BitSieve {
        nonisolated(unsafe) static let small: BitSieve = .init()
        
        public var storage: DoubleWords
        public let length: Int
        public let base: KernelNumerics.BigInt
        public let prob: Int
        
        public init() {
            self.length = 150 * 64
            self.storage = .zeroes(150)
            self.base = .zero
            self.prob = .zero
            setAt(.zero)
            var ni = 1, np = 3, more = true
            repeat {
                sieve(length, ni + np, np)
                (ni, more) = search(length, ni + 1)
                np = ni << 1 + 1
            } while more && (np < length)
        }
        
        public init(_ base: KernelNumerics.BigInt, _ prob: Int) {
            self.base = base
            self.length = 16 * base.bitWidth
            self.storage = .zeroes(((length - 1) >> 6) + 1)
            self.prob = prob
            var o = Int.zero, (s, more) = Self.small.search(Self.small.length, o)
            var cs = s << 1 + 1
            
            repeat {
                let (_, r) = base.storage.divMod(.init(cs))
                o = .init(r)
                o = cs - o
                if o.and(1, equals: .zero) { s += cs }
                sieve(length, (o - 1) >> 1, cs)
                (s, more) = Self.small.search(Self.small.length, s + 1)
                cs = s << 1 + 1
            } while more
        }
        
        public func setAt(_ i: Int) {
            storage[i >> 6] |= .mask.bit.little.all[i & 0x3f]
        }
        
        public func getAt(_ i: Int) -> Bool {
            storage[i >> 6].and(.mask.bit.little.all[i & 0x3f], not: .zero)
        }
        
        public func search(_ l: Int, _ o: Int) -> (i: Int, v: Bool) {
            if o >= l { return (.zero, false) }
            var i = o
            repeat {
                if !getAt(i) { return (i, true) }
                i += 1
            } while i < l - 1
            return (.zero, false)
        }
        
        public func sieve(_ l: Int, _ o: Int, _ s: Int) {
            var i = o
            while i < l {
                setAt(i)
                i += s
            }
        }
        
        public func retrieve() throws -> KernelNumerics.BigInt? {
            var o = 1
            for i0 in .zero..<storage.count {
                try Task.checkCancellation()
                let di = ~storage[i0]
                for i1 in .zero..<64 {
                    try Task.checkCancellation()
                    if di.and(.mask.bit.little.all[i1], not: .zero) {
                        let c = base + o
                        if try KernelNumerics.BigInt.Prime.isProbable(c, prob) { return c }
                    }
                    o += 2
                }
            }
            return nil
        }
    }
}
