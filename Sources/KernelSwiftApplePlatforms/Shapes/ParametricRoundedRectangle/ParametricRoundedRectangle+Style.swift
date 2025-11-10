//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/11/2025.
//

import Foundation
import KernelSwiftCommon

extension ParametricRoundedRectangle {
    public enum Style {
        case circular
        case continuous
        case smooth(_ factor: Double)
        
        public static var smooth: Self { .smooth(1) }
        
        public var value: CGFloat {
            switch self {
            case .circular: 0
            case .continuous: 0.7
            case let .smooth(factor):
                factor.clamped(to: 0...1)
            }
        }
    }
}
