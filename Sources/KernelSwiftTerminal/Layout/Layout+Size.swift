//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

extension KernelSwiftTerminal.Layout {
    public struct Size: Equatable, CustomStringConvertible {
        public var width: Int
        public var height: Int
        
        public init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
        
        public static var zero: Self = .init(width: .zero, height: .zero)
        
        public var description: String { "\(width)x\(height)" }
    }
}
