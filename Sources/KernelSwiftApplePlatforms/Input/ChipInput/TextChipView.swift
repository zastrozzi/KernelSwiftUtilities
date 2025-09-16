//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 06/03/2025.
//

import Foundation
import SwiftUI

public struct TextChipView<Style: PrimitiveButtonStyle>: View {
    var item: any TextChipRepresentable
    var isSelected: Bool
    var buttonStyle: Style
    var onSelected: (any TextChipRepresentable) -> Void
    var font: Font
    
    public init(
        item: any TextChipRepresentable,
        isSelected: Bool,
        buttonStyle: Style = PlainButtonStyle(),
        font: Font = .headline,
        onSelected: @escaping (any TextChipRepresentable) -> Void
    ) {
        self.item = item
        self.isSelected = isSelected
        self.onSelected = onSelected
        self.buttonStyle = buttonStyle
        self.font = font
    }
    
    public var body: some View {
        Button(action: { onSelected(item) }) {
            HStack {
                Text(item.title).font(font).foregroundColor(Color.white)
            }.padding(10).padding(.horizontal, 5).background(item.color.gradient)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(buttonStyle)
    }
}
