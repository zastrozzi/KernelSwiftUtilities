//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

extension FlowStack {
    public struct LayoutResult {
        var bounds = CGSize.zero
        var rows = [LayoutRow]()
        
        public init(
            in maxPossibleWidth: Double,
            subviews: Subviews,
            alignment: Alignment,
            horizontalSpacing: CGFloat?,
            verticalSpacing: CGFloat?
        ) {
            var itemsInRow = 0
            var remainingWidth = maxPossibleWidth.isFinite ? maxPossibleWidth : .greatestFiniteMagnitude
            var rowMinY = 0.0
            var rowHeight = 0.0
            var xOffsets: [Double] = []
            
            for (index, subview) in zip(subviews.indices, subviews) {
                let idealSize = subview.sizeThatFits(.unspecified)
                if index != 0 && widthInRow(index: index, idealWidth: idealSize.width) > remainingWidth {
                    finaliseRow(index: max(index - 1, 0), idealSize: idealSize)
                }
                addToRow(index: index, idealSize: idealSize)
                if index == subviews.count - 1 { finaliseRow(index: index, idealSize: idealSize) }
            }
            
            func widthInRow(index: Int, idealWidth: Double) -> Double {
                idealWidth + spacingBefore(index: index)
            }
            
            func spacingBefore(index: Int) -> Double {
                guard itemsInRow > 0 else { return 0 }
                return horizontalSpacing ?? subviews[index - 1]
                    .spacing.distance(to: subviews[index].spacing, along: .horizontal)
            }
            
            func addToRow(index: Int, idealSize: CGSize) {
                let width = widthInRow(index: index, idealWidth: idealSize.width)
                xOffsets.append(maxPossibleWidth - remainingWidth + spacingBefore(index: index))
                remainingWidth -= width
                rowHeight = max(rowHeight, idealSize.height)
                itemsInRow += 1
            }
            
            func finaliseRow(index: Int, idealSize: CGSize) {
                let rowWidth = maxPossibleWidth - remainingWidth
                rows.append(
                    .init(
                        range: (index - max(itemsInRow - 1, 0))..<(index + 1),
                        xOffsets: xOffsets,
                        frame: .init(x: 0, y: rowMinY, width: rowWidth, height: rowHeight)
                    )
                )
                bounds.width = max(bounds.width, rowWidth)
                
                let ySpacing = verticalSpacing ?? ViewSpacing()
                    .distance(to: ViewSpacing(), along: .vertical)
                
                bounds.height += rowHeight + (rows.count > 1 ? ySpacing : 0)
                rowMinY += rowHeight + ySpacing
                itemsInRow = 0
                rowHeight = 0
                xOffsets.removeAll()
                remainingWidth = maxPossibleWidth
            }
        }
        
        
    }
    
    
}
