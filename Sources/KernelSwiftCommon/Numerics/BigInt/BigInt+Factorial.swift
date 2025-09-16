//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/10/2023.
//

import Foundation

extension KernelNumerics.BigInt.ConstantValues {
    public typealias factorial = Factorial
    
    @_documentation(visibility: private)
    public enum Factorial {
        public static let small: [Int] = [
            f0, f1, f2, f3, f4, f5, f6,
            f7, f8, f9, f10, f11, f12, f13,
            f14, f15, f16, f17, f18, f19, f20
        ]
        
        public static let f0    : Int = 0x0000000000000001
        public static let f1    : Int = 0x0000000000000001
        public static let f2    : Int = 0x0000000000000002
        public static let f3    : Int = 0x0000000000000006
        public static let f4    : Int = 0x0000000000000018
        public static let f5    : Int = 0x0000000000000078
        public static let f6    : Int = 0x00000000000002d0
        public static let f7    : Int = 0x00000000000013b0
        public static let f8    : Int = 0x0000000000009d80
        public static let f9    : Int = 0x0000000000058980
        public static let f10   : Int = 0x0000000000375f00
        public static let f11   : Int = 0x0000000002611500
        public static let f12   : Int = 0x000000001c8cfc00
        public static let f13   : Int = 0x000000017328cc00
        public static let f14   : Int = 0x000000144c3b2800
        public static let f15   : Int = 0x0000013077775800
        public static let f16   : Int = 0x0000130777758000
        public static let f17   : Int = 0x0001437eeecd8000
        public static let f18   : Int = 0x0016beecca730000
        public static let f19   : Int = 0x01b02b9306890000
        public static let f20   : Int = 0x21c3677c82b40000
        
    }
}

extension KernelNumerics.BigInt {
    public static func factorial(_ n: Int) -> Self {
        precondition(n >= .zero, "cannot produce negative factorial")
        return Factorial(n).res
    }
}

extension KernelNumerics.BigInt {
    public class Factorial {
        @_documentation(visibility: private)
        public typealias BigInt = KernelNumerics.BigInt
        @_documentation(visibility: private)
        public typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
        @_documentation(visibility: private)
        public typealias DoubleWord = KernelNumerics.BigInt.DoubleWord
        @_documentation(visibility: private)
        public typealias val = KernelNumerics.BigInt.ConstantValues.Factorial
        
        private var storage: DoubleWords = .fill(1, with: 1)
        public var res = BigInt.zero
        
        public init(_ n: Int) {
            res = n < val.small.count ? .init(val.small[n]) : compute(n)
        }
        
        func compute(_ n: Int) -> BigInt {
            var p: DoubleWords = .fill(1, with: 1), r: DoubleWords = .fill(1, with: 1), h = Int.zero, sq = Int.zero, hi = 1
            var width = 63 - n.leadingZeroBitCount
            while h != n {
                sq += h
                h = n >> width
                width -= 1
                var len = hi
                hi = (h - 1) | 1
                len = (hi - len) >> 1
                if len > .zero {
                    p.multiply(product(len))
                    r.multiply(p)
                }
            }
            return .init(r.shiftedLeft(sq))
        }
        
        func product(_ n: Int) -> DoubleWords {
            let m = n >> 1
            if m == .zero {
                storage.add(2)
                return storage
            } else if n == 2 {
                storage.add(2)
                var x = storage
                storage.add(2)
                x.multiply(storage)
                return x
            } else {
                var p1 = product(n - m)
                p1.multiply(product(m))
                return p1
            }
        }
    }
}
