//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

public struct IconChipView<Style: PrimitiveButtonStyle>: View {
    var item: any IconChipRepresentable
    var isSelected: Bool
    var buttonStyle: Style
    var onSelected: (any IconChipRepresentable) -> Void
    
    public init(item: any IconChipRepresentable, isSelected: Bool, buttonStyle: Style = PlainButtonStyle(), onSelected: @escaping (any IconChipRepresentable) -> Void) {
        self.item = item
        self.isSelected = isSelected
        self.onSelected = onSelected
        self.buttonStyle = buttonStyle
    }
    
    public var body: some View {
        Button(action: { onSelected(item) }) {
            HStack {
                Image(systemName: item.image).font(.system(size: 16, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.white)
                Text(item.title).font(.headline).foregroundColor(Color.white)
            }.padding(10).padding(.trailing, 10).padding(.leading, 5).background(item.color.gradient)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(buttonStyle)
    }
}
