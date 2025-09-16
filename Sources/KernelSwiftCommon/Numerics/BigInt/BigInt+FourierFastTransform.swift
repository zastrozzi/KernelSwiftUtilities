//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/10/2023.
//

import Foundation

extension KernelNumerics.BigInt.ConstantValues {
    public typealias fft = FourierFastTransform
    
    @_documentation(visibility: private)
    public enum FourierFastTransform {
        public static let threshold: Int = 6000
    }
}

extension KernelNumerics.BigInt.DoubleWords {
    @_documentation(visibility: private)
    public typealias FourierFastTransform = BigInt.FourierFastTransform
}

extension KernelNumerics.BigInt {
    public enum FourierFastTransform {
        @_documentation(visibility: private)
        public typealias BigInt = KernelNumerics.BigInt
        @_documentation(visibility: private)
        public typealias DoubleWord = KernelNumerics.BigInt.DoubleWord
        @_documentation(visibility: private)
        public typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
        @_documentation(visibility: private)
        public typealias val = KernelNumerics.BigInt.ConstantValues.FourierFastTransform
        
        public struct Fermat {
            public let n: Int
            public let N: DoubleWords
            public let k: Int
            public let K: Int
            public let m: Int
            public let theta: Int
            
            public init(_ bw: Int) {
                let lbw = 64 - bw.leadingZeroBitCount
                self.k = (lbw - 6) >> 1
                self.K = 1 << k
                self.m = 1 << (lbw - 6 - k)
                self.n = (((2 << lbw) >> k + k) >> k + 1) << k
                var x: DoubleWords = .fill(1, with: 1).shiftedLeft(n)
                x.setBit(.zero)
                self.N = x
                self.theta = n >> k
                assert(n >= (2 << lbw) >> k + k)
                assert(n % K == .zero)
                assert(n % 64 == .zero)
            }
        }
        
        public static func multiply(_ lhs: borrowing DoubleWords, _ rhs: DoubleWords) -> DoubleWords {
            let fermat = Fermat(lhs.bitWidth + rhs.bitWidth)
            var dwa0: [DoubleWords] = .init(repeating: .zeroes(1), count: fermat.K)
            var o = Int.zero, i = Int.zero, t = Int.zero
            while o < lhs.count {
                let e = min(o + fermat.m, lhs.count)
                dwa0[i] = .init(lhs[o..<e])
                shiftReduce(&dwa0[i], t, f: fermat)
                o += fermat.m; i += 1; t += fermat.theta
            }
            var dwa1: [DoubleWords] = .init(repeating: .zeroes(1), count: fermat.K)
            o = .zero; i = .zero; t = .zero
            while o < rhs.count {
                let e = min(o + fermat.m, rhs.count)
                dwa1[i] = .init(rhs[o..<e])
                shiftReduce(&dwa1[i], t, f: fermat)
                o += fermat.m; i += 1; t += fermat.theta
            }
            let w = fermat.theta << 1
            forward(&dwa0, w, .zero, .zero, f: fermat)
            forward(&dwa1, w, .zero, .zero, f: fermat)
            for i in .zero..<fermat.K {
                dwa0[i].multiply(dwa1[i])
                reduce(&dwa0[i], f: fermat)
            }
            backward(&dwa0, w, .zero, .zero, f: fermat)
            return finalise(&dwa0, f: fermat)
        }
        
        public static func square(_ lhs: borrowing DoubleWords) -> DoubleWords {
            let fermat = Fermat(lhs.bitWidth * 2)
            var dwa: [DoubleWords] = .init(repeating: .zeroes(1), count: fermat.K)
            var o = Int.zero, i = Int.zero, t = Int.zero
            while o < lhs.count {
                let e = min(o + fermat.m, lhs.count)
                dwa[i] = .init(lhs[o..<e])
                shiftReduce(&dwa[i], t, f: fermat)
                o += fermat.m; i += 1; t += fermat.theta
            }
            let w = fermat.theta << 1
            forward(&dwa, w, .zero, .zero, f: fermat)
            for i in .zero..<fermat.K {
                dwa[i].square()
                reduce(&dwa[i], f: fermat)
            }
            backward(&dwa, w, .zero, .zero, f: fermat)
            return finalise(&dwa, f: fermat)
        }
        
        public static func forward(_ lhs: inout [DoubleWords], _ w: Int, _ l: Int,  _ o: Int, f fermat: borrowing Fermat) {
            assert(lhs.count == fermat.K)
            let c = fermat.K >> l, ch = 1 << l
            if c == 2 { (lhs[o], lhs[o + ch]) = (addReduce(lhs[o], lhs[o + ch], f: fermat), subReduce(lhs[o], lhs[o + ch], f: fermat)) }
            else {
                let cs = c >> 1
                forward(&lhs, w << 1, l + 1, o, f: fermat)
                forward(&lhs, w << 1, l + 1, o + ch, f: fermat)
                for i in .zero ..< cs {
                    let io = o + i * ch * 2, br = bitReversal(i, cs)
                    var odd = lhs[io + ch]
                    shiftReduce(&odd, w * br, f: fermat)
                    (lhs[io], lhs[io + ch]) = (addReduce(lhs[io], odd, f: fermat), subReduce(lhs[io], odd, f: fermat))
                }
            }
        }
        
