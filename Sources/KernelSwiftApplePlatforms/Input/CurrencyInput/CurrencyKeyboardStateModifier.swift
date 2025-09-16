//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/08/2023.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

@available(iOS 17.0, macOS 14.0, *)
extension View {
    public func currencyKeyboardToolbarState(_ showToolbar: Binding<Bool>, currentSelection: Binding<InputCurrency>) -> some View {
        modifier(CurrencyKeyboardStateModifier(showToolbar: showToolbar, currentSelection: currentSelection))
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct CurrencyKeyboardStateModifier: ViewModifier {
    @Binding var showToolbar: Bool
    @Binding var currentSelection: InputCurrency
    
    @KernelDI.Injected(\.inputService) var inputService: InputService
    
    init(showToolbar: Binding<Bool>, currentSelection: Binding<InputCurrency>) {
        self._showToolbar = showToolbar
        self._currentSelection = currentSelection
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: showToolbar) { [weak inputService] old, new in
                inputService?.hasCurrencyKeyboard = new
                if new { inputService?.setCurrencyKeyboardSelection(currentSelection) }
            }
            .onChange(of: inputService.currencyKeyboardSelection) { oldValue, newValue in
                if showToolbar { currentSelection = newValue }
            }
    }
}

