//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/10/2023.
//

import Foundation

extension KernelNumerics.BigInt.ConstantValues {
    public typealias bz = BurnikelZiegler
    
    @_documentation(visibility: private)
    public enum BurnikelZiegler {
        public static let divLimit: Int = 60
    }
}

extension KernelNumerics.BigInt {
    public enum BurnikelZiegler {
        @_documentation(visibility: private)
        public typealias BigInt = KernelNumerics.BigInt
        
        public static func divMod(_ lhs: borrowing BigInt, _ v: BigInt) -> (q: BigInt, r: BigInt) {
            var A = lhs.abs, B = v.abs
            let s = B.count
            let m = 1 << (64 - (s / BigInt.val.bz.divLimit).leadingZeroBitCount)
            let j = (s + m - 1) / m, n = j * m, n64 = n << 6, sig = max(.zero, n64 - B.bitWidth)
            A <<= sig; B <<= sig
            let t = max(2, (A.bitWidth + n64) / n64)
            var Q = BigInt.zero, R = BigInt.zero
            var Z = blockA(A, n, t - 1) << n64 | blockA(A, n, t - 2)
            for i in (.zero...(t - 2)).reversed() {
                var qi: BigInt
                (qi, R) = div2N1N(Z, n, B)
                Q = Q << n64 | qi
                if i > .zero { Z = R << n64 | blockA(A, n, i - 1) }
            }
            return (Q, R >> sig)
        }
        
        public static func blockA(_ lhs: borrowing BigInt, _ n: Int, _ i: Int) -> BigInt {
            let mc = lhs.count
            assert(i * n <= mc)
            return if (i + 1) * n < mc { .init(.init(lhs.storage[i * n ..< (i + 1) * n])) }
            else { .init(.init(lhs.storage[i * n ..< mc])) }
        }
        
        public static func div2N1N(_ lhs: borrowing BigInt, _ n: Int, _ B: BigInt) -> (q: BigInt, r: BigInt) {
            if n.andEquals(1) || B.count < BigInt.val.bz.divLimit {
                let (q, r) = lhs.storage.divMod(B.storage)
                return (.init(q), .init(r))
            }
            let n2 = n >> 1, n32 = n << 5
            let (A123, A4) = split(lhs, n2)
            let (Q1, R1) = div3N2N(A123, n2, B)
            let (R11, R12) = split(R1, n)
            let (Q2, R) = div3N2N(((R11 << n32 | R12) << n32 | A4), n2, B)
            return (Q1 << n32 + Q2, R)
        }
        
        public static func div3N2N(_ lhs: borrowing BigInt, _ n: Int, _ B: BigInt) -> (q: BigInt, r: BigInt) {
            let n64 = n << 6
            let (B1, B2) = split(B, n), (A12, A3) = split(lhs, n), (A1, _) = split(A12, n)
            var Q: BigInt, R1: BigInt
            if A1 < B1 { (Q, R1) = div2N1N(A12, n, B1) }
            else {
                R1 = A12 - (B1 << n64) + B1
                Q = .one << n64 - .one
            }
            let D = Q * B2
            var R = R1 << n64 | A3
            while R < D { R += B; Q -= .one }
            return (Q, R - D)
        }
        
        public static func split(_ lhs: BigInt, _ n: Int) -> (BigInt, BigInt) {
            let mc = lhs.count
            return if mc > n { (.init(.init(lhs.storage[n..<mc])), .init(.init(lhs.storage[.zero..<n]))) }
            else { (.zero, lhs) }
        }
    }
    
    
}
