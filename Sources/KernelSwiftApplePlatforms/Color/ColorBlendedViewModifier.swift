//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/08/2023.
//

import Foundation
import SwiftUI

extension View {
    public func colorSchemeBlended(
        _ styleLayer: KernelSwiftColorSchemeItem.StyleLayer,
        _ role: KernelSwiftColorSchemeItem.StyleRole = .primary,
        _ adjustment: KernelSwiftColorSchemeItem.StyleAdjustment = .lightness,
        color: Color,
        withGradient: Bool = false,
        amount: Int
    ) -> some View {
        modifier(ColorBlendedViewModifier(styleLayer: styleLayer, styleRole: role, styleAdjustment: adjustment, color: color, gradient: withGradient, amount: amount))
    }
    
    
}




public struct KernelSwiftColorSchemeItem {
    public var color: Color
    public var role: StyleRole
    public var adjustment: StyleAdjustment
    public var adjustmentAmount: Int
    public var addingGradient: Bool
    public var defaultOpacity: Bool
    
    public init(
        _ role: StyleRole,
        _ adjustment: StyleAdjustment,
        _ adjustmentAmount: Int = 0,
        color: Color,
        addingGradient: Bool = false,
        defaultOpacity: Bool = true
    ) {
        self.role = role
        self.adjustment = adjustment
        self.color = color
        self.addingGradient = addingGradient
        self.adjustmentAmount = adjustmentAmount
        self.defaultOpacity = defaultOpacity
    }
}

public struct ColorBlendedViewModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var styleLayer: KernelSwiftColorSchemeItem.StyleLayer
    var styleRole: KernelSwiftColorSchemeItem.StyleRole
    var styleAdjustment: KernelSwiftColorSchemeItem.StyleAdjustment
    var color: Color
    var amount: Int
    var gradient: Bool
    
    public init(
        styleLayer: KernelSwiftColorSchemeItem.StyleLayer,
        styleRole: KernelSwiftColorSchemeItem.StyleRole,
        styleAdjustment: KernelSwiftColorSchemeItem.StyleAdjustment,
        color: Color,
        gradient: Bool,
        amount: Int
    ) {
        self.styleLayer = styleLayer
        self.styleRole = styleRole
        self.styleAdjustment = styleAdjustment
        self.color = color
        self.amount = amount
        self.gradient = gradient
    }
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        switch styleLayer {
        case .foreground:
            content.foregroundStyle(roleAdjustedStyle)
        case .background:
            content.background(roleAdjustedStyle)
        case .tint:
            content.tint(roleAdjustedStyle)
        }
    }
    
    var adjustedStyle: Color {
        switch styleAdjustment {
        case .lightness:
            color.adjustHSLALightness(by: colorScheme == .light ? amount : amount * -1)
        case .brightness:
            color.adjustHSBABrightness(by: colorScheme == .light ? amount : amount * -1)
        case .rgba:
            color.adjustRGBA(by: colorScheme == .light ? .init(amount) : .init(amount * -1))
        case .hue:
            color.adjustHSBAHue(by: colorScheme == .light ? amount : amount * -1)
        }
    }
    
    var roleAdjustedStyle: AnyShapeStyle {
        if #available(iOS 17.0, macOS 14.0, *) {
            switch styleRole {
            case .primary: gradient ? .init(adjustedStyle.gradient) : .init(adjustedStyle)
            case .secondary: gradient ? .init(adjustedStyle.gradient.secondary) : .init(adjustedStyle.secondary)
            case .tertiary: gradient ? .init(adjustedStyle.gradient.tertiary) : .init(adjustedStyle.tertiary)
            case .quaternary: gradient ? .init(adjustedStyle.gradient.quaternary) : .init(adjustedStyle.quaternary)
            case .quinary: gradient ? .init(adjustedStyle.gradient.quinary) : .init(adjustedStyle.quinary)
            }
        } else {
            gradient ? .init(adjustedStyle.gradient) : .init(adjustedStyle)
        }
    }
}

extension KernelSwiftColorSchemeItem {
    public enum StyleLayer {
        case foreground
        case background
        case tint
//        case fill
    }
    
    public enum StyleAdjustment {
        case lightness
        case brightness
        case rgba
        case hue
    }
    
    public enum StyleRole {
        case primary
        case secondary
        case tertiary
        case quaternary
        case quinary
    }
}
