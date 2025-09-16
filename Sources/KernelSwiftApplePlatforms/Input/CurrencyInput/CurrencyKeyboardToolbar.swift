//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/08/2023.
//

import Foundation
import SwiftUI


public struct CurrencyKeyboardToolbar: ToolbarContent {
    var placement: ToolbarItemPlacement
    @Binding var selectedCurrency: InputCurrency
    var doneClosure: () -> Void
    
    public init(placement: ToolbarItemPlacement = .keyboard, selectedCurrency: Binding<InputCurrency>, doneClosure: @escaping () -> Void) {
        self.placement = placement
        self._selectedCurrency = selectedCurrency
        self.doneClosure = doneClosure
    }
    
    @ToolbarContentBuilder public var body: some ToolbarContent {
        ToolbarItem(placement: .keyboard) {
            HStack(spacing: 0) {
                
                Rectangle().frame(width: 1).foregroundStyle(.gray).padding(.vertical, 3)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(InputCurrency.allCases) { currency in
                            Button(action: { selectedCurrency = currency }) {
                                Image(systemName: currency.image)
                                    .symbolRenderingMode(.hierarchical)
                                    .frame(height: 18)
                                
                            }
                            .buttonStyle(.borderedProminent)
                            .opacity(selectedCurrency.id == currency.id ? 1 : 0.3)
                            .frame(maxHeight: .infinity)
                            .scaleEffect(selectedCurrency.id == currency.id ? 1 : 0.95)
                            .animation(.spring(), value: selectedCurrency.id == currency.id)
                            .font(.system(size: 16)).fontWeight(.bold)
                        }
                    }.padding(.horizontal, 10)
                }.scrollIndicators(.hidden)
                Rectangle().frame(width: 1).foregroundStyle(.gray).padding(.vertical, 3)
                Button("Done") {
//#if os(iOS)
//                    self.buttons.forceHideKeyboard()
//#endif
                    doneClosure()
                }.padding(.leading, 5).font(.system(size: 18))
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        
    }
//    
//    var buttons: some View {
//        
//        
//    }
}
