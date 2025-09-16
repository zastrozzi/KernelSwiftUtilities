//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/03/2025.
//

import Foundation
import SwiftUI

public protocol SegmentedIconSelectable: Identifiable, Hashable, Sendable, CaseIterable where AllCases: RandomAccessCollection {
    var index: Int { get }
    var label: String { get }
    var icon: String { get }
    var labelColor: Color { get }
    var iconColor: Color { get }
}

extension SegmentedIconSelectable {
    public var id: Int { index }
}

public struct SegmentedIconPickerView<
    Selection: SegmentedIconSelectable,
    PickerBackgroundStyle: ShapeStyle,
    SelectionBackgroundStyle: ShapeStyle
>: View {
    @Binding public var currentSelection: Selection
    @Namespace private var iconSegmentedPicker
    @ScaledMetric var pickerHeight: CGFloat = 35
    @ScaledMetric var fontScale: CGFloat = 1
    @State private var offset = CGSize.zero
    @GestureState private var dragState: Bool = false
    @State private var canDrag: Bool = true
    var pickerLabel: String
    var labelFont: Font
    var iconFont: Font
    var backgroundStyle: PickerBackgroundStyle
    var selectionBackgroundStyle: SelectionBackgroundStyle
    
    var animation: Animation = .spring(response: 0.2, dampingFraction: 1)
    
    public init(
        _ pickerLabel: String,
        _ currentSelection: Binding<Selection>,
        labelFont: Font,
        iconFont: Font,
        backgroundStyle: PickerBackgroundStyle = Material.ultraThin,
        selectionBackgroundStyle: SelectionBackgroundStyle = Material.bar
    ) {
        self.pickerLabel = pickerLabel
        self._currentSelection = currentSelection
        self.labelFont = labelFont
        self.iconFont = iconFont
        self.backgroundStyle = backgroundStyle
        self.selectionBackgroundStyle = selectionBackgroundStyle
    }
    
    public var body: some View {
        HStack(spacing: 2) {
            ForEach(Selection.allCases) { selectionOption in
                HStack(spacing: 10) {
                    if currentSelection == selectionOption { Spacer() }
                    Image(systemName: selectionOption.icon)
                        .font(iconFont)
                        .padding(.horizontal, currentSelection == selectionOption ? 0 : 14)
                        .foregroundStyle(selectionOption.iconColor)
                    if currentSelection == selectionOption { Spacer() }
                }
                .matchedGeometryEffect(
                    id: selectionOption,
                    in: iconSegmentedPicker,
                    isSource: false
                )
                .opacity(0)
                if selectionOption.index != Selection.allCases.count - 1 {
                    Divider().padding(.vertical, 7)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(selectionBackgroundStyle)
                .padding(.vertical, 2)
                .shadow(color: .black.opacity(0.1), radius: 2)
                .offset(x: offset.width / 4)
                .matchedGeometryEffect(id: currentSelection, in: iconSegmentedPicker, isSource: false)
                
                
        )
        .overlay {
            HStack(spacing: 2) {
                ForEach(Selection.allCases) { selectionOption in
                    Button(action: { withAnimation(animation) { currentSelection = selectionOption }}) {
                        HStack(spacing: 10) {
                            if currentSelection == selectionOption { Spacer() }
                            Image(systemName: selectionOption.icon)
                                .font(iconFont)
                                .padding(.horizontal, currentSelection == selectionOption ? 0 : 14)
                                .foregroundStyle(selectionOption.iconColor)
                            if currentSelection == selectionOption {
                                Text(selectionOption.label)
                                    .font(labelFont)
                                    .foregroundStyle(selectionOption.labelColor)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            if currentSelection == selectionOption { Spacer() }
                        }
                        .offset(x: currentSelection == selectionOption ? offset.width / 4 : 0)
                        .opacity(currentSelection == selectionOption ? 1 : 0.7)
                        .frame(maxHeight: .infinity)
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .matchedGeometryEffect(
                        id: selectionOption,
                        in: iconSegmentedPicker
                    )
                    if selectionOption.index != Selection.allCases.count - 1 {
                        Divider().padding(.vertical, 7).opacity(0)
                    }
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color.white.opacity(0.01))
                .matchedGeometryEffect(id: currentSelection, in: iconSegmentedPicker, isSource: false)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if abs(value.translation.width) < 70 { offset = value.translation }
                            if abs(value.translation.width) > 50 {
                                let directionForward = value.translation.width > 0 ? true : false
                                if directionForward && currentSelection.index < Selection.allCases.count - 1 && canDrag {
                                    canDrag = false
                                    withAnimation(animation) {
                                        currentSelection = Array(Selection.allCases)[currentSelection.index + 1]
                                    }
                                }
                                if !directionForward && currentSelection.index > 0 && canDrag {
                                    canDrag = false
                                    withAnimation(animation) {
                                        currentSelection = Array(Selection.allCases)[currentSelection.index - 1]
                                    }
                                }
                            }
                        }
                        .onEnded { _ in
                            canDrag = true
                            withAnimation(animation) {
                                offset = .zero
                            }
                        }
                )
            
        )
        
        .frame(height: pickerHeight)
        .padding(.horizontal, 2)
        .clipped()
        .background(backgroundStyle, in: RoundedRectangle(cornerRadius: 6))
        .accessibilityLabel(pickerLabel)
        .onChange(of: currentSelection) { oldValue, newValue in
            if oldValue != newValue {
                Haptics.selection()
            }
        }
    }
}


struct PreviewSegmentedIconPickerView: View {
    enum PreviewSelection: SegmentedIconSelectable {
        case option1
        case option2
        case option3
        
        var index: Int {
            switch self {
            case .option1: 0
            case .option2: 1
            case .option3: 2
            }
        }
        
        var label: String {
            switch self {
            case .option1: "Opt. 1"
            case .option2: "Option Two"
            case .option3: "Option 3"
            }
        }
        
        var icon: String {
            switch self {
            case .option1: "star"
            case .option2: "giftcard"
            case .option3: "storefront"
            }
        }
        
        var labelColor: Color {
            switch self {
            case .option1: .label
            case .option2: .label
            case .option3: .label
            }
        }
        
        var iconColor: Color {
            switch self {
            case .option1: .blue
            case .option2: .orange
            case .option3: .yellow
            }
        }
    }
    
    @State var selection: PreviewSelection = .option1
    
    var body: some View {
        SegmentedIconPickerView(
            "Preview Selection",
            $selection,
            labelFont: .system(size: 14, weight: .medium),
            iconFont: .system(size: 16, weight: .medium)
        )
        .padding()
        
    }
}

#Preview {
    PreviewSegmentedIconPickerView()
}
