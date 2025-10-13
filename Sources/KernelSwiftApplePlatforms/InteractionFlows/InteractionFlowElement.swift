//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

@available(iOS 17.0, macOS 14.0, *)
@Observable
public class InteractionFlowElement: Identifiable, @unchecked Sendable {
    @ObservationIgnored @KernelDI.Injected(\.interactionFlowService.skippedFlowElementIds) var skippedElementIds
    @ObservationIgnored @KernelDI.Injected(\.interactionFlowService.currentFlowElementId) var currentElementId
//    @Injected(\.inputService) var inputService: InputService
    
    var isSkippable: Bool
    public var input: InteractionFlowInput
    public var inputType: InteractionFlowInputType
    
    public var onInputChange: (InteractionFlowInput) -> Void
    
    
//    @ObservationIgnored public var _inputType: _InteractionFlowInputType<some View>?
    
    var showHint: Bool { 
        if case .customInput = input { return false }
        return (currentElementId == id) && !isSkipped
    }
    
    var showInput: Bool {
        (id.equals(currentElementId) || !inputIsNil) && !isSkipped
    }
    
//    var showSkip: Bool {
//        id.equals(interactionFlowService.currentFlowElementId) && isSkippable && !isSkipped
//    }
    
    var showSkipped: Bool { isSkippable && isSkipped }
    
    var isSkipped: Bool {
        skippedElementIds.contains(where: { $0 == id })
    }
    
    enum BlankRawRep: String, InteractionFlowElementIdentifiable {
        case BLANK
        
        var inputTitle: String { "Blank" }
    }
    
    let hintPretitle: String?
    let hintTitle: String
    let hintText: String
    public let id: any InteractionFlowElementIdentifiable
    
    var nextElementIdentifier: (Bool) -> (next: any InteractionFlowElementIdentifiable, onSkip: any InteractionFlowElementIdentifiable)
    var condition: (InteractionFlowInput) -> Bool
    
    func getNextIdentifier(skipping: Bool = false) -> any InteractionFlowElementIdentifiable {
        if skipping {
            
            return self.nextElementIdentifier(condition(input)).onSkip
        } else {
            return self.nextElementIdentifier(condition(input)).next
        }
    }
    
    var skippedTitle: String {
        switch inputType {
        case .binaryChoice: hintTitle
        case let .currency(fieldLabel): fieldLabel
        case let .textField(fieldLabel,_,_,_,_,_,_): fieldLabel
        case let .date(fieldLabel,_,_): fieldLabel
        case .iconChip: hintTitle
        case .custom: hintTitle
        }
    }
    
    func resetInput() {
        switch input {
        case let .dateInput(_, before, after,_): input = .dateInput(selectedDate: nil, before: before, after: after, isEditing: false)
        case .currencyInput(let currency, _, _): input = .currencyInput(currency: currency, amount: nil, isEditing: false)
        case .iconChipInput: input = .iconChipInput(chip: nil)
        case .binaryChoiceInput: input = .binaryChoiceInput(choice: nil)
        case .textFieldInput: input = .textFieldInput(value: nil, isEditing: false)
//        case .customInput(let content): input = .customInput(content: content)
        default: break
        }
    }
    