        public static func backward(_ lhs: inout [DoubleWords], _ w: Int, _ l: Int, _ o: Int, f fermat: borrowing Fermat) {
            assert(lhs.count == fermat.K)
            let c = fermat.K >> l
            if c == 2 { (lhs[o], lhs[o + 1]) = (addReduce(lhs[o], lhs[o + 1], f: fermat), subReduce(lhs[o], lhs[o + 1], f: fermat)) }
            else {
                let cs = c >> 1
                backward(&lhs, w << 1, l + 1, o, f: fermat)
                backward(&lhs, w << 1, l + 1, o + cs, f: fermat)
                for i in .zero ..< cs {
                    let io = i + o
                    var hi = lhs[io + cs]
                    shiftReduce(&hi, w * (c - i), f: fermat)
                    (lhs[io], lhs[io + cs]) = (addReduce(lhs[io], hi, f: fermat), subReduce(lhs[io], hi, f: fermat))
                }
            }
        }
        
        public static func reduce(_ lhs: inout DoubleWords, f fermat: borrowing Fermat) {
            let c = fermat.N.count - 1
            if lhs.count > c {
                var i0 = Int.zero, i1 = min(lhs.count, c)
                var pos: DoubleWords = .init(lhs[i0 ..< i1])
                var neg: DoubleWords = .zeroes(i1)
                var sub = true
                while i1 < lhs.count {
                    i0 = i1
                    i1 = min(lhs.count, i1 + c)
                    if sub { neg = addReduce(neg, .init(lhs[i0 ..< i1]), f: fermat) }
                    else { pos = addReduce(pos, .init(lhs[i0 ..< i1]), f: fermat) }
                    sub.toggle()
                }
                lhs = subReduce(pos, neg, f: fermat)
            }
        }
        
        public static func addReduce(_ lhs: DoubleWords, _ rhs: DoubleWords, f fermat: borrowing Fermat) -> DoubleWords {
            assert(lhs.compare(fermat.N) < .zero)
            assert(rhs.compare(fermat.N) < .zero)
            var lhs = lhs
            lhs.add(rhs)
            if lhs.compare(fermat.N) >= .zero { lhs.subtract(fermat.N) }
            lhs.normalise()
            return lhs
        }
        
        public static func subReduce(_ lhs: DoubleWords, _ rhs: DoubleWords, f fermat: borrowing Fermat) -> DoubleWords {
            assert(lhs.compare(fermat.N) < .zero)
            assert(rhs.compare(fermat.N) < .zero)
            var lhs = lhs
            if lhs.compare(rhs) < .zero { lhs.add(fermat.N) }
            lhs.subtract(rhs)
            lhs.normalise()
            return lhs
        }
        
        public static func shiftReduce(_ lhs: inout DoubleWords, _ i: Int, f fermat: borrowing Fermat) {
            assert(lhs.compare(fermat.N) < .zero)
            assert(i >= .zero)
            if i > .zero {
                let (q, r) = i.quotientAndRemainder(dividingBy: fermat.n)
                lhs.shiftLeft(r)
                reduce(&lhs, f: fermat)
                if q.andEquals(1) && !lhs.equalTo(.zero) { lhs.difference(fermat.N) }
                lhs.normalise()
            }
        }
        
        public static func bitReversal(_ lhs: Int, _ s: Int) -> Int {
            var rev = Int.zero
            let n = s.trailingZeroBitCount
            var m0 = 1, m1 = 1 << n
            for _ in .zero..<n {
                m1 >>= 1
                if lhs.and(m0, not: .zero) { rev |= m1 }
                m0 <<= 1
            }
            return rev
        }
        
        public static func finalise(_ lhs: inout [DoubleWords], f fermat: Fermat) -> DoubleWords {
            let ms = fermat.m << 1
            var r: DoubleWords = .zeroes(fermat.m * fermat.K)
            var f: DoubleWords = .zeroes(fermat.m * fermat.K)
            var hf = false
            var t = 2 * fermat.n - fermat.k
            var o = Int.zero
            for i in .zero..<fermat.K {
                shiftReduce(&lhs[i], t, f: fermat)
                t -= fermat.theta
                if lhs[i].count > ms + 1 || (lhs[i].count == ms + 1 && lhs[i][ms] > i) {
                    f.add(fermat.N, o)
                    hf = true
                }
                r.add(lhs[i], o)
                o += fermat.m
            }
            if hf { r.subtract(f) }
            return r
        }
    }
}
