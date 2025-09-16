//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/09/2023.
//

import Foundation

extension KernelNumerics.EC {
    public struct Point: Equatable, Sendable, Hashable {
        ///Since all possible Points may be represented in Cartesian plane quadrant 1, coordinates X & Y may be represented as BigInt.
        ///
        public static let infinity = Point()
        
        public let x: KernelNumerics.BigInt
        public let y: KernelNumerics.BigInt
        
        private init() {
            x = .zero
            y = .zero
        }
        
        public init(x: KernelNumerics.BigInt, y: KernelNumerics.BigInt) {
            self.x = x
            self.y = y
        }
        
        
        public var isInfinite: Bool {
            x == .zero && y == .zero
        }
        
        public static func == (p0: Point, p1: Point) -> Bool {
            return p0.x == p1.x && p0.y == p1.y
        }
    }
}
