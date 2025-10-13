//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/09/2023.
//

import Foundation
import SwiftUI
import Charts

extension View {
    public func environmentStyle(
        _ role: KernelSwiftColorSchemeItem.StyleRole,
        _ layer: KernelSwiftColorSchemeItem.StyleLayer = .foreground,
        defaultOpacity: Bool = true
    ) -> some View {
        ModifiedContent(content: self, modifier: EnvironmentStyleViewModifier(role: role, layer: layer, defaultOpacity: defaultOpacity))
    }
}

public struct EnvironmentStyleViewModifier: ViewModifier {
    @Environment(\.foregroundPrimary)       private var foregroundPrimary
    @Environment(\.foregroundSecondary)     private var foregroundSecondary
    @Environment(\.foregroundTertiary)      private var foregroundTertiary
    @Environment(\.foregroundQuaternary)    private var foregroundQuaternary
    @Environment(\.foregroundQuinary)       private var foregroundQuinary
    
    private var role: KernelSwiftColorSchemeItem.StyleRole
    private var layer: KernelSwiftColorSchemeItem.StyleLayer
    private var defaultOpacity: Bool
    
    public init(role: KernelSwiftColorSchemeItem.StyleRole, layer: KernelSwiftColorSchemeItem.StyleLayer, defaultOpacity: Bool = true) {
        self.role = role
        self.layer = layer
        self.defaultOpacity = defaultOpacity
    }
    
    public func body(content: Content) -> some View {
        switch layer {
        case .foreground:
            if #available(iOS 17.0, macOS 14.0, *), defaultOpacity {
                switch role {
                case .primary:
                    content.foregroundStyle(foregroundPrimary)
                case .secondary:
                    content.foregroundStyle(foregroundSecondary.secondary)
                case .tertiary:
                    content.foregroundStyle(foregroundTertiary.tertiary)
                case .quaternary:
                    content.foregroundStyle(foregroundQuaternary.quaternary)
                case .quinary:
                    content.foregroundStyle(foregroundQuinary.quinary)
                }
            } else {
                switch role {
                case .primary:
                    content.foregroundStyle(foregroundPrimary)
                case .secondary:
                    content.foregroundStyle(foregroundSecondary)
                case .tertiary:
                    content.foregroundStyle(foregroundTertiary)
                case .quaternary:
                    content.foregroundStyle(foregroundQuaternary)
                case .quinary:
                    content.foregroundStyle(foregroundQuinary)
                }
            }
        case .background:
            if #available(iOS 17.0, macOS 14.0, *), defaultOpacity {
                switch role {
                case .primary:
                    content.background(foregroundPrimary)
                case .secondary:
                    content.background(foregroundSecondary.secondary)
                case .tertiary:
                    content.background(foregroundTertiary.tertiary)
                case .quaternary:
                    content.background(foregroundQuaternary.quaternary)
                case .quinary:
                    content.background(foregroundQuinary.quinary)
                }
            } else {
                switch role {
                case .primary:
                    content.background(foregroundPrimary)
                case .secondary:
                    content.background(foregroundSecondary)
                case .tertiary:
                    content.background(foregroundTertiary)
                case .quaternary:
                    content.background(foregroundQuaternary)
                case .quinary:
                    content.background(foregroundQuinary)
                }
            }
        case .tint:
            content
        }
    }
}
