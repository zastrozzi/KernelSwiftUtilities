//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/10/2023.
//

import Foundation

extension KernelNumerics.BigInt.DoubleWords {
    @_documentation(visibility: private)
    public typealias Granlund = BigInt.Granlund
}

extension KernelNumerics.BigInt {
    public enum Granlund {
        @_documentation(visibility: private)
        public typealias BigInt = KernelNumerics.BigInt
        @_documentation(visibility: private)
        public typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
        @_documentation(visibility: private)
        public typealias DoubleWord = KernelNumerics.BigInt.DoubleWord
        
        public static func divTwoDoubleWord(
            _ lhsHi: DoubleWord,
            _ lhsLo: DoubleWord,
            _ rhs: DoubleWord,
            _ rcp: DoubleWord
        ) -> (q: DoubleWord, r: DoubleWord) {
            assert(lhsHi < rhs)
            assert(rhs >= .mask.bit.little.b63)
            var o = false, (q1, q0) = rcp.multipliedFullWidth(by: lhsHi)
            (q0, o) = q0.addingReportingOverflow(lhsLo)
            (q1, _) = q1.addingReportingOverflow(lhsHi)
            if o { q1 &+= 1 }
            q1 &+= 1
            var r = lhsLo &- q1 &* rhs
            if r > q0 { q1 &-= 1; r &+= rhs }
            if r >= rhs { q1 += 1; r -= rhs }
            return (q1, r)
        }
    }
}
