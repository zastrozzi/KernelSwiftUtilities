//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/08/2023.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

@available(iOS 17.0, macOS 14.0, *)
public struct CurrencyField<Toolbar: ToolbarContent>: View {
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    let currencyEditingFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.alwaysShowsDecimalSeparator = true
        return formatter
    }()
    
    let title: String
    let value: Binding<Decimal?>
    var toolbarContent: () -> Toolbar
    var hasToolbar: Bool
    
    @State private var valueWhileEditing: String = ""
    @State private var isEditing: Bool = false
    @Binding var selectedCurrency: InputCurrency
//    var isFocused: FocusState<Bool>.Binding
    private var editingChanged: (Bool) -> Void
    @KernelDI.Injected(\.inputService) private var inputService: InputService
//    @FocusState private var globalFocused: Bool
    @State private var canSubmit: Bool = false
    
//    @Environment(\.dismiss) private var dismiss
    
    public init(
        _ title: String,
        value: Binding<Decimal?>,
        currency: Binding<InputCurrency>,
        editingChanged: @escaping (Bool) -> Void = { _ in },
        @ToolbarContentBuilder toolbarContent: @escaping () -> Toolbar
    ) {
        self.title = title
        self.value = value
        self._selectedCurrency = currency
//        self.isFocused = isFocused
        self.editingChanged = editingChanged
        self.toolbarContent = toolbarContent
        self.hasToolbar = true
    }
    
    public init(
        _ title: String,
        value: Binding<Decimal?>,
        currency: Binding<InputCurrency>,
        editingChanged: @escaping (Bool) -> Void = { _ in },
        _ emptyToolbarContent: Toolbar = ToolbarItem(content: EmptyView.init)
    ) {
        self.title = title
        self.value = value
        self._selectedCurrency = currency
        //        self.isFocused = isFocused
        self.editingChanged = editingChanged
        self.toolbarContent = { emptyToolbarContent }
        self.hasToolbar = false
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title).font(.caption).fontWeight(.bold).foregroundStyle(Color.tertiaryLabel)
            HStack(alignment: .center, spacing: 1) {
                
                Image(systemName: selectedCurrency.image)
                    .foregroundStyle(.secondary)
                    .frame(maxHeight: .infinity)
                    .scaleEffect(0.75)
                TextField(
                    placeholderForCurrentSeparator,
                    text: .init(
                        get: { self.isEditing ? self.valueWhileEditing : self.formattedValue },
                        set: { newValue in
                            let stripped = newValue.filter { currentNumericsAndSeparator.contains($0) }
                            if stripped.filter({ $0 == currentDecimalSeparator }).count <= 1 {
                                self.valueWhileEditing = stripped
                                self.updateValue(with: stripped)
                            } else {
                                let newValue = String(stripped.dropLast(stripped.count - self.valueWhileEditing.count))
                                self.valueWhileEditing = newValue
                                self.updateValue(with: newValue)
                            }
                        }
                    ),
                    onEditingChanged: { isEditing in
                        self.isEditing = isEditing
                        self.valueWhileEditing = self.formattedValue
//                        updateInputCanSubmit()
                        editingChanged(isEditing)
                    }
                )
                
//                .focused($globalFocused)
                .frame(maxWidth: .infinity)
                .if(hasToolbar, transform: { textField in
                    textField.toolbar(content: toolbarContent)
                })
//                .interactiveDismissDisabled()
//                .currencyKeyboardToolbar(onCondition: isEditing)
                .currencyKeyboardToolbarState($isEditing, currentSelection: $selectedCurrency)
//                .onAppear { updateInputCanSubmit() }
#if os(iOS)
                .keyboardType(.decimalPad)
                
#endif
                
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        
    }
    
    var formattedValue: String {
        guard let value = self.value.wrappedValue else { return "" }
        let formatter = currencyEditingFormatter
        guard let formatted = formatter.string(for: value) else { return "" }
        return formatted
    }
    
    func updateValue(with updateValue: String) {
        let newValue: NSNumber? = currencyEditingFormatter.number(from: updateValue)
        let newString: String? = currencyEditingFormatter.string(for: newValue)
        if let newString = newString {
            value.wrappedValue = currencyEditingFormatter.number(from: newString)?.decimalValue
        } else {
            value.wrappedValue = nil
        }
        updateInputCanSubmit()
    }
    
    func updateInputCanSubmit() {
        let canSubmitChange = !(self.value.wrappedValue?.isZero ?? true)
        if canSubmitChange != canSubmit {
            print("update in curr")
            canSubmit = canSubmitChange
            inputService.setCurrentInputCanSubmit(canSubmit)
        }
    }
    
    var currentDecimalSeparator: Character {
        switch Locale.autoupdatingCurrent.decimalSeparator {
        case ".": .init(".")
        case ",": .init(",")
        default: .init(".")
        }
    }
    
    var placeholderForCurrentSeparator: String {
        switch Locale.autoupdatingCurrent.decimalSeparator {
        case ".": .init("0.00")
        case ",": .init("0,00")
        default: .init("0.00")
        }
    }
    
    var currentNumericsAndSeparator: String {
        switch Locale.autoupdatingCurrent.decimalSeparator {
        case ".": .init("0123456789.")
        case ",": .init("0123456789,")
        default: .init("0123456789.")
        }
    }
}


//
//#Preview {
//    #if os(iOS)
//    CurrencyKeyboardToolbar(placement: .bottomBar, selectedCurrency: .constant(.STERLING)) {}.buttons.frame(height: 40)
//    #else
//    CurrencyKeyboardToolbar(placement: .automatic, selectedCurrency: .constant(.STERLING)) {}.buttons.frame(height: 40)
//    #endif
//}

//@available(iOS 17.0, macOS 14.0, *)
//#Preview {
//    @State var amount: Decimal?
//    @State var currency: InputCurrency = .STERLING
////    @FocusState var isFocused: Bool
//    return CurrencyField("0.00", value: $amount, currency: $currency)
//}
