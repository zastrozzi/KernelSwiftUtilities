//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/10/2023.
//

import Foundation

extension KernelNumerics.BigInt.ConstantValues {
    public typealias symbol = Symbol
    
    @_documentation(visibility: private)
    public enum Symbol {
        
    }
}

extension KernelNumerics.BigInt.DoubleWords {
    @_documentation(visibility: private)
    public typealias Symbol = BigInt.Symbol
}

extension KernelNumerics.BigInt {
    public enum Symbol {
        @_documentation(visibility: private)
        public typealias BigInt = KernelNumerics.BigInt
        @_documentation(visibility: private)
        public typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
        @_documentation(visibility: private)
        public typealias val = KernelNumerics.BigInt.ConstantValues.Symbol
        
        public static func jacobi(_ s: borrowing BigInt, _ m: BigInt) -> Int {
            precondition(m.isPositive && m.isOdd)
            var m1 = m, a = s.mod(m1), t = 1
            while a.isNotZero {
                while a.isEven {
                    a >>= 1
                    let x = m1.storage[.zero] & 7
                    if x == 3 || x == 5 { t = -t }
                }
                let x = a
                a = m1
                m1 = x
                if a.storage[.zero].andEquals(3) && m1.storage[.zero].andEquals(3) { t = -t }
                a = a.mod(m1)
            }
            return m1.isOne ? t : .zero
        }
        
        public static func jacobi(_ s: borrowing BigInt, _ m: Int) -> Int {
            precondition(m > .zero && m.andEquals(1))
            var m1 = m, a = s.mod(m1), t = 1
            while a != .zero {
                while a.and(1, equals: .zero) {
                    a >>= 1
                    let x = m1 & 7
                    if x == 3 || x == 5 { t = -t }
                }
                let x = a
                a = m1
                m1 = x
                if a.andEquals(3) && m1.andEquals(3) { t = -t }
                a %= m1
            }
            return m1 == 1 ? t : .zero
        }
        
        public static func kronecker(_ s: borrowing BigInt, _ m: BigInt) -> Int {
            if m.isPositive {
                if m.isOdd { return jacobi(s, m) }
                else {
                    if s.isEven { return .zero }
                    else {
                        let r = s.storage[.zero] & 7
                        return r == 1 || r == 7 ? kronecker(s, m >> 1) : -kronecker(s, m >> 1)
                    }
                }
            } 
            else if m.isNegative { return s.isNegative ? -kronecker(s, -m) : kronecker(s, -m) }
            else { return s.abs.isOne ? 1 : .zero }
        }

        public static func kronecker(_ s: borrowing BigInt, _ m: Int) -> Int {
            if m > .zero {
                if m.andEquals(1) { return jacobi(s, m) }
                else {
                    if s.isEven { return .zero }
                    else {
                        let r = s.storage[.zero] & 7
                        return r == 1 || r == 7 ? kronecker(s, m >> 1) : -kronecker(s, m >> 1)
                    }
                }
            }
            else if m < .zero { return s.isNegative ? -kronecker(s, -m) : kronecker(s, -m) }
            else { return s.abs.isOne ? 1 : .zero }
        }
    }
}
