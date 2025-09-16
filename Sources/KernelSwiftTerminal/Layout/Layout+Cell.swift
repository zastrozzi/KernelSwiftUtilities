//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

extension KernelSwiftTerminal.Layout {
    public struct Cell: Equatable {
        public var char: Character
        public var foregroundColor: Style.Color
        
        /// When this is nil, it does not mean the default background color.
        /// Rather, it means that the background color from the content below
        /// is used.
        public var backgroundColor: Style.Color?
        
        public var attributes: Style.CellAttributes
        
        public init(
            char: Character,
            foregroundColor: Style.Color = .default,
            backgroundColor: Style.Color? = nil,
            attributes: Style.CellAttributes = .init()
        ) {
            self.char = char
            self.foregroundColor = foregroundColor
            self.backgroundColor = backgroundColor
            self.attributes = attributes
        }
    }
}
