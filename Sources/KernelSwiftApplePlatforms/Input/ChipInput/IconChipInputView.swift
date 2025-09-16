//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
public struct IconChipInputView<Style: PrimitiveButtonStyle>: View {
    @Binding var selectedChip: (any IconChipRepresentable)?
    var buttonStyle: Style
    var allChips: [any IconChipRepresentable]
    var onChanged: (Bool) -> Void
    
    public init(allChips: [any IconChipRepresentable], selectedChip: Binding<(any IconChipRepresentable)?>, buttonStyle: Style = PlainButtonStyle(), onChanged: @escaping (Bool) -> Void = { _ in }) {
        self._selectedChip = selectedChip
        self.buttonStyle = buttonStyle
        self.allChips = allChips
        self.onChanged = onChanged
    }
    
    var chipsToPresent: [any IconChipRepresentable] {
        allChips.filter { chip in
            if let selectedChip { chip.equals(selectedChip) }
            else { true }
        }
    }
    
    func handleChipSelection(_ chip: any IconChipRepresentable) {
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
                IconChipView(
                    item: chip,
                    isSelected: chip.equals(selectedChip),
                    buttonStyle: buttonStyle,
                    onSelected: handleChipSelection
                )
                .transition(.scale)
            }
        }
//        return Text("")
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct ChipInputPreviewView: View {
    
    
    @State var selected: ChipType? = nil
    
    var selectedAsAny: Binding<(any IconChipRepresentable)?> {
        .init {
            selected
        } set: { newValue in
            selected = newValue as? ChipType
        }

    }
    
    var body: some View {
        ScrollView {
            VStack {
                IconChipInputView(allChips: ChipType.allCases, selectedChip: selectedAsAny)
            }
        }
    }
}

enum ChipType: IconChipRepresentable {
    case CARD
    case LOAN
    case CAR
    case HOLIDAY
    case EDUCATION
    case OTHER(String)
    
    static let allCases: [ChipType] = [
        .CARD,
            .LOAN,
        .CAR,
        .HOLIDAY,
        .EDUCATION,
        .OTHER("")
    ]
    
    var id: String {
        switch self {
        case .CARD: "CARD"
        case .LOAN: "LOAN"
        case .CAR: "CAR"
        case .HOLIDAY: "HOLIDAY"
        case .EDUCATION: "EDUCATION"
        case .OTHER(let other): "OTHER/\(other)"
        }
    }
    
    var title: String {
        switch self {
        case .CARD: "Credit Card"
        case .LOAN: "Loan"
        case .CAR: "Car"
        case .HOLIDAY: "Holiday"
        case .EDUCATION: "Education"
        case .OTHER(let other): other.isEmpty ? "Other" : other
        }
    }
    
    var image: String {
        switch self {
        case .CARD: "creditcard"
        case .LOAN: "signature"
        case .CAR: "car"
        case .HOLIDAY: "beach.umbrella"
        case .EDUCATION: "graduationcap"
        case .OTHER: "questionmark"
        }
    }
    
    var color: Color {
        switch self {
        case .CARD: .blue
        case .LOAN: .green
        case .CAR: .teal
        case .HOLIDAY: .yellow
        case .EDUCATION: .indigo
        case .OTHER: .gray
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview {
    ChipInputPreviewView()
}
