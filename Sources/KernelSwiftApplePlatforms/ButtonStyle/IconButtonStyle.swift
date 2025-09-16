//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 05/03/2025.
//

import Foundation
import SwiftUI

extension ButtonStyle where Self == IconButtonStyle {
    public static func icon(_ iconName: String) -> IconButtonStyle { .init(iconName: iconName) }
}

public struct IconButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var iconName: String
    var backgroundMaterial: Material? = nil
    var backgroundColor: Color = Color.clear
    var color: Color = .accentColor
    var font: Font = .body
    var padding: EdgeInsets = .init(vertical: 5, horizontal: 5)
    var cornerRadius: CGFloat = 5
    var haptic: Bool = false
    var scaling: Bool = true
    var scalingAnchorPoint: UnitPoint = .center
    
    public func makeBody(configuration: Configuration) -> some View {
//        HStack {
            Image(systemName: iconName).font(font)
//        }
        .foregroundStyle(color)
        .padding(padding)
        .contentShape(Rectangle())
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
    }
    
    func generateHaptics(_ isPressed: Bool) {
        guard haptic && isPressed else { return }
        Haptics.selection()
    }
    
    public func iconName(_ iconName: String) -> Self {
        var style = self
        style.iconName = iconName
        return style
    }
    
    public func backgroundMaterial(_ newValue: Material?) -> Self {
        var style = self
        style.backgroundMaterial = newValue
        return style
    }
    
    public func backgroundColor(_ backgroundColor: Color) -> Self {
        var style = self
        style.backgroundColor = backgroundColor
        return style
    }
    
    public func color(_ color: Color) -> Self {
        var style = self
        style.color = color
        return style
    }
    
    public func font(_ font: Font) -> Self {
        var style = self
        style.font = font
        return style
    }
    
    public func padding(_ padding: EdgeInsets) -> Self {
        var style = self
        style.padding = padding
        return style
    }
    
    public func cornerRadius(_ newValue: CGFloat) -> Self {
        var style = self
        style.cornerRadius = newValue
        return style
    }
    
    public func haptic(_ newValue: Bool) -> Self {
        var style = self
        style.haptic = newValue
        return style
    }
    
    public func scaling(_ newValue: Bool) -> Self {
        var style = self
        style.scaling = newValue
        return style
    }
    
    public func scalingAnchorPoint(_ newValue: UnitPoint) -> Self {
        var style = self
        style.scalingAnchorPoint = newValue
        return style
    }
}
