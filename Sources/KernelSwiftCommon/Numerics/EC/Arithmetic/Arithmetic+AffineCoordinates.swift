//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/09/2023.
//

import Foundation

extension KernelNumerics.EC.Arithmetic {
    public enum Affine {
        // [CP:PrimeNumbers] Algorithm 7.2.2 (Elliptic arithmetic: Affine coordinates)
        public static func negate(
            _ point: KernelNumerics.EC.Point,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.EC.Point {
            point.isInfinite ? .infinity : .init(x: point.x, y: d.p - point.y)
        }
        
        // [CP:PrimeNumbers] Algorithm 7.2.2 (Elliptic arithmetic: Affine coordinates)
        public static func double(
            _ point: KernelNumerics.EC.Point,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.EC.Point {
            guard !point.y.isZero else { return .infinity }
            let m = Barrett.multiplyMod(
                Barrett.addMod(Barrett.multiplyCubicMod(Barrett.squareMod(point.x, d: d), d: d), d.a, d: d),
                Montgomery.inverse(Barrett.multiplySquareMod(point.y, d: d), d: d),
                d: d
            )
            let xCubic = Barrett.subtractMod(Barrett.squareMod(m, d: d), Barrett.multiplySquareMod(point.x, d: d), d: d)
            return .init(
                x: xCubic,
                y: Barrett.subtractMod(Barrett.multiplyMod(m, Barrett.subtractMod(point.x, xCubic, d: d), d: d), point.y, d: d)
            )
        }
        
        // [CP:PrimeNumbers] Algorithm 7.2.2 (Elliptic arithmetic: Affine coordinates)
        public static func add(
            _ p1: KernelNumerics.EC.Point,
            _ p2: KernelNumerics.EC.Point,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.EC.Point {
            if p1.isInfinite { return p2 }
            if p2.isInfinite { return p1 }
            var m: KernelNumerics.BigInt
            if p1.x == p2.x {
                if Barrett.addMod(p1.y, p2.y, d: d).isZero { return .infinity }
                m = Barrett.multiplyMod(
                    Barrett.addMod(Barrett.multiplyCubicMod(Barrett.squareMod(p1.x, d: d), d: d), d.a, d: d),
                    Montgomery.inverse(Barrett.multiplySquareMod(p1.y, d: d), d: d),
                    d: d
                )
            } else {
                m = Barrett.multiplyMod(
                    Barrett.subtractMod(p2.y, p1.y, d: d),
                    Montgomery.inverse(Barrett.subtractMod(p2.x, p1.x, d: d), d: d),
                    d: d
                )
            }
            let xCubic = Barrett.subtractMod(Barrett.squareMod(m, d: d), Barrett.addMod(p1.x, p2.x, d: d), d: d)
            return .init(
                x: xCubic,
                y: Barrett.subtractMod(Barrett.multiplyMod(m, Barrett.subtractMod(p1.x, xCubic, d: d), d: d), p1.y, d: d)
            )
        }
        
        // [CP:PrimeNumbers] Algorithm 7.2.2 (Elliptic arithmetic: Affine coordinates)
        public static func subtract(
            _ p1: KernelNumerics.EC.Point,
            _ p2: KernelNumerics.EC.Point,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.EC.Point {
            return add(p1, negate(p2, d: d), d: d)
        }
        
        // [CP:PrimeNumbers] Algorithm 7.2.4 (Elliptic multiplication: Addition-subtraction ladder)
        public static func multiply(
            _ p: KernelNumerics.EC.Point,
            _ n: KernelNumerics.BigInt,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.EC.Point {
            assert(0 <= n && n < d.order)
            if n.isZero { return .infinity }
            if n.isOne { return p }
            var q = p
            let np = negate(p, d: d)
            let m = n * 3
            for i in (1...(m.bitWidth - 2)).reversed() {
                q = double(q, d: d)
                let mi = m.testBit(i)
                let ni = n.testBit(i)
                if mi && !ni { q = add(q, p, d: d) }
                else if !mi && ni { q = add(q, np, d: d) }
            }
            return q
        }
    }
}
