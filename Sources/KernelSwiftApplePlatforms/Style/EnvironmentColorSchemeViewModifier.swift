//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/09/2023.
//

import Foundation
import SwiftUI

extension View {
    
    public func environmentColorScheme(_ items: KernelSwiftColorSchemeItem...) -> some View {
        ModifiedContent(content: self, modifier: EnvironmentColorSchemeViewModifier(items: items))
    }
}

public struct EnvironmentColorSchemeViewModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var schemeItems: [KernelSwiftColorSchemeItem]
    
    public init(items: [KernelSwiftColorSchemeItem]) {
        self.schemeItems = items
    }
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        withPrimary(withSecondary(withTertiary(withQuaternary(withQuinary(content)))))
    }
    
    @ViewBuilder
    public func withPrimary(_ content: some View) -> some View {
        if let primaryStyle {
            content.environment(\.foregroundPrimary, primaryStyle)
        } else {
            content
        }
    }
    
    @ViewBuilder
    public func withSecondary(_ content: some View) -> some View {
        if let secondaryStyle {
            content.environment(\.foregroundSecondary, secondaryStyle)
        } else {
            content
        }
    }
    
    @ViewBuilder
    public func withTertiary(_ content: some View) -> some View {
        if let tertiaryStyle {
            content.environment(\.foregroundTertiary, tertiaryStyle)
        } else {
            content
        }
    }
    
    @ViewBuilder
    public func withQuaternary(_ content: some View) -> some View {
        if let quaternaryStyle {
            content.environment(\.foregroundQuaternary, quaternaryStyle)
        } else {
            content
        }
    }
    
    @ViewBuilder
    public func withQuinary(_ content: some View) -> some View {
        if let quinaryStyle {
            content.environment(\.foregroundQuinary, quinaryStyle)
        } else {
            content
        }
    }
    
    var primaryStyle: AnyShapeStyle? {
        guard let schemeItem = schemeItems.first(where: { $0.role == .primary }) else { return nil }
        let adjustedColor: Color = switch schemeItem.adjustment {
        case .lightness:
            schemeItem.color.adjustHSLALightness(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        case .brightness:
            schemeItem.color.adjustHSBABrightness(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        case .rgba:
            schemeItem.color.adjustRGBA(by: colorScheme == .light ? .init(schemeItem.adjustmentAmount) : .init(schemeItem.adjustmentAmount * -1))
        case .hue:
            schemeItem.color.adjustHSBAHue(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        }
        if schemeItem.addingGradient { return .init(adjustedColor.gradient) }
        else { return .init(adjustedColor) }
    }
    
    var secondaryStyle: AnyShapeStyle? {
        guard let schemeItem = schemeItems.first(where: { $0.role == .secondary }) else { return nil }
        let adjustedColor: Color = switch schemeItem.adjustment {
        case .lightness:
            schemeItem.color.adjustHSLALightness(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        case .brightness:
            schemeItem.color.adjustHSBABrightness(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        case .rgba:
            schemeItem.color.adjustRGBA(by: colorScheme == .light ? .init(schemeItem.adjustmentAmount) : .init(schemeItem.adjustmentAmount * -1))
        case .hue:
            schemeItem.color.adjustHSBAHue(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        }
        if schemeItem.addingGradient { return .init(adjustedColor.gradient) }
        else { return .init(adjustedColor) }
    }
    
    var tertiaryStyle: AnyShapeStyle? {
        guard let schemeItem = schemeItems.first(where: { $0.role == .tertiary }) else { return nil }
        let adjustedColor: Color = switch schemeItem.adjustment {
        case .lightness:
            schemeItem.color.adjustHSLALightness(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        case .brightness:
            schemeItem.color.adjustHSBABrightness(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        case .rgba:
            schemeItem.color.adjustRGBA(by: colorScheme == .light ? .init(schemeItem.adjustmentAmount) : .init(schemeItem.adjustmentAmount * -1))
        case .hue:
            schemeItem.color.adjustHSBAHue(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        }
        if schemeItem.addingGradient { return .init(adjustedColor.gradient) }
        else { return .init(adjustedColor) }
    }
    
    var quaternaryStyle: AnyShapeStyle? {
        guard let schemeItem = schemeItems.first(where: { $0.role == .quaternary }) else { return nil }
        let adjustedColor: Color = switch schemeItem.adjustment {
        case .lightness:
            schemeItem.color.adjustHSLALightness(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        case .brightness:
            schemeItem.color.adjustHSBABrightness(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        case .rgba:
            schemeItem.color.adjustRGBA(by: colorScheme == .light ? .init(schemeItem.adjustmentAmount) : .init(schemeItem.adjustmentAmount * -1))
        case .hue:
            schemeItem.color.adjustHSBAHue(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        }
        
        if schemeItem.addingGradient { return .init(adjustedColor.gradient) }
        else { return .init(adjustedColor) }
    }
    
    var quinaryStyle: AnyShapeStyle? {
        guard let schemeItem = schemeItems.first(where: { $0.role == .quinary }) else { return nil }
        let adjustedColor: Color = switch schemeItem.adjustment {
        case .lightness:
            schemeItem.color.adjustHSLALightness(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        case .brightness:
            schemeItem.color.adjustHSBABrightness(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        case .rgba:
            schemeItem.color.adjustRGBA(by: colorScheme == .light ? .init(schemeItem.adjustmentAmount) : .init(schemeItem.adjustmentAmount * -1))
        case .hue:
            schemeItem.color.adjustHSBAHue(by: colorScheme == .light ? schemeItem.adjustmentAmount : schemeItem.adjustmentAmount * -1)
        }
        if schemeItem.addingGradient { return .init(adjustedColor.gradient) }
        else { return .init(adjustedColor) }
    }
}

