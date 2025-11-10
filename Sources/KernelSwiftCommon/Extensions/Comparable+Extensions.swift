//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/11/2025.
//

import Foundation

extension Comparable {
    public func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
