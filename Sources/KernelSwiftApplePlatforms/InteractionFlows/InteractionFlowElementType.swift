//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/08/2023.
//

import Foundation
import SwiftUI

public struct InteractionFlowElementType<Identifier: InteractionFlowElementIdentifiable> {
    public var id: Identifier
    public var isSkippable: Bool
    public var inputType: InteractionFlowInputType
//    public var _inputType: _InteractionFlowInputType<some View>?
    public var hintPretitle: String?
    public var hintTitle: String
    public var hintText: String
    public var next: (Bool) -> (next: Identifier, onSkip: Identifier)
    public var condition: (InteractionFlowInput) -> Bool
    public var onInputChange: (InteractionFlowInput) -> Void
    
    public init(
        id: Identifier,
        isSkippable: Bool,
        inputType: InteractionFlowInputType,
        hintPretitle: String? = nil,
        hintTitle: String,
        hintText: String,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool,
        onInputChange: @escaping (InteractionFlowInput) -> Void = { _ in }
    ) {
        self.id = id
        self.isSkippable = isSkippable
        self.inputType = inputType
        self.hintPretitle = hintPretitle
        self.hintTitle = hintTitle
        self.hintText = hintText
        self.next = next
        self.condition = condition
        self.onInputChange = onInputChange
//        self._inputType = nil
    }
    
    public static func binary(
        _ identifier: Identifier,
        choices: [any BinaryInputRepresentable],
        pretitle: String? = nil,
        title: String,
        text: String,
        skippable: Bool = false,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool = { _ in false }
    ) -> InteractionFlowElementType {
        InteractionFlowElementType(
            id: identifier,
            isSkippable: skippable,
            inputType: .binaryChoice(choices: choices),
            hintPretitle: pretitle,
            hintTitle: title,
            hintText: text,
            next: next,
            condition: condition
        )
    }
    
    public static func custom<V: View>(
        _ identifier: Identifier,
        viewType: V.Type,
        pretitle: String? = nil,
        title: String,
        text: String,
        skippable: Bool = false,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool = { _ in false },
        @ViewBuilder content: @escaping () -> V
    ) -> InteractionFlowElementType {
        InteractionFlowElementType(
            id: identifier,
            isSkippable: skippable,
            inputType: .custom(viewType: viewType, content: content()),
            hintPretitle: pretitle,
            hintTitle: title,
            hintText: text,
            next: next,
            condition: condition
        )
    }
    
    public static func iconChip(
        _ identifier: Identifier,
        allChips: [any IconChipRepresentable],
        pretitle: String? = nil,
        title: String,
        text: String,
        skippable: Bool = false,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool = { _ in false }
    ) -> InteractionFlowElementType {
        InteractionFlowElementType(
            id: identifier,
            isSkippable: skippable,
            inputType: .iconChip(allChips: allChips),
            hintPretitle: pretitle,
            hintTitle: title,
            hintText: text,
            next: next,
            condition: condition
        )
    }
    
    public static func currency(
        _ identifier: Identifier,
        fieldLabel: String,
        pretitle: String? = nil,
        title: String,
        text: String,
        skippable: Bool = false,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool = { _ in false }
    ) -> InteractionFlowElementType {
        InteractionFlowElementType(
            id: identifier,
            isSkippable: skippable,
            inputType: .currency(fieldLabel: fieldLabel),
            hintPretitle: pretitle,
            hintTitle: title,
            hintText: text,
            next: next,
            condition: condition
        )
    }
    
    public static func date(
        _ identifier: Identifier,
        fieldLabel: String,
        pretitle: String? = nil,
        title: String,
        text: String,
        skippable: Bool = false,
        before: Binding<Date?>,
        after: Binding<Date?>,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool = { _ in false },
        onInputChange: @escaping (InteractionFlowInput) -> Void
    ) -> InteractionFlowElementType {
        InteractionFlowElementType(
            id: identifier,
            isSkippable: skippable,
            inputType: .date(fieldLabel: fieldLabel, before: before, after: after),
            hintPretitle: pretitle,
            hintTitle: title,
            hintText: text,
            next: next,
            condition: condition,
            onInputChange: onInputChange
        )
    }
    
    public static func textField(
        _ identifier: Identifier,
        fieldLabel: String,
        pretitle: String? = nil,
        title: String,
        text: String,
        placeholder: String? = nil,
        contentType: KernelSwiftTextContentType? = nil,
        keyboardType: KernelSwiftKeyboardType = .default,
        allowed: CharacterSet? = nil,
        disallowed: CharacterSet? = nil,
        formatter: Formatter? = nil,
        skippable: Bool = false,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool = { _ in false }
    ) -> InteractionFlowElementType {
        InteractionFlowElementType(
            id: identifier,
            isSkippable: skippable,
            inputType: .textField(
                fieldLabel: fieldLabel,
                placeholder: placeholder,
                contentType: contentType,
                keyboardType: keyboardType,
                allowed: allowed,
                disallowed: disallowed,
                formatter: formatter
            ),
            hintPretitle: pretitle,
            hintTitle: title,
            hintText: text,
            next: next,
            condition: condition
        )
    }
    
    @available(iOS 17.0, macOS 14.0, *)
    public func toElement() -> InteractionFlowElement {
//        var el =
//        
////        el._inputType = _inputType
        return InteractionFlowElement.init(
            isSkippable: isSkippable,
            inputType: inputType,
            hintPretitle: hintPretitle,
            hintTitle: hintTitle,
            hintText: hintText,
            id: id,
            next: next,
            condition: condition,
            onInputChange: onInputChange
        )
    }
    
}
