//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/11/2025.
//

import Foundation
import SwiftUI

extension DynamicLaunchScene {
    public struct Configuration {
        public var launchScreenType: LaunchScreenType
        public var initialDelay: Double
        public var backgroundColor: Color
        public var contentBackgroundColor: Color
        public var scaling: CGFloat
        public var blurRadius: CGFloat
        public var forceHideContent: Bool
        public var animation: Animation
        public var launchWindowTag: Int
        
        public init(
            launchScreenType: LaunchScreenType = .scaling,
            initialDelay: Double = 0.35,
            backgroundColor: Color = .black,
            contentBackgroundColor: Color = .white,
            scaling: CGFloat = 4,
            blurRadius: CGFloat = 15,
            forceHideContent: Bool = true,
            animation: Animation = .smooth(duration: 1, extraBounce: 0),
            launchWindowTag: Int = 2000
        ) {
            self.launchScreenType = launchScreenType
            self.initialDelay = initialDelay
            self.backgroundColor = backgroundColor
            self.contentBackgroundColor = contentBackgroundColor
            self.scaling = scaling
            self.blurRadius = blurRadius
            self.forceHideContent = forceHideContent
            self.animation = animation
            self.launchWindowTag = launchWindowTag
        }
    }
}
