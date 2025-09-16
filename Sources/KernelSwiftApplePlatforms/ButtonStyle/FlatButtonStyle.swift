//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/01/2025.
//

import SwiftUI
import Foundation

extension ButtonStyle where Self == FlatButtonStyle {
    public static var flat: FlatButtonStyle { .init() }
}

public struct FlatButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    
    
    var leadingIconName: String = ""
    var trailingIconName: String = ""
    
    var backgroundMaterial: Material? = nil
    var backgroundColor: Color = .clear
    var color: Color = .accentColor
    var iconColor: Color? = nil
    var leadingIconColor: Color? = nil
    var trailingIconColor: Color? = nil
    
    var font: Font = .body
    var iconFont: Font? = nil
    var leadingIconFont: Font? = nil
    var trailingIconFont: Font? = nil
    var dynamicFontRange: ClosedRange<DynamicTypeSize> = (.xSmall)...(.xSmall)
    var padding: EdgeInsets = .init(vertical: 5, horizontal: 10)
    var cornerRadius: CGFloat = 5
    var fullWidth: Bool = false
    var spacing: CGFloat = 10
    var leadingInnerSpacing: Bool = false
    var trailingInnerSpacing: Bool = false
    var haptic: Bool = false
    var scaling: Bool = true
    var scalingAnchorPoint: UnitPoint = .center
    var fixedHorizontal: Bool = false
    var fixedVertical: Bool = false
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: spacing) {
            if !leadingIconName.isEmpty {
                Image(systemName: leadingIconName)
                    .font((leadingIconFont ?? iconFont ?? font))
                    .foregroundColor(leadingIconColor ?? iconColor ?? color)
                if leadingInnerSpacing { Spacer(minLength: 0) }
            }
            configuration.label.font(font).fixedFont(min: dynamicFontRange.lowerBound, max: dynamicFontRange.upperBound).foregroundColor(color)
            if !trailingIconName.isEmpty {
                if trailingInnerSpacing { Spacer(minLength: 0) }
                Image(systemName: trailingIconName)
                    .font((trailingIconFont ?? iconFont ?? font))
                    .foregroundColor(trailingIconColor ?? iconColor ?? color)
            }
        }
        
        .padding(padding)
        .frame(minWidth: fullWidth ? 0 : nil, maxWidth: fullWidth ? .infinity : nil)
        .opacity(isEnabled ? 1 : 0.5)
        .background {
            Group {
                backgroundColor.opacity(isEnabled ? 1 : 0.5).zIndex(3)
                if let backgroundMaterial { Rectangle().fill(backgroundMaterial).opacity(isEnabled ? 1 : 0.5).zIndex(2) }
//                Color.secondarySystemBackground.opacity(isEnabled ? 0 : 1).zIndex(1)
            }
        }
        
        .cornerRadius(cornerRadius)
        .scaleEffect(configuration.isPressed && scaling ? 0.93 : 1.0, anchor: scalingAnchorPoint)
        .contentShape(Rectangle())
        .animation(.interactiveSpring(), value: configuration.isPressed)
        .onChange(of: configuration.isPressed) { _, newValue in generateHaptics(newValue) }
        .fixedSize(horizontal: fixedHorizontal, vertical: fixedVertical)
        .allowsHitTesting(isEnabled)
    }
    
    func generateHaptics(_ isPressed: Bool) {
        guard haptic && isPressed else { return }
        Haptics.selection()
    }
    
    public func leadingIconName(_ newValue: String) -> FlatButtonStyle {
        var style = self
        style.leadingIconName = newValue
        return style
    }
    
    public func trailingIconName(_ newValue: String) -> FlatButtonStyle {
        var style = self
        style.trailingIconName = newValue
        return style
    }
    
    public func backgroundMaterial(_ newValue: Material?) -> FlatButtonStyle {
        var style = self
        style.backgroundMaterial = newValue
        return style
    }
    
    public func backgroundColor(_ newValue: Color) -> FlatButtonStyle {
        var style = self
        style.backgroundColor = newValue
        return style
    }
    
    public func color(_ newValue: Color) -> FlatButtonStyle {
        var style = self
        style.color = newValue
        return style
    }
    
    public func iconColor(_ newValue: Color?) -> FlatButtonStyle {
        var style = self
        style.iconColor = newValue
        return style
    }
    
    public func leadingIconColor(_ newValue: Color?) -> FlatButtonStyle {
        var style = self
        style.leadingIconColor = newValue
        return style
    }
    
    public func trailingIconColor(_ newValue: Color?) -> FlatButtonStyle {
        var style = self
        style.trailingIconColor = newValue
        return style
    }
    
    public func font(_ newValue: Font) -> FlatButtonStyle {
        var style = self
        style.font = newValue
        return style
    }
    
    public func iconFont(_ newValue: Font?) -> FlatButtonStyle {
        var style = self
        style.iconFont = newValue
        return style
    }
    
    public func leadingIconFont(_ newValue: Font?) -> FlatButtonStyle {
        var style = self
        style.leadingIconFont = newValue
        return style
    }
    
    public func trailingIconFont(_ newValue: Font?) -> FlatButtonStyle {
        var style = self
        style.trailingIconFont = newValue
        return style
    }
    
    public func dynamicFontRange(_ newValue: ClosedRange<DynamicTypeSize>) -> FlatButtonStyle {
        var style = self
        style.dynamicFontRange = newValue
        return style
    }
    
    public func padding(_ newValue: EdgeInsets) -> FlatButtonStyle {
        var style = self
        style.padding = newValue
        return style
    }
    
    public func cornerRadius(_ newValue: CGFloat) -> FlatButtonStyle {
        var style = self
        style.cornerRadius = newValue
        return style
    }
    
    public func fullWidth(_ newValue: Bool) -> FlatButtonStyle {
        var style = self
        style.fullWidth = newValue
        return style
    }
    
    public func spacing(_ newValue: CGFloat) -> FlatButtonStyle {
        var style = self
        style.spacing = newValue
        return style
    }
    
    public func leadingInnerSpacing(_ newValue: Bool) -> FlatButtonStyle {
        var style = self
        style.leadingInnerSpacing = newValue
        return style
    }
    
    public func trailingInnerSpacing(_ newValue: Bool) -> FlatButtonStyle {
        var style = self
        style.trailingInnerSpacing = newValue
        return style
    }
    
    public func haptic(_ newValue: Bool) -> FlatButtonStyle {
        var style = self
        style.haptic = newValue
        return style
    }
    
    public func scaling(_ newValue: Bool) -> FlatButtonStyle {
        var style = self
        style.scaling = newValue
        return style
    }
    
    public func scalingAnchorPoint(_ newValue: UnitPoint) -> FlatButtonStyle {
        var style = self
        style.scalingAnchorPoint = newValue
        return style
    }
    
    public func fixedSize(horizontal: Bool = true, vertical: Bool = true) -> FlatButtonStyle {
        var style = self
        style.fixedVertical = vertical
        style.fixedHorizontal = horizontal
        return style
    }
}
