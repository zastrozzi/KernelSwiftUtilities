//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/09/2023.
//

import Foundation

extension KernelNumerics.EC.Arithmetic {
    public enum Barrett {
        // [HMV:GuideECC] Algorithm 2.14 (Barrett reduction)
        public static func reduceMod(
            _ x: KernelNumerics.BigInt,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.BigInt {
            assert(0 <= x && x < (d.p ** 2))
            let t = x - ((x * d.mu) >> d.shifts) * d.p
            return t < d.p ? t : t - d.p
        }
        
        public static func addMod(
            _ x: KernelNumerics.BigInt,
            _ y: KernelNumerics.BigInt,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.BigInt {
            assert(0 <= x && x < d.p)
            assert(0 <= y && y < d.p)
            let t = x + y
            return t < d.p ? t : t - d.p
        }
        
        public static func subtractMod(
            _ x: KernelNumerics.BigInt,
            _ y: KernelNumerics.BigInt,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.BigInt {
            assert(0 <= x && x < d.p)
            assert(0 <= y && y < d.p)
            let r = x - y
            return r.isNegative ? r + d.p : r
        }
        
        public static func multiplyMod(
            _ x: KernelNumerics.BigInt,
            _ y: KernelNumerics.BigInt,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.BigInt {
            assert(0 <= x && x < d.p)
            assert(0 <= y && y < d.p)
            return reduceMod(x * y, d: d)
        }
        
        public static func multiplySquareMod(
            _ x: KernelNumerics.BigInt,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.BigInt {
            assert(0 <= x && x < d.p)
            let t = x << 1
            return t < d.p ? t : t - d.p
        }
        
        public static func multiplyCubicMod(
            _ x: KernelNumerics.BigInt,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.BigInt {
            assert(0 <= x && x < d.p)
            return reduceMod(x << 1 + x, d: d)
        }
        
        public static func squareMod(
            _ x: KernelNumerics.BigInt,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.BigInt {
            assert(.zero <= x && x < d.p)
            return reduceMod(x * x, d: d)
        }
    }
}
