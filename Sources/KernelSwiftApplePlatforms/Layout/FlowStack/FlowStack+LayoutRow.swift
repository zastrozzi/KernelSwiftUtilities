//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

extension FlowStack {
    public struct LayoutRow {
        public init(
            range: Range<Int>,
            xOffsets: [Double],
            frame: CGRect
        ) {
            self.range = range
            self.xOffsets = xOffsets
            self.frame = frame
        }
        
        public var range: Range<Int>
        public var xOffsets: [Double]
        public var frame: CGRect
    }
}
