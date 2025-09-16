//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/03/2025.
//

import Foundation
import SwiftUI

public struct LeadingIconTextField: View {
    public var placeholder: String
    public var prompt: Text?
    @Binding public var text: String
    public var isFocused: FocusState<Bool>.Binding
    
    public var focusedStrokeColor: Color
    public var defocusedStrokeColor: Color
    public var focusedBackgroundStyle: AnyShapeStyle
    public var defocusedBackgroundStyle: AnyShapeStyle
    public var focusedPlaceholderColor: Color
    public var defocusedPlaceholderColor: Color
    public var focusedColor: Color
    public var defocusedColor: Color
    public var focusedIconColor: Color
    public var defocusedIconColor: Color
    
    public var focusedLeadingIconName: String?
    public var defocusedLeadingIconName: String?
    public var showLeadingIconWhenFocused: Bool
    public var showLeadingIconWhenDefocused: Bool
    public var font: Font
    
    public var verticalPadding: CGFloat
    public var horizontalPadding: CGFloat
    public var cornerRadius: CGFloat
    public var cornerStyle: RoundedCornerStyle
    public var fullWidth: Bool
    
    var isFocusedVal: Bool { isFocused.wrappedValue }
    
    public init(
        _ placeholder: String,
        prompt: Text? = nil,
        text: Binding<String>,
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
        self.placeholder = placeholder
        self.prompt = prompt
        self._text = text
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
    
    public var body: some View {
        TextField(text: $text, prompt: prompt, label: {
            Text(placeholder)
                .font(font)
                .foregroundStyle(isFocusedVal ? focusedPlaceholderColor : defocusedPlaceholderColor)
        })
        .focused(isFocused)
        .textFieldStyle(
            LeadingIconTextFieldStyle(
                isFocused: isFocused,
                focusedStrokeColor: focusedStrokeColor,
                defocusedStrokeColor: defocusedStrokeColor,
                focusedBackgroundStyle: focusedBackgroundStyle,
                defocusedBackgroundStyle: defocusedBackgroundStyle,
                focusedPlaceholderColor: focusedPlaceholderColor,
                defocusedPlaceholderColor: defocusedPlaceholderColor,
                focusedColor: focusedColor,
                defocusedColor: defocusedColor,
                focusedIconColor: focusedIconColor,
                defocusedIconColor: defocusedIconColor,
                focusedLeadingIconName: focusedLeadingIconName,
                defocusedLeadingIconName: defocusedLeadingIconName,
                showLeadingIconWhenFocused: showLeadingIconWhenFocused,
                showLeadingIconWhenDefocused: showLeadingIconWhenDefocused,
                font: font,
                verticalPadding: verticalPadding,
                horizontalPadding: horizontalPadding,
                cornerRadius: cornerRadius,
                cornerStyle: cornerStyle,
                fullWidth: fullWidth
            )
        )
    }
}
