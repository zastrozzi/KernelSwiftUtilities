//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

extension KernelSwiftTerminal.Style {
    public struct CellAttributes: Equatable {
        public var bold: Bool
        public var italic: Bool
        public var underline: Bool
        public var strikethrough: Bool
        public var inverted: Bool
        
        public init(
            bold: Bool = false,
            italic: Bool = false,
            underline: Bool = false,
            strikethrough: Bool = false,
            inverted: Bool = false
        ) {
            self.bold = bold
            self.italic = italic
            self.underline = underline
            self.strikethrough = strikethrough
            self.inverted = inverted
        }
    }
}
