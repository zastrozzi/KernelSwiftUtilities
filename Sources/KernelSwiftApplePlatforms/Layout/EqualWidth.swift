//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/10/2025.
//

import Foundation
import SwiftUI

public struct EqualWidth: Layout {
    public enum Vertical {
        case top, center, bottom
    }
    
    private let spacing: CGFloat?
    private let alignment: VerticalAlignment
    
    public init(spacing: CGFloat? = nil, alignment: VerticalAlignment = .center) {
        self.spacing = spacing
        self.alignment = alignment
    }
    
    // MARK: - Layout
    
    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        // Resolve horizontal spacing
        let totalSpacing = resolvedTotalSpacing(subviews: subviews)
        
        // If we have a proposed width, we can compute per-item width directly.
        if let proposedWidth = proposal.width {
            let perWidth = max((proposedWidth - totalSpacing) / CGFloat(subviews.count), 0)
            // Ask each subview for its height at that width; we need the max.
            let maxHeight = subviews.map {
                $0.sizeThatFits(.init(width: perWidth, height: proposal.height)).height
            }.max() ?? 0
            
            return CGSize(width: proposedWidth,
                          height: proposal.height ?? maxHeight)
        } else {
            // No proposed width: compute the "ideal" width = max intrinsic width across subviews,
            // then total width is count * max + spacing.
            let idealItemWidth = subviews.map {
                $0.sizeThatFits(.unspecified).width
            }.max() ?? 0
            
            let perWidth = idealItemWidth
            let maxHeight = subviews.map {
                $0.sizeThatFits(.init(width: perWidth, height: proposal.height)).height
            }.max() ?? 0
            
            let totalWidth = CGFloat(subviews.count) * perWidth + totalSpacing
            return CGSize(width: totalWidth,
                          height: proposal.height ?? maxHeight)
        }
    }
    
    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        guard !subviews.isEmpty else { return }
        
        let totalSpacing = resolvedTotalSpacing(subviews: subviews)
        let slotWidth = max((bounds.width - totalSpacing) / CGFloat(subviews.count), 0)
        
        // Compute each subview's size at slotWidth to place with vertical alignment.
        let sizes = subviews.map {
            $0.sizeThatFits(.init(width: slotWidth, height: bounds.height))
        }
        let rowHeight = max(sizes.map(\.height).max() ?? 0, bounds.height)
        
        var x = bounds.minX
        for (index, subview) in subviews.enumerated() {
            let size = sizes[index]
            let y: CGFloat
            switch alignment {
            case .top:    y = bounds.minY
            case .bottom: y = bounds.maxY - size.height
            case .center: y = bounds.minY + (rowHeight - size.height) / 2
            // FIXME: we need to cover firstTextBaseline and lastTextBaseline
            default:      y = bounds.minY + (rowHeight - size.height) / 2
            }
            
            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: .init(width: slotWidth, height: size.height)
            )
            
            if index < subviews.count - 1 {
                x += slotWidth + resolvedSpacing(between: subviews[index], and: subviews[index + 1])
            } else {
                x += slotWidth
            }
        }
    }
    
    // MARK: - Spacing helpers
    
    private func resolvedSpacing(between lhs: Subviews.Element, and rhs: Subviews.Element) -> CGFloat {
        if let spacing { return spacing }
        // Ask SwiftUI for the default spacing between these two subviews horizontally.
        return lhs.spacing.distance(to: rhs.spacing, along: .horizontal)
    }
    
    private func resolvedTotalSpacing(subviews: Subviews) -> CGFloat {
        guard subviews.count > 1 else { return 0 }
        return (0..<(subviews.count - 1)).reduce(0) { acc, i in
            acc + resolvedSpacing(between: subviews[i], and: subviews[i + 1])
        }
    }
}
