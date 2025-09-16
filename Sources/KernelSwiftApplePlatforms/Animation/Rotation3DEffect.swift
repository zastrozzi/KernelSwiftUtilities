//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 16/01/2025.
//

import SwiftUI

public struct Rotation3DEffect {
    public var angle: Angle
    public var axis: (x: CGFloat, y: CGFloat, z: CGFloat)
    public var anchor: UnitPoint
    public var anchorZ: CGFloat
    public var perspective: CGFloat
    
    public init(
        angle: Angle,
        axis: (x: CGFloat, y: CGFloat, z: CGFloat),
        anchor: UnitPoint = .center,
        anchorZ: CGFloat = 0,
        perspective: CGFloat = 1
    ) {
        self.angle = angle
        self.axis = axis
        self.anchor = anchor
        self.anchorZ = anchorZ
        self.perspective = perspective
    }
}

extension View {
    @inlinable nonisolated public func rotation3DEffect(
        _ effect: Rotation3DEffect
    ) -> some View {
        rotation3DEffect(
            effect.angle,
            axis: effect.axis,
            anchor: effect.anchor,
            anchorZ: effect.anchorZ,
            perspective: effect.perspective
        )
    }
}
