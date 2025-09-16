//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/09/2023.
//

import Foundation

extension KernelNumerics.EC.Arithmetic {
    public enum Montgomery {
        // [HMV:GuideECC] Algorithm 2.23 (Partial Montgomery inversion Fp)
        public static func inverse(
            _ x: KernelNumerics.BigInt,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.BigInt {
            let vp: KernelNumerics.EC.Vector = .init(d.p)
            var u: KernelNumerics.EC.Vector = .init(x)
            var v = vp
            var x1: KernelNumerics.EC.Vector = .one
            var x2: KernelNumerics.EC.Vector = .zero
            var k = 0
            while v.isPositive {
                if v.isEven {
                    v.shiftRightOne()
                    x1.shiftLeftOne()
                }
                else if u.isEven {
                    u.shiftRightOne()
                    x2.shiftLeftOne()
                }
                else if v.compare(u) >= .zero {
                    v.subtract(u)
                    v.shiftRightOne()
                    x2.add(x1)
                    x1.shiftLeftOne()
                }
                else {
                    u.subtract(v)
                    u.shiftRightOne()
                    x1.add(x2)
                    x2.shiftLeftOne()
                }
                k += 1
            }
            precondition(u.isOne)
            if x1.compare(vp) > .zero { x1.subtract(vp) }
            
            if k > d.radixSize64Bit {
                Warren.reduce(&x1, d: d)
                k -= d.radixSize64Bit
            }
            x1.shiftLeft(d.radixSize64Bit - k)
            Warren.reduce(&x1, d: d)
            return .init(x1.storage)
        }
        
        // [CP:PrimeNumbers] Algorithm 7.2.7 (Elliptic multiplication: Montgomery method)
        public static func multiply(
            _ p: KernelNumerics.EC.Point,
            _ n: KernelNumerics.BigInt,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.EC.Point {
            assert(0 <= n && n < d.order)
            var p1: KernelNumerics.EC.Point = .infinity
            var p2 = p
            
            for i in (.zero ..< n.bitWidth).reversed() {
                if n.testBit(i) {
                    p1 = Affine.add(p1, p2, d: d)
                    p2 = Affine.double(p2, d: d)
                } else {
                    p2 = Affine.add(p1, p2, d: d)
                    p1 = Affine.double(p1, d: d)
                }
            }
            return p1
        }
    }
    
    
}
