//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI
import OSLog
import KernelSwiftCommon

@available(iOS 17.0, macOS 14.0, *)
public struct InteractionFlowElementView: View {
    var element: InteractionFlowElement
//    @Injected(\.interactionFlowService) var interactionFlowService: InteractionFlowService
//    @FocusState var isFocused: Bool
//    
//    public init(element: InteractionFlowElement) {
//        self.element = element
//    }
    
    func progressFlow() {
        withAnimation(.bouncy) { [weak element] in
            if let next = element?.getNextIdentifier(skipping: false) {
                KernelDI.inject(\.interactionFlowService).progressFlow(next)
            }
        }
    }
    
    func regressFlow() {
        withAnimation(.bouncy) { [weak element] in
            if let elementId = element?.id {
                KernelDI.inject(\.interactionFlowService).regressFlow(to: elementId)
            }
        }
    }
    
    func updateInputFocus(isEditing: Bool) {
        withAnimation(.smooth) {
            if isEditing {
                element.focusInput()
            } else {
                element.defocusInput()
                KernelDI.inject(\.inputService).resetCanSubmit()
            }
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) { [weak element] in
            if !(element?.isSkipped ?? false) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    if (element?.showHint ?? false) {
                        VStack(alignment: .leading) {
                            if let pretitle = element?.hintPretitle {
                                Text(pretitle).font(.headline).foregroundStyle(.secondary)
                            }
                            if let title = element?.hintTitle {
                                HStack(alignment: .top) {
                                    Text(title).font(.title2).fontWeight(.bold)
                                    Spacer()
                                    
                                }
                            }
                            if let text = element?.hintText {
                                Text(text)
                            }
                        }
                        .padding()
                        .background(Color.quaternarySystemFill)
                        .clipShape(.rect(cornerRadius: 20, style: .continuous))
                        .padding(.horizontal)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .top),
                                removal: .move(edge: .bottom)
                            ).combined(with: .opacity)
                        )
                        .padding(.vertical, 5)
                    } else { EmptyView() }
                    if (element?.showInput ?? false) {
                        switch element?.input {
                        case .none: EmptyView()
                        case .textFieldInput: textFieldInputView()
                        case .dateInput: dateInputView()
                        case .currencyInput: currencyInputView()
                        case .iconChipInput: iconChipInputView()
                        case .binaryChoiceInput: binaryChoiceInputView()
                        case .customInput: customInputView()
                        }
                    } else { EmptyView() }
                }.padding(.top, 5)
            }
        }
    }
    
    @ViewBuilder 
    func binaryChoiceInputView() -> some View {
//        @State var binaryInput = element.binaryInput
        if case let .binaryChoice(choices) = element.inputType {
            BinaryInputView(options: choices, selectedOption: element.binaryInputBinding) { hasSelected in
                if hasSelected { progressFlow() }
                else { regressFlow() }
            }
        }
    }
    
    @ViewBuilder 
    func textFieldInputView() -> some View {
//        @State var textFieldInputValue = element.textFieldInputValue
        if case let .textField(fl, ph, ct, kt, a, d, f) = element.inputType {
            TextFlowInputView(
                fl,
                value: element.textFieldInputValueBinding,
                placeholder: ph,
                contentType: ct,
                keyboardType: kt,
                formatter: f,
                withOnly: a,
                without: d
            )
                { [weak element] isEditing in
                    updateInputFocus(isEditing: isEditing)
                    if !isEditing && element?.textFieldInputValue != nil && !(element?.textFieldInputValue?.isEmpty ?? true) {
                        progressFlow()
                    }
                }
            
            .font(.title3).textFieldStyle(.plain)
            .padding(.init(vertical: 10, horizontal: 15))
            .background(Color.quaternarySystemFill).clipShape(.rect(cornerRadius: 20, style: .continuous))
            .padding(.horizontal)
            .transition(
                .asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                )
            )
        }
    }
    
    @ViewBuilder
    func dateInputView() -> some View {
        if case let .date(fieldLabel,before,after) = element.inputType {
            CalendarDateInputView(
                label: fieldLabel, tintColor: .orange,
                selectedDate: element.dateInputSelectedDateBinding,
                before: before,
                after: after,
                isEditing: element.dateInputIsEditingBinding
            ) { [weak element] isEditing in
                print("editing change", fieldLabel, isEditing)
                if let input = element?.input {
                    element?.onInputChange(input)
                }
                updateInputFocus(isEditing: isEditing)
                if !isEditing && element?.dateInputSelectedDate != nil { progressFlow() }
            }
        }
    }
    
    @ViewBuilder
    func currencyInputView() -> some View {
        if case let .currency(fieldLabel) = element.inputType {
            CurrencyField(
                fieldLabel,
                value: element.currencyInputAmountBinding,
                currency: element.currencyInputCurrencyBinding,
                editingChanged: { [weak element] isEditing in
                    updateInputFocus(isEditing: isEditing)
                    if !isEditing && element?.currencyInputAmount != nil { progressFlow() }
                }
            )
            
            .font(.title2).fontDesign(.rounded)
            .textFieldStyle(.plain)
            .padding(.init(vertical: 10, horizontal: 15))
            .background(Color.quaternarySystemFill)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
            .padding(.horizontal)
            .transition(
                .asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                )
            )
        }
    }
    
    @ViewBuilder
    func iconChipInputView() -> some View {
        if case let .iconChip(allChips) = element.inputType {
            HStack(spacing: 0) {
                IconChipInputView(allChips: allChips, selectedChip: element.iconChipInputBinding) { selecting in
                    InteractionFlows.logger.debug("selecting, \(selecting)")
                    if selecting { progressFlow() }
                    else { regressFlow() }
                }
                .transition(.offset(y: 50).combined(with: .opacity)).padding(.horizontal)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func customInputView() -> some View {
        if case let .custom(_, content) = element.inputType {
            AnyView(content)
        }
    }
}
