//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

extension KernelSwiftTerminal.Layout {
    public struct Rect: Equatable {
        public var position: Position
        public var size: Size
        
        public init(position: Position, size: Size) {
            self.position = position
            self.size = size
        }
        
        public init(minColumn: Int, minLine: Int, maxColumn: Int, maxLine: Int) {
            self.position = .init(column: minColumn, line: minLine)
            self.size = .init(width: maxColumn - minColumn + 1, height: maxLine - minLine + 1)
        }
        
        public init(column: Int, line: Int, width: Int, height: Int) {
            self.position = .init(column: column, line: line)
            self.size = .init(width: width, height: height)
        }
        
        public static var zero: Self = .init(position: .zero, size: .zero)
        
        public var minLine: Int { position.line }
        public var minColumn: Int { position.column }
        public var maxLine: Int { position.line + size.height - 1 }
        public var maxColumn: Int { position.column + size.width - 1 }
        
        /// The smallest rectangle that contains the two source rectangles.
        public func union(_ r2: Self) -> Self {
            Rect(minColumn: min(minColumn, r2.minColumn),
                 minLine: min(minLine, r2.minLine),
                 maxColumn: max(maxColumn, r2.maxColumn),
                 maxLine: max(maxLine, r2.maxLine))
        }
        
        public func contains(_ position: Position) -> Bool {
            position.column >= minColumn &&
            position.line >= minLine &&
            position.column <= maxColumn &&
            position.line <= maxLine
        }
    }
}

extension KernelSwiftTerminal.Layout.Rect: CustomStringConvertible {
    public var description: String { "\(position) \(size)" }
}
