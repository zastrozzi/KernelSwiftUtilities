//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/11/2025.
//

import Foundation

extension ParametricRoundedRectangle {
    public struct Corners: OptionSet, Sendable {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let topLeading = Corners(rawValue: 1 << 0)
        public static let topTrailing = Corners(rawValue: 1 << 1)
        public static let bottomLeading = Corners(rawValue: 1 << 2)
        public static let bottomTrailing = Corners(rawValue: 1 << 3)
        
        public static let all: Corners = [.topLeading, .topTrailing, .bottomLeading, .bottomTrailing]
        public static let top: Corners = [.topLeading, .topTrailing]
        public static let bottom: Corners = [.bottomLeading, .bottomTrailing]
        public static let leading: Corners = [.topLeading, .bottomLeading]
        public static let trailing: Corners = [.topTrailing, .bottomTrailing]
    }
}
