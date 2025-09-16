//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/10/2023.
//

import Foundation

extension KernelNumerics.BigInt.ConstantValues {
    public typealias toomCook = ToomCook
    
    @_documentation(visibility: private)
    public enum ToomCook {
        public static let threshold         : Int = 200
        public static let inversePositive3  : UInt64 = 0xaaaaaaaaaaaaaaab
        public static let inverseNegative3  : UInt64 = 0x5555555555555556
    }
}

extension KernelNumerics.BigInt.DoubleWords {
    @_documentation(visibility: private)
    public typealias ToomCook = BigInt.ToomCook
}

extension KernelNumerics.BigInt {
    public enum ToomCook {
        @_documentation(visibility: private)
        public typealias BigInt = KernelNumerics.BigInt
        @_documentation(visibility: private)
        public typealias DoubleWord = KernelNumerics.BigInt.DoubleWord
        @_documentation(visibility: private)
        public typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
        @_documentation(visibility: private)
        public typealias val = KernelNumerics.BigInt.ConstantValues.ToomCook
        
        public static func multiply(_ lhs: borrowing DoubleWords, _ rhs: DoubleWords) -> DoubleWords {
            let i = (max(lhs.count, rhs.count) + 2) / 3
            let lhs0 = slice0(lhs, i), lhs1 = slice1(lhs, i), lhs2 = slice2(lhs, i)
            let rhs0 = slice0(rhs, i), rhs1 = slice1(rhs, i), rhs2 = slice2(rhs, i)
            let p0 = rhs0 + rhs2, p1 = p0 + rhs1, pm0 = p0 - rhs1, pm1 = ((pm0 + rhs2) << 1) - rhs0
            let q0 = lhs0 + lhs2, q1 = q0 + lhs1, qm0 = q0 - lhs1, qm1 = ((qm0 + lhs2) << 1) - lhs0
            let r0 = rhs0 * lhs0, r1 = p1 * q1, rm0 = pm0 * qm0, rm1 = pm1 * qm1, r2 = rhs2 * lhs2
            var rr2 = div3(rm1 - r1), rr0 = (r1 - rm0) >> 1, rr1 = rm0 - r0
            
            rr2 = (rr1 - rr2) >> 1 + (r2 << 1)
            rr1 += rr0
            rr1 -= r2
            rr0 -= rr2
            
            var r: DoubleWords = .zeroes(i * 6), o = i << 2
            r.add(r2.storage, o)
            o -= i
            r.add(rr2.storage, o)
            o -= i
            r.add(rr1.storage, o); r.add(rr0.storage, i); r.add(r0.storage)
            return r
        }
        
        public static func square(_ lhs: borrowing DoubleWords) -> DoubleWords {
            let i = (lhs.count + 2) / 3
            let lhs0 = slice0(lhs, i), lhs1 = slice1(lhs, i), lhs2 = slice2(lhs, i), v0 = lhs0 ** 2
            var da1 = lhs2 + lhs0
            let vm1 = (da1 - lhs1) ** 2
            da1 += lhs1
            let v1 = da1 ** 2, v3 = lhs2 ** 2, v2 = (((da1 + lhs2) << 1) - lhs0) ** 2
            var t0 = v1 - v0, t1 = div3(v2 - vm1), tm = (v1 - vm1) >> 1
            t1 = (t1 - t0) >> 1
            t0 = t0 - tm - v3
            t1 = t1 - (v3 << 1)
            tm -= t1
            
            var r: DoubleWords = .zeroes(i * 6), o = i << 2
            r.add(v3.storage, o)
            o -= i
            r.add(t1.storage, o)
            o -= i
            r.add(t0.storage, o); r.add(tm.storage, i); r.add(v0.storage)
            return r
        }
        
        public static func div3(_ lhs: borrowing BigInt) -> BigInt {
            var q: DoubleWords = .zeroes(lhs.count), r = DoubleWord.zero
            for i in .zero..<q.count {
                let li = lhs.storage[i], x = r > li ? r - li : li - r
                let y = x &* val.inversePositive3
                q[i] = y
                r = switch y {
                case ..<val.inverseNegative3: .zero
                case ..<val.inversePositive3: 1
                default: 2
                }
            }
            return .init(q, lhs.sign)
        }
        
        public static func slice0(_ lhs: borrowing DoubleWords, _ i: Int) -> BigInt {
            .init(i < lhs.count ? .init(lhs[.zero..<i]) : lhs.copy())
        }
        
        public static func slice1(_ lhs: borrowing DoubleWords, _ i: Int) -> BigInt {
            .init(i < lhs.count ? (i * 2 < lhs.count ? .init(lhs[i..<(i * 2)]) : .init(lhs[i..<lhs.count])) : .zeroes(1))
        }
        public static func slice2(_ lhs: borrowing DoubleWords, _ i: Int) -> BigInt {
            .init(i * 2 < lhs.count ? .init(lhs[(i * 2)..<lhs.count]) : .zeroes(1))
        }
    }
}
