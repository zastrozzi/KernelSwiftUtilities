//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/10/2023.
//

import Foundation

extension KernelNumerics.BigInt.ConstantValues {
    public typealias karatsuba = Karatsuba
    
    @_documentation(visibility: private)
    public enum Karatsuba {
        public static let threshold: Int = 100
    }
}

extension KernelNumerics.BigInt.DoubleWords {
    @_documentation(visibility: private)
    public typealias Karatsuba = BigInt.Karatsuba
}

extension KernelNumerics.BigInt {
    public enum Karatsuba {
        @_documentation(visibility: private)
        public typealias BigInt = KernelNumerics.BigInt
        @_documentation(visibility: private)
        public typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
        @_documentation(visibility: private)
        public typealias val = KernelNumerics.BigInt.ConstantValues.Karatsuba
        
        public static func multiply(_ lhs: borrowing DoubleWords, _ rhs: DoubleWords) -> DoubleWords {
            let i = (max(lhs.count, rhs.count) + 1) >> 1, lhsLo = sliceLo(lhs, i), rhsLo = sliceLo(rhs, i)
            var lhsHi = sliceHi(lhs, i), rhsHi = sliceHi(rhs, i), p0 = rhsHi, p1 = rhsLo
            p0.multiply(lhsHi); p1.multiply(lhsLo)
            lhsHi.add(lhsLo); rhsHi.add(rhsLo)
            var p2 = rhsHi
            p2.multiply(lhsHi)
            p2.subtract(p0); p2.subtract(p1)
            var dw: DoubleWords = .zeroes(i << 2)
            dw.add(p0, i << 1); dw.add(p2, i); dw.add(p1)
            return dw
        }
        
        public static func square(_ lhs: borrowing DoubleWords) -> DoubleWords {
            let i = (lhs.count + 1) >> 1
            let lhsLo = sliceLo(lhs, i), lhsHi = sliceHi(lhs, i), lhsLoSq = lhsLo.squared(), lhsHiSq = lhsHi.squared()
            var p: DoubleWords = lhsHi.compare(lhsLo) > .zero ? lhsHi.subtracting(lhsLo) : lhsLo.subtracting(lhsHi)
            p.square()
            var dw: DoubleWords = .zeroes(i << 2)
            dw.add(lhsHiSq, i << 1); dw.add(lhsHiSq, i); dw.add(lhsLoSq, i)
            dw.subtract(p, i)
            dw.add(lhsLoSq)
            return dw
        }
        
        public static func sliceLo(_ lhs: borrowing DoubleWords, _ i: Int) -> DoubleWords {
            i < lhs.count ? .init(lhs[.zero..<i]) : lhs.copy()
        }
        
        public static func sliceHi(_ lhs: borrowing DoubleWords, _ i: Int) -> DoubleWords {
            i < lhs.count ? .init(lhs[i..<lhs.count]) : .zeroes(1)
        }
    }
}
