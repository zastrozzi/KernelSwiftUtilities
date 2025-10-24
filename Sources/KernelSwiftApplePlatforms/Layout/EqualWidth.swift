//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/10/2025.
//

import Foundation
import SwiftUI

public struct EqualWidth: Layout {
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = subviews.map { $0.sizeThatFits(.unspecified).width }.max() ?? 0
        let height = subviews.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
        return CGSize(width: maxWidth * CGFloat(subviews.count), height: height)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let width = bounds.width / CGFloat(subviews.count)
        for (i, subview) in subviews.enumerated() {
            let x = bounds.minX + CGFloat(i) * width
            subview.place(at: CGPoint(x: x, y: bounds.minY),
                          proposal: ProposedViewSize(width: width, height: bounds.height))
        }
    }
}
