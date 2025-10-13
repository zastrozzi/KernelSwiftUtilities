//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/08/2023.
//

import Foundation
import SwiftUI
import KernelSwiftCommon


@available(iOS 17.0, macOS 14.0, *)
public struct TextFlowInputView: View {
    @KernelDI.Injected(\.inputService) var inputService
    
    let label: String
    let placeholder: String?
    let contentType: KernelSwiftTextContentType?
    let keyboardType: KernelSwiftKeyboardType
    let formatter: Formatter?
    let allowed: CharacterSet?
    let disallowed: CharacterSet?
    
    let value: Binding<String?>
    @State private var isEditing: Bool = false
    @State private var valueWhileEditing: String = ""
    private var editingChanged: (Bool) -> Void
    @State private var canSubmit: Bool = false

    public init(
        _ label: String,
        value: Binding<String?>,
        placeholder: String? = nil,
        contentType: KernelSwiftTextContentType? = nil,
        keyboardType: KernelSwiftKeyboardType = .default,
        formatter: Formatter? = nil,
        withOnly allowed: CharacterSet? = nil,
        without disallowed: CharacterSet? = nil,
        editingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self.label = label
        self.placeholder = placeholder
        self.contentType = contentType
        self.keyboardType = keyboardType
        self.value = value
        self.editingChanged = editingChanged
        self.formatter = formatter
        self.allowed = allowed
        self.disallowed = disallowed
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label).font(.caption).fontWeight(.bold).foregroundStyle(Color.tertiaryLabel)
            HStack(alignment: .center, spacing: 1) {
                TextField(
                    inputPlaceholder,
                    text: .init(
                        get: { self.isEditing ? self.valueWhileEditing : self.formattedValue },
                        set: { self.updateValue(with: $0) }
                    ),
                    onEditingChanged: { isEditing in
                        self.isEditing = isEditing
                        self.valueWhileEditing = self.formattedValue
//                        updateInputCanSubmit()
                        editingChanged(isEditing)
                    }
                )
                .frame(maxWidth: .infinity)
                .interactiveDismissDisabled()
#if os(iOS)
                .keyboardType(keyboardType)
#endif
                .textContentType(contentType)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    var formattedValue: String {
        guard let value = self.value.wrappedValue else { return "" }
        guard let valueFormatter = self.formatter, let formatted = valueFormatter.string(for: value) else { return value }
        return formatted
    }
    
    func updateValue(with updateValue: String) {
        let stripped: String = if let allowed, let disallowed { updateValue.removingCharacters(notIn: allowed.subtracting(disallowed)) }
        else if let allowed { updateValue.removingCharacters(notIn: allowed) }
        else if let disallowed { updateValue.removingCharacters(in: disallowed) }
        else { updateValue }
        self.valueWhileEditing = stripped
        self.value.wrappedValue = stripped
        updateInputCanSubmit()
    }
    
    func updateInputCanSubmit() {
        
        let canSubmitChange = !self.valueWhileEditing.isEmpty
        if canSubmitChange != canSubmit {
            print("Update T")
            canSubmit = canSubmitChange
            inputService.setCurrentInputCanSubmit(canSubmit)
        }
    }
    
//    var inputCanSubmit: Bool { inputService.currentInputCanSubmit }
    
    var inputPlaceholder: String {
        if let placeholder { placeholder }
        else if let contentType, let contentTypePlaceholder = contentType.placeholderLabel { contentTypePlaceholder }
        else { label }
    }
}
