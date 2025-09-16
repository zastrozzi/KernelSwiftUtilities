//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

extension KernelSwiftTerminal.Layout {
    public struct Position: Equatable {
        public var column: Int
        public var line: Int
        
        public static var zero: Self = .init(column: .zero, line: .zero)
    }
}

extension KernelSwiftTerminal.Layout.Position: CustomStringConvertible {
    public var description: String { "(\(column), \(line))" }
}

extension KernelSwiftTerminal.Layout.Position: AdditiveArithmetic {
    public static func +(lhs: Self, rhs: Self) -> Self {
        .init(column: lhs.column + rhs.column, line: lhs.line + rhs.line)
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        .init(column: lhs.column - rhs.column, line: lhs.line - rhs.line)
    }
}
