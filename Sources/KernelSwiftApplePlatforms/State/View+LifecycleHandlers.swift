//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/10/2025.
//

import Foundation
import SwiftUI

public struct OnAppearDisappearViewLifecycleModifier: ViewModifier {
    @Binding var hasAppeared: Bool
    let onAppear: () -> Void
    let onDisappear: () -> Void
    
    public init(
        hasAppeared: Binding<Bool>,
        onAppear: @escaping () -> Void,
        onDisappear: @escaping () -> Void
    ) {
        _hasAppeared = hasAppeared
        self.onAppear = onAppear
        self.onDisappear = onDisappear
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                onAppear()
            }
            .onDisappear {
                guard hasAppeared else { return }
                hasAppeared = false
                onDisappear()
            }
    }
}

extension View {
    public func withOnAppearDisappear(
        hasAppeared: Binding<Bool>,
        onAppear: @escaping () -> Void = {},
        onDisappear: @escaping () -> Void = {}
    ) -> some View {
        modifier(
            OnAppearDisappearViewLifecycleModifier(
                hasAppeared: hasAppeared,
                onAppear: onAppear,
                onDisappear: onDisappear
            )
        )
    }
}
