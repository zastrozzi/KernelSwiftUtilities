//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

public struct FlowStack: Layout {
    
    public var alignment: Alignment = .center
    public var horizontalSpacing: CGFloat?
    public var verticalSpacing: CGFloat?
    public var spacing: CGFloat?
    
    public init(
        alignment: Alignment = .center,
        spacing: CGFloat? = nil
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.horizontalSpacing = nil
        self.verticalSpacing = nil
    }
    
    public init(
        alignment: Alignment = .center,
        horizontalSpacing: CGFloat? = nil,
        verticalSpacing: CGFloat? = nil
    ) {
        self.alignment = alignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.spacing = nil
    }
    
    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxW = proposal.replacingUnspecifiedDimensions().width
        let result = LayoutResult(
            in: maxW,
            subviews: subviews,
            alignment: alignment,
            horizontalSpacing: horizontalSpacing ?? spacing,
            verticalSpacing: verticalSpacing ?? spacing
        )
        return result.bounds
    }
    
    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let maxW = proposal.replacingUnspecifiedDimensions().width
        let result = LayoutResult(
            in: maxW,
            subviews: subviews,
            alignment: alignment,
            horizontalSpacing: horizontalSpacing ?? spacing,
            verticalSpacing: verticalSpacing ?? spacing
        )
        for row in result.rows {
            let rowXOffset = (bounds.width - row.frame.width) * alignment.horizontal.asProportion
            for index in row.range {
                let xPos = rowXOffset + row.frame.minX + row.xOffsets[index - row.range.lowerBound] + bounds.minX
                let rowYAlignment = (row.frame.height - subviews[index].sizeThatFits(.unspecified).height) * alignment.vertical.asProportion
                let yPos = row.frame.minY + rowYAlignment + bounds.minY
                subviews[index].place(at: .init(x: xPos, y: yPos), anchor: .topLeading, proposal: .unspecified)
            }
        }
    }
}

