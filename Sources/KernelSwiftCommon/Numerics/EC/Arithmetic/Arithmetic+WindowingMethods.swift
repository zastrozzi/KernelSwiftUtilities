//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/09/2023.
//

import Foundation

extension KernelNumerics.EC.Arithmetic {
    public enum Windowing {
        // [HMV:GuideECC] Algorithm 3.41 (Fixed-base windowing method for point multiplication)
        public static func multiply(
            _ n: KernelNumerics.BigInt,
            points: borrowing [KernelNumerics.EC.Point],
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.EC.Point {
            var a: KernelNumerics.EC.Point = .infinity
            var b: KernelNumerics.EC.Point = .infinity
            for i0 in (1..<KernelNumerics.EC.Domain.windowWidthExp).reversed() {
                var mx = 0
                var mi = 0
                for i1 in 0..<points.count {
                    if (n.storage[mx] >> mi) & KernelNumerics.EC.Domain.windowWidthMask == i0 {
                        b = Affine.add(b, points[i1], d: d)
                    }
                    mi += KernelNumerics.EC.Domain.windowWidth
                    if mi == 0x40 {
                        mi = .zero
                        mx += 1
                        if mx == n.count { break }
                    }
                }
                a = Affine.add(a, b, d: d)
            }
            return a
        }
        
        public static func multiplyGen(
            _ n: KernelNumerics.BigInt,
            d: borrowing KernelNumerics.EC.Domain
        ) -> KernelNumerics.EC.Point {
            return multiply(n, points: d.genPoints, d: d)
        }
        
        public static func compute(
            _ w: KernelNumerics.EC.Point,
            d: borrowing KernelNumerics.EC.Domain
        ) -> [KernelNumerics.EC.Point] {
            let windowWidth = KernelNumerics.EC.Domain.windowWidth
            let count = (d.order.bitWidth + windowWidth - 1) / windowWidth
            //        print("COUNT", count)
            var windowPoints: [KernelNumerics.EC.Point] = .init(repeating: .infinity, count: count)
            windowPoints[.zero] = w
            for i in 1..<count {
                windowPoints[i] = windowPoints[i - 1]
                for _ in .zero ..< windowWidth { windowPoints[i] = Affine.double(windowPoints[i], d: d) }
            }
            return windowPoints
        }
    }
}
