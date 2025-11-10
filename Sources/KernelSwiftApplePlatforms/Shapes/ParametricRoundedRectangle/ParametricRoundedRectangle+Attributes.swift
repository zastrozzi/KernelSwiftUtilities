//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/11/2025.
//

import Foundation

extension ParametricRoundedRectangle {
    public struct Attributes {
        public var topRight: CornerAttributes
        public var bottomRight: CornerAttributes
        public var bottomLeft: CornerAttributes
        public var topLeft: CornerAttributes
        
        public init(
            topRight: CornerAttributes,
            bottomRight: CornerAttributes,
            bottomLeft: CornerAttributes,
            topLeft: CornerAttributes
        ) {
            self.topRight = topRight
            self.bottomRight = bottomRight
            self.bottomLeft = bottomLeft
            self.topLeft = topLeft
        }
    }
}
