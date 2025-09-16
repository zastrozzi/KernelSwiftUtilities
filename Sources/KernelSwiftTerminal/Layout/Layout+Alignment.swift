//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 01/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Layout {
    public enum VerticalAlignment {
        case top
        case center
        case bottom
    }
    
    public enum HorizontalAlignment {
        case leading
        case center
        case trailing
    }
    
    public struct Alignment {
        public var horizontalAlignment: HorizontalAlignment
        public var verticalAlignment: VerticalAlignment
        
        public init(
            horizontalAlignment: HorizontalAlignment,
            verticalAlignment: VerticalAlignment
        ) {
            self.horizontalAlignment = horizontalAlignment
            self.verticalAlignment = verticalAlignment
        }
        
        public init(
            _ horizontalAlignment: HorizontalAlignment,
            _ verticalAlignment: VerticalAlignment
        ) {
            self.horizontalAlignment = horizontalAlignment
            self.verticalAlignment = verticalAlignment
        }
        
        public static let top               : Self = .init(.center, .top)
        public static let bottom            : Self = .init(.center, .bottom)
        public static let center            : Self = .init(.center, .center)
        public static let topLeading        : Self = .init(.leading, .top)
        public static let leading           : Self = .init(.leading, .center)
        public static let bottomLeading     : Self = .init(.leading, .bottom)
        public static let topTrailing       : Self = .init(.trailing, .top)
        public static let trailing          : Self = .init(.trailing, .center)
        public static let bottomTrailing    : Self = .init(.trailing, .bottom)
    }
}
