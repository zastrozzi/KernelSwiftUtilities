//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/11/2025.
//

import Foundation

extension ParametricRoundedRectangle {
    public struct CornerParameters {
        public let a: CGFloat
        public let b: CGFloat
        public let c: CGFloat
        public let d: CGFloat
        public let p: CGFloat
        public let r: CGFloat
        
        public let theta: CGFloat
        
        public func unpack() -> (CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat) {
            (a, b, c, d, p, r, theta)
        }
    }
}