    func defocusInput() {
        switch input {
        case let .dateInput(selectedDate, before, after, _): input = .dateInput(selectedDate: selectedDate, before: before, after: after, isEditing: false)
        case let .currencyInput(currency, amount, _): input = .currencyInput(currency: currency, amount: amount, isEditing: false)
//        case .iconChipInput, .binaryChoiceInput: break
//        case .binaryChoiceInput: input = .binaryChoiceInput(choice: nil)
        case let .textFieldInput(value, _): input = .textFieldInput(value: value, isEditing: false)
            //        case .customInput(let content): input = .customInput(content: content)
        default: break
        }
#if os(iOS)
        Task.detached {
            await UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
#endif
    }
    
    func focusInput() {
        switch input {
        case let .dateInput(selectedDate, before, after, _): input = .dateInput(selectedDate: selectedDate, before: before, after: after, isEditing: true)
        case let .currencyInput(currency, amount, _): input = .currencyInput(currency: currency, amount: amount, isEditing: true)
            //        case .iconChipInput, .binaryChoiceInput: break
            //        case .binaryChoiceInput: input = .binaryChoiceInput(choice: nil)
        case let .textFieldInput(value, _): input = .textFieldInput(value: value, isEditing: true)
            //        case .customInput(let content): input = .customInput(content: content)
        default: break
        }
    }
    
    var inputIsNil: Bool {
        if isSkipped { false }
        else {
            switch input {
            case let .dateInput(selectedDate, _,_,isEditing): selectedDate == nil || isEditing
            case let .currencyInput(_, amount, isEditing): amount == nil || isEditing
            case let .iconChipInput(chip): chip == nil
            case let .binaryChoiceInput(choice): choice == nil
            case let .textFieldInput(value, isEditing): value == nil || isEditing
            case .customInput: true
            }
        }
    }

    public var iconChipInput: (any IconChipRepresentable)? {
        get { if case let .iconChipInput(chip) = input { chip } else { nil } }
        set { input = .iconChipInput(chip: newValue) }
    }
    
    public var iconChipInputBinding: Binding<(any IconChipRepresentable)?> {
        .init(get: { self.iconChipInput }, set: { self.iconChipInput = $0 })
    }
    
    public var binaryInput: (any BinaryInputRepresentable)? {
        get { if case let .binaryChoiceInput(choice) = input { choice } else { nil } }
        set { input = .binaryChoiceInput(choice: newValue) }
    }
    
    public var binaryInputBinding: Binding<(any BinaryInputRepresentable)?> {
        .init(get: { self.binaryInput }, set: { self.binaryInput = $0 })
    }
    
    public var dateInputSelectedDate: Date? {
        get { if case let .dateInput(selectedDate,_,_, _) = input { selectedDate } else { nil } }
        set {
            guard case let .dateInput(_, before, after, isEditing) = input else { return }
            input = .dateInput(selectedDate: newValue, before: before, after: after, isEditing: isEditing)
        }
    }
    
    public var dateInputSelectedDateBinding: Binding<Date?> {
        .init(get: { self.dateInputSelectedDate }, set: { self.dateInputSelectedDate = $0 })
    }
    
    public var dateInputIsEditing: Bool {
        get { if case let .dateInput(_, _,_,isEditing) = input { isEditing } else { false } }
        set {
            guard case let .dateInput(selectedDate, before, after, _) = input else { return }
            input = .dateInput(selectedDate: selectedDate, before: before, after: after, isEditing: newValue)
        }
    }
    
    public var dateInputIsEditingBinding: Binding<Bool> {
        .init(get: { self.dateInputIsEditing }, set: { self.dateInputIsEditing = $0 })
    }
    
    public var currencyInputAmount: Decimal? {
        get { if case let .currencyInput(_, amount, _) = input { amount } else { nil } }
        set {
            guard case let .currencyInput(currency, _, isEditing) = input else { return }
            input = .currencyInput(currency: currency, amount: newValue, isEditing: isEditing)
        }
    }
    
    public var currencyInputAmountBinding: Binding<Decimal?> {
        .init(get: { self.currencyInputAmount }, set: { self.currencyInputAmount = $0 })
    }
    
    public var currencyInputCurrency: InputCurrency {
        get { if case let .currencyInput(currency, _, _) = input { currency } else { .STERLING } }
        set {
            guard case let .currencyInput(_, amount, isEditing) = input else { return }
            input = .currencyInput(currency: newValue, amount: amount, isEditing: isEditing)
        }
    }
    
    var currencyInputCurrencyBinding: Binding<InputCurrency> {
        .init(get: { self.currencyInputCurrency }, set: { self.currencyInputCurrency = $0 })
    }
    
    var currencyInputIsEditing: Bool {
        get { if case let .currencyInput(_, _, isEditing) = input { isEditing } else { false } }
        set {
            guard case let .currencyInput(currency, amount, _) = input else { return }
            input = .currencyInput(currency: currency, amount: amount, isEditing: newValue)
        }
    }
    
    var currencyInputIsEditingBinding: Binding<Bool> {
        .init(get: { self.currencyInputIsEditing }, set: { self.currencyInputIsEditing = $0 })
    }
    
    var textFieldInputValue: String? {
        get { if case let .textFieldInput(value, _) = input { value } else { nil } }
        set {
            guard case let .textFieldInput(_, p1) = input else { return }
            input = .textFieldInput(value: newValue, isEditing: p1)
        }
    }
    
    var textFieldInputValueBinding: Binding<String?> {
        .init(get: { self.textFieldInputValue }, set: { self.textFieldInputValue = $0 })
    }
    
    var textFieldInputIsEditing: Bool {
        get { if case let .textFieldInput(_, isEditing) = input { isEditing } else { false } }
        set {
            guard case let .textFieldInput(p0, _) = input else { return }
            input = .textFieldInput(value: p0, isEditing: newValue)
        }
    }
    
    var textFieldInputIsEditingBinding: Binding<Bool> {
        .init(get: { self.textFieldInputIsEditing }, set: { self.textFieldInputIsEditing = $0 })
    }
    
    public init<Identifier: InteractionFlowElementIdentifiable>(
        isSkippable: Bool,
        inputType: InteractionFlowInputType,
        hintPretitle: String? = nil,
        hintTitle: String,
        hintText: String,
        id: Identifier,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool,
        onInputChange: @escaping (InteractionFlowInput) -> Void = { _ in }
    ) {
        self.isSkippable = isSkippable
        self.input = switch inputType {
        case .binaryChoice: .binaryChoiceInput(choice: nil)
        case .currency: .currencyInput(currency: .STERLING, amount: nil, isEditing: false)
        case .date: .dateInput(selectedDate: nil, before: nil, after: nil, isEditing: false)
        case .iconChip: .iconChipInput(chip: nil)
        case .textField: .textFieldInput(value: nil, isEditing: false)
        case .custom: .customInput
        }
        self.hintTitle = hintTitle
        self.hintPretitle = hintPretitle
        self.hintText = hintText
        self.id = id
        self.nextElementIdentifier = next
        self.condition = condition
        self.inputType = inputType
        self.onInputChange = onInputChange
//        self._inputType = nil
    }

    public static func binary<Identifier: InteractionFlowElementIdentifiable>(
        _ identifier: Identifier,
        choices: [any BinaryInputRepresentable],
        pretitle: String? = nil,
        title: String,
        text: String,
        skippable: Bool = false,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool
    ) -> InteractionFlowElement {
        InteractionFlowElement(
            isSkippable: skippable,
            inputType: .binaryChoice(choices: choices),
            hintPretitle: pretitle,
            hintTitle: title,
            hintText: text,
            id: identifier,
            next: next,
            condition: condition
        )
    }
    
    public static func custom<Identifier: InteractionFlowElementIdentifiable, V: View>(
        _ identifier: Identifier,
        viewType: V.Type,
        pretitle: String? = nil,
        title: String,
        text: String,
        skippable: Bool = false,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool,
        @ViewBuilder content: @escaping () -> V
    ) -> InteractionFlowElement {
        InteractionFlowElement(
            isSkippable: skippable,
            inputType: .custom(viewType: viewType, content: content()),
            hintPretitle: pretitle,
            hintTitle: title,
            hintText: text,
            id: identifier,
            next: next,
            condition: condition
        )
    }
    
    public static func iconChip<Identifier: InteractionFlowElementIdentifiable>(
        _ identifier: Identifier,
        allChips: [any IconChipRepresentable],
        pretitle: String? = nil,
        title: String,
        text: String,
        skippable: Bool = false,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool
    ) -> InteractionFlowElement {
        InteractionFlowElement(
            isSkippable: skippable,
            inputType: .iconChip(allChips: allChips),
            hintPretitle: pretitle,
            hintTitle: title,
            hintText: text,
            id: identifier,
            next: next,
            condition: condition
        )
    }
    
    public static func currency<Identifier: InteractionFlowElementIdentifiable>(
        _ identifier: Identifier,
        fieldLabel: String,
        pretitle: String? = nil,
        title: String,
        text: String,
        skippable: Bool = false,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool
    ) -> InteractionFlowElement {
        InteractionFlowElement(
            isSkippable: skippable,
            inputType: .currency(fieldLabel: fieldLabel),
            hintPretitle: pretitle,
            hintTitle: title,
            hintText: text,
            id: identifier,
            next: next,
            condition: condition
        )
    }
    
    public static func textField<Identifier: InteractionFlowElementIdentifiable>(
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
        condition: @escaping (InteractionFlowInput) -> Bool
    ) -> InteractionFlowElement {
        InteractionFlowElement(
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
            id: identifier,
            next: next,
            condition: condition
        )
    }
    
    public static func date<Identifier: InteractionFlowElementIdentifiable>(
        _ identifier: Identifier,
//        viewType: V.Type = EmptyView.self,
        fieldLabel: String,
        pretitle: String? = nil,
        title: String,
        text: String,
        skippable: Bool = false,
        before: Binding<Date?>,
        after: Binding<Date?>,
        next: @escaping (Bool) -> (next: Identifier, onSkip: Identifier),
        condition: @escaping (InteractionFlowInput) -> Bool
    ) -> InteractionFlowElement {
        InteractionFlowElement(
            isSkippable: skippable,
            inputType: .date(fieldLabel: fieldLabel, before: before, after: after),
            hintPretitle: pretitle,
            hintTitle: title,
            hintText: text,
            id: identifier,
            next: next,
            condition: condition
        )
    }
}

