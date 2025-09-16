//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Layout {
    public struct EdgeSet {
        public var top: Int
        public var bottom: Int
        public var leading: Int
        public var trailing: Int
        
        public init(
            top: Int = .zero,
            bottom: Int = .zero,
            leading: Int = .zero,
            trailing: Int = .zero
        ) {
            self.top = top
            self.bottom = bottom
            self.leading = leading
            self.trailing = trailing
        }
        
//        public init(
//            horizontal: Int = .zero
//        ) {
//            self.init(leading: horizontal, trailing: horizontal)
//        }
//        
//        public init(
//            vertical: Int = .zero
//        ) {
//            self.init(top: vertical, bottom: vertical)
//        }
        
        public init(
            horizontal: Int = .zero,
            vertical: Int = .zero
        ) {
            self.init(top: vertical, bottom: vertical, leading: horizontal, trailing: horizontal)
        }
    }
}
