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
    public func currencyKeyboardToolbar(onCondition: Bool = true) -> some View {
        modifier(CurrencyKeyboardModifier.shared)
    }
    
}
@available(iOS 17.0, macOS 14.0, *)
struct CurrencyKeyboardModifier: ViewModifier {
    static var shared: Self = .init(onCondition: true)
//    @Injected(\.inputService) var inputService: InputService
    @InjectedBinding(\.inputService.currencyKeyboardSelection) var currencySelection
    @InjectedBinding(\.inputService.hasCurrencyKeyboard) var hasCurrencyKeyboard
    var onCondition: Bool
//    @FocusState var focused: Bool
    //    @Binding var selectedCurrency: InputCurrency
    
//    @ViewBuilder
    func body(content: Content) -> some View {
        content.toolbar {
            
            ToolbarItemGroup(placement: .keyboard) {
                if hasCurrencyKeyboard {
                    HStack(spacing: 0) {
                        Rectangle().frame(width: 1).foregroundStyle(.gray).padding(.vertical, 3)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(InputCurrency.allCases) { currency in
                                    Button(action: {
                                        withAnimation(.bouncy) {
                                            currencySelection = currency
                                        }
                                    }) {
                                        Image(systemName: currency.image)
                                            .symbolRenderingMode(.hierarchical)
                                            .frame(height: 18)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .opacity(currencySelection.id == currency.id ? 1 : 0.3)
                                    .frame(maxHeight: .infinity)
                                    .scaleEffect(currencySelection.id == currency.id ? 1 : 0.95)
                                    //                            .animation(.spring(), value: inputService.selectedCurrency.id == currency.id)
                                    .font(.system(size: 16)).fontWeight(.bold)
                                }
                            }.padding(.horizontal, 10)
                        }.scrollIndicators(.hidden)
                        Rectangle().frame(width: 1).foregroundStyle(.gray).padding(.vertical, 3)
                        Button("Done") {
                            //#if os(iOS)
                            //                    self.buttons.forceHideKeyboard()
                            //#endif
                            //                        resignKeyboard()
                            withAnimation(.smooth) { resignKeyboard() }
                        }.padding(.leading, 5).font(.system(size: 18))
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    //
    //    @ToolbarContentBuilder func toolbar() -> some ToolbarContent {
    //
    //
    //    }
    //
    public func resignKeyboard() {
#if os(iOS)
        Task.detached {
            await UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
#endif
        
    }
}

