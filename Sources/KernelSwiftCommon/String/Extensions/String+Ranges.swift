//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/10/2025.
//

import Foundation

extension String {
    public var fullRange: Range<String.Index> {
        self.startIndex..<self.endIndex
    }
}
