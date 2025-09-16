//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/08/2023.
//

import Foundation
import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
public struct CurrencyFieldActionRow: View {
    @Binding var value: Decimal?
    var selectedCurrency: InputCurrency
    var actions: [CurrencyFieldAction]
    var tintColor: Color
    @State var committedActions: [CurrencyFieldAction] = []
    
    public init(value: Binding<Decimal?>, selectedCurrency: InputCurrency, tintColor: Color, actions: [CurrencyFieldAction] = [.ADD_1, .ADD_10, .ADD_25, .ADD_50]) {
        self._value = value
        self.selectedCurrency = selectedCurrency
        self.actions = actions
        self.tintColor = tintColor
    }
    
    public var body: some View {
        ScrollView(.horizontal) {
            HStack {
                if canUndo {
                    Button(action: undoAction) {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(tintColor)
                    }
                    .font(.title2)
                    .buttonStyle(.plain)
                    .transition(.offset(x: -50).combined(with: .opacity))
                }
                ForEach(actions, id: \.identifier) { action in
                    Button(action: { updateValue(action) }) {
                        HStack(spacing: 0) {
                            Image(systemName: "plus")
                                .symbolRenderingMode(.hierarchical)
                                .imageScale(.small)
                                
                                .opacity(0.4)
                            Image(systemName: selectedCurrency.image)
                                .symbolRenderingMode(.hierarchical)
                                .imageScale(.small)
                                .fontWeight(.bold)
                            Text(action.addAmount.compactCurrencyFormattedNoSymbol).fontWeight(.bold)
                        }
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(tintColor)
//                    .scaleEffect(selectedCurrency.id == currency.id ? 1 : 0.95)
//                    .animation(.spring(), value: selectedCurrency.id == currency.id)
//                    .font(.system(size: 16).bold())
                }
            }.padding(.horizontal)
        }.scrollIndicators(.hidden)
    }
    
    func updateValue(_ action: CurrencyFieldAction) {
        withAnimation(.bouncy) {
            if let oldValue = value { value = oldValue + action.addAmount }
            else { value = action.addAmount }
            committedActions.append(action)
        }
    }
    
    func undoAction() {
        withAnimation(.bouncy) {
            if let lastAction = committedActions.last {
                if let oldValue = value { value = oldValue - lastAction.addAmount }
                committedActions.removeLast()
            }
        }
    }
    
    var canUndo: Bool { !committedActions.isEmpty }
}

//@available(iOS 17.0, macOS 14.0, *)
//#Preview {
//    MainActor.assumeIsolated {
//        var value: Decimal? = 10
//        return VStack {
//            Text((value ?? 0).currencyFormattedNoSymbol)
//            CurrencyFieldActionRow(value: .init(get: { value }, set: { value = $0 }), selectedCurrency: .DOLLAR, tintColor: .blue)
//        }
//    }
//}
