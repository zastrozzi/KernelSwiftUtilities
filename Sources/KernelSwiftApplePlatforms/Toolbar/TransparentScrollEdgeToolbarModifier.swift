//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import Foundation
import SwiftUI

public struct TransparentScrollEdgeToolbarModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            Self.setTransparentScrollEdge()
        }
    }
    
    @MainActor
    public static func setTransparentScrollEdge() {
        #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
        let translucentAppearance = UIToolbarAppearance()
        translucentAppearance.configureWithTransparentBackground()
        translucentAppearance.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        translucentAppearance.backgroundEffect = UIBlurEffect(style: .regular)
        UIToolbar.appearance().standardAppearance = translucentAppearance
        #endif
    }
}

extension View {
    public func transparentScrollEdgeToolbar() -> some View {
        return self.modifier(TransparentScrollEdgeToolbarModifier())
    }
}

