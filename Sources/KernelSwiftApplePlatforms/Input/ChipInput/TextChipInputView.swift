//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 06/03/2025.
//

import Foundation
import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
public struct TextChipInputView<Style: PrimitiveButtonStyle>: View {
    @Binding var selectedChip: (any TextChipRepresentable)?
    var buttonStyle: Style
    var font: Font
    var allChips: [any TextChipRepresentable]
    var onChanged: (Bool) -> Void
    
    public init(
        allChips: [any TextChipRepresentable],
        selectedChip: Binding<(any TextChipRepresentable)?>,
        buttonStyle: Style = PlainButtonStyle(),
        font: Font = .headline,
        onChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self._selectedChip = selectedChip
        self.buttonStyle = buttonStyle
        self.font = font
        self.allChips = allChips
        self.onChanged = onChanged
    }
    
    var chipsToPresent: [any TextChipRepresentable] {
        allChips.filter { chip in
            if let selectedChip { chip.equals(selectedChip) }
            else { true }
        }
    }
    
    func handleChipSelection(_ chip: any TextChipRepresentable) {
        let selecting = !chip.equals(selectedChip)
        if selectedChip == nil {
            withAnimation(.smooth(extraBounce: 0.3)) { selectedChip = chip }
        } else { withAnimation(.bouncy) { selectedChip = nil } }
        Task {
            try await Task.sleep(for: .milliseconds(100))
            onChanged(selecting)
        }
        
    }
    
    public var body: some View {
        FlowStack(alignment: .leading, spacing: 5) {
            ForEach(chipsToPresent, id: \.identifier) { chip in
                TextChipView(
                    item: chip,
                    isSelected: chip.equals(selectedChip),
                    buttonStyle: buttonStyle,
                    font: font,
                    onSelected: handleChipSelection
                )
                .transition(.scale)
            }
        }
        //        return Text("")
    }
}
