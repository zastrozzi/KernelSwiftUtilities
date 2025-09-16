//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 05/03/2025.
//

import Foundation
import SwiftUI

public struct LeadingIconTextFieldStyle: @preconcurrency TextFieldStyle {
    var isFocused: FocusState<Bool>.Binding
    var focusedStrokeColor: Color
    var defocusedStrokeColor: Color
    var focusedBackgroundStyle: AnyShapeStyle
    var defocusedBackgroundStyle: AnyShapeStyle
    var focusedPlaceholderColor: Color
    var defocusedPlaceholderColor: Color
    var focusedColor: Color
    var defocusedColor: Color
    var focusedIconColor: Color
    var defocusedIconColor: Color
    var focusedLeadingIconName: String?
    var defocusedLeadingIconName: String?
    var showLeadingIconWhenFocused: Bool
    var showLeadingIconWhenDefocused: Bool
    var font: Font
    var verticalPadding: CGFloat
    var horizontalPadding: CGFloat
    var cornerRadius: CGFloat
    var cornerStyle: RoundedCornerStyle
    var fullWidth: Bool
    
    var isFocusedVal: Bool { isFocused.wrappedValue }
    
    public init(
        isFocused: FocusState<Bool>.Binding,
        focusedStrokeColor: Color = .accentColor,
        defocusedStrokeColor: Color = .tertiaryLabel,
        backgroundStyle: AnyShapeStyle = .init(Color.clear),
        focusedBackgroundStyle: AnyShapeStyle? = nil,
        defocusedBackgroundStyle: AnyShapeStyle? = nil,
        placeholderColor: Color = .tertiaryLabel,
        focusedPlaceholderColor: Color? = nil,
        defocusedPlaceholderColor: Color? = nil,
        color: Color = .label,
        focusedColor: Color? = nil,
        defocusedColor: Color? = nil,
        focusedIconColor: Color? = nil,
        defocusedIconColor: Color? = nil,
        leadingIconName: String? = nil,
        focusedLeadingIconName: String? = nil,
        defocusedLeadingIconName: String? = nil,
        showLeadingIconWhenFocused: Bool = true,
        showLeadingIconWhenDefocused: Bool = false,
        font: Font = .body,
        verticalPadding: CGFloat = 15,
        horizontalPadding: CGFloat = 15,
        cornerRadius: CGFloat = 8,
        cornerStyle: RoundedCornerStyle = .continuous,
        fullWidth: Bool = true
    ) {
        self.isFocused = isFocused
        self.focusedStrokeColor = focusedStrokeColor
        self.defocusedStrokeColor = defocusedStrokeColor
        self.focusedBackgroundStyle = focusedBackgroundStyle ?? backgroundStyle
        self.defocusedBackgroundStyle = defocusedBackgroundStyle ?? backgroundStyle
        self.focusedPlaceholderColor = focusedPlaceholderColor ?? placeholderColor
        self.defocusedPlaceholderColor = defocusedPlaceholderColor ?? placeholderColor
        self.focusedColor = focusedColor ?? color
        self.defocusedColor = defocusedColor ?? color
        self.focusedIconColor = focusedIconColor ?? focusedStrokeColor
        self.defocusedIconColor = defocusedIconColor ?? defocusedStrokeColor
        self.focusedLeadingIconName = focusedLeadingIconName ?? leadingIconName
        self.defocusedLeadingIconName = defocusedLeadingIconName ?? leadingIconName
        self.showLeadingIconWhenFocused = showLeadingIconWhenFocused
        self.showLeadingIconWhenDefocused = showLeadingIconWhenDefocused
        self.font = font
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.cornerRadius = cornerRadius
        self.cornerStyle = cornerStyle
        self.fullWidth = fullWidth
    }
    
    @MainActor @preconcurrency
    public func _body(configuration: TextField<_Label>) -> some View {
        HStack {
            leadingIcon
            
            configuration
                .multilineTextAlignment(.leading)
                .font(font)
                .foregroundStyle(isFocusedVal ? focusedColor : defocusedColor)
            Spacer(minLength: 0)
        }
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
        .background(background)
        .if(fullWidth) { $0.frame(minWidth: 0, maxWidth: .infinity) }
        .animation(.bouncy, value: isFocusedVal)
        .onTapGesture { if !isFocusedVal { isFocused.wrappedValue = true } }
        .labelsHidden()
    }
    
    @ViewBuilder @MainActor
    var background: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: cornerStyle)
            .fill(isFocusedVal ? focusedBackgroundStyle : defocusedBackgroundStyle)
            .strokeBorder(isFocusedVal ? focusedStrokeColor : defocusedStrokeColor, lineWidth: isFocusedVal ? 2.0 : 1.5)
            .contentTransition(.opacity)
            .id("background")
            .compositingGroup()
//            .animation(.bouncy, value: isFocusedVal)
    }
    
    @ViewBuilder @MainActor
    var leadingIcon: some View {
        if let leadingIconName = isFocusedVal ? focusedLeadingIconName : defocusedLeadingIconName {
            if (showLeadingIconWhenFocused && isFocusedVal) || (showLeadingIconWhenDefocused && !isFocusedVal) {
                Image(systemName: leadingIconName).font(font)
                    .if(showLeadingIconWhenFocused && showLeadingIconWhenDefocused) {
                        $0.contentTransition(.symbolEffect(.replace))
                    }
                    .if((!showLeadingIconWhenFocused) || (!showLeadingIconWhenDefocused)) {
                        $0.transition(.scale)
                    }
//                    .contentTransition(showLeadingIconWhenFocused && showLeadingIconWhenDefocused ? .symbolEffect(.replace) : .symbolEffect(.replace))
                    .foregroundColor(isFocusedVal ? focusedIconColor : defocusedIconColor)
            }
        }
    }
}
