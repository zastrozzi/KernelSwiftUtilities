//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/11/2025.
//

import Foundation

extension ParametricRoundedRectangle {
    public struct CornerAttributes: Sendable {
        public var radius: CGFloat
        public var smoothness: CGFloat
        public var segmentLength: CGFloat
        
        public init(
            radius: CGFloat,
            smoothness: CGFloat = 0
        ) {
            self.radius = radius
            self.smoothness = smoothness
            self.segmentLength = radius * (1 + smoothness)
        }
    }
}
