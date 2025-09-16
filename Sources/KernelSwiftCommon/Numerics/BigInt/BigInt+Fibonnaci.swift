//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/10/2023.
//

import Foundation

extension KernelNumerics.BigInt.DoubleWords {
    @_documentation(visibility: private)
    public typealias Fibonnaci = BigInt.Fibonnaci
}

extension KernelNumerics.BigInt {
    public enum Fibonnaci {
        @_documentation(visibility: private)
        public typealias BigInt = KernelNumerics.BigInt
        @_documentation(visibility: private)
        public typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
        @_documentation(visibility: private)
        public typealias DoubleWord = KernelNumerics.BigInt.DoubleWord
        
        public static func single(_ n: Int) -> BigInt { pair(n).first }
        
        public static func pair(_ n: Int) -> (first: BigInt, second: BigInt) {
            precondition(n >= .zero)
            var a: DoubleWords = .fill(1, with: 0), b: DoubleWords = .fill(1, with: 1)
            var bit = 1 << (63 - n.leadingZeroBitCount)
            while bit > .zero {
                var d = b.shiftedLeftOne()
                d.subtract(a)
                d.multiply(a)
                var e = a.squared()
                let b2 = b.squared()
                e.add(b2); a = d; b = e
                if n.and(bit, not: .zero) {
                    var c = a
                    c.add(b); a = b; b = c
                }
                bit >>= 1
            }
            return (.init(a), .init(b))
        }
        
        public static func lucasSingle(_ n: Int) -> BigInt {
            let pair = pair(n)
            return 2 * pair.second - pair.first
        }
        
        public static func lucasPair(_ n: Int) -> (first: BigInt, second: BigInt) {
            let pair = pair(n)
            return (2 * pair.second - pair.first, pair.second + 2 * pair.first)
        }
    }
}
