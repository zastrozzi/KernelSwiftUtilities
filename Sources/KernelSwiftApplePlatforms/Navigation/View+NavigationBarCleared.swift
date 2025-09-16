//
//  NavigationBarClearedModifier.swift
//  
//
//  Created by Jonathan Forbes on 01/09/2022.
//

import SwiftUI

#if os(iOS)
struct NavigationBarClearedModifier: ViewModifier {
    var condition: Bool
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
//            .navigationTitle("")
            .navigationBarTitleDisplayMode(condition ? .inline : .automatic)
            .navigationBarBackButtonHidden(condition)

//        .toolbar(.hidden, for: .navigationBar)
    }
}
#endif

#if os(macOS)
struct NavigationBarClearedModifier: ViewModifier {
    var condition: Bool
    
    func body(content: Content) -> some View {
        content
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
    }
}
#endif

@available(swift 5.7)
extension View {
    
    @available(iOS 14, *)
    @available(swift 5.7)
    public func navigationBarCleared(_ condition: Bool = true) -> some View {
        return ModifiedContent(content: self, modifier: NavigationBarClearedModifier(condition: condition))
    }
}
