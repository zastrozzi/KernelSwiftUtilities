//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

public enum InteractionFlowInputType {
    case binaryChoice(choices: [any BinaryInputRepresentable])
    case currency(fieldLabel: String)
    case date(fieldLabel: String, before: Binding<Date?>, after: Binding<Date?>)
    case iconChip(allChips: [any IconChipRepresentable])
    case textField(
        fieldLabel: String,
        placeholder: String? = nil,
        contentType: BKTextContentType? = nil,
        keyboardType: BKKeyboardType = .default,
        allowed: CharacterSet? = nil,
        disallowed: CharacterSet? = nil,
        formatter: Formatter? = nil
    )
    case custom(viewType: any View.Type, content: any View)
}


public struct _InteractionFlowInputType<CustomView: View> {
        
    var fieldLabel: String?
    
    var binaryChoices: [any BinaryInputRepresentable]?
    var iconChips: [any IconChipRepresentable]?
    
    var textFieldPlaceholder: String?
    var textFieldContentType: BKTextContentType?
    var textFieldKeyboardType: BKKeyboardType?
    var textFieldAllowed: CharacterSet?
    var textFieldDisallowed: CharacterSet?
    var textFieldFormatter: Formatter?
    
    var customViewContent: CustomView
    
    internal init(
        fieldLabel: String? = nil,
        binaryChoices: [any BinaryInputRepresentable]? = nil,
        iconChips: [any IconChipRepresentable]? = nil,
        textFieldPlaceholder: String? = nil,
        textFieldContentType: BKTextContentType? = nil,
        textFieldKeyboardType: BKKeyboardType? = nil,
        textFieldAllowed: CharacterSet? = nil,
        textFieldDisallowed: CharacterSet? = nil,
        textFieldFormatter: Formatter? = nil,
        @ViewBuilder customViewContent: @escaping () -> CustomView = { EmptyView() }
    ) {
        self.fieldLabel = fieldLabel
        self.binaryChoices = binaryChoices
        self.iconChips = iconChips
        self.textFieldPlaceholder = textFieldPlaceholder
        self.textFieldContentType = textFieldContentType
        self.textFieldKeyboardType = textFieldKeyboardType
        self.textFieldAllowed = textFieldAllowed
        self.textFieldDisallowed = textFieldDisallowed
        self.textFieldFormatter = textFieldFormatter
        self.customViewContent = customViewContent()
    }

    public static func binaryChoice(choices: [any BinaryInputRepresentable]) -> _InteractionFlowInputType<EmptyView> {
        .init(binaryChoices: choices)
    }
    
    public static func currency(fieldLabel: String) -> _InteractionFlowInputType<EmptyView> {
        .init(fieldLabel: fieldLabel)
    }
    
    public static func date(fieldLabel: String) -> _InteractionFlowInputType<EmptyView> {
        .init(fieldLabel: fieldLabel)
    }
    
    public static func iconChip(allChips: [any IconChipRepresentable]) -> _InteractionFlowInputType<EmptyView> {
        .init(iconChips: allChips)
    }
    
    public static func textField(
        fieldLabel: String,
        placeholder: String? = nil,
        contentType: BKTextContentType? = nil,
        keyboardType: BKKeyboardType = .default,
        allowed: CharacterSet? = nil,
        disallowed: CharacterSet? = nil,
        formatter: Formatter? = nil
    ) -> _InteractionFlowInputType<EmptyView> {
        .init(fieldLabel: fieldLabel, textFieldPlaceholder: placeholder, textFieldContentType: contentType, textFieldKeyboardType: keyboardType, textFieldAllowed: allowed, textFieldDisallowed: disallowed, textFieldFormatter: formatter)
    }

    public static func custom(@ViewBuilder customViewContent: @escaping () -> CustomView) -> _InteractionFlowInputType<CustomView> {
        .init(customViewContent: customViewContent)
    }
}
