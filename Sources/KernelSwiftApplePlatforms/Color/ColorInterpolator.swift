//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/11/2025.
//

import Foundation
import SwiftUI

public enum ColorInterpolator {
    public static func interpolate(from a: Color, to b: Color, t: CGFloat) -> Color? {
        guard let ca = rgba(a), let cb = rgba(b) else { return nil }
        let u = t.clamped(to: 0...1)
        let r = ca.r + (cb.r - ca.r) * u
        let g = ca.g + (cb.g - ca.g) * u
        let b = ca.b + (cb.b - ca.b) * u
        let a = ca.a + (cb.a - ca.a) * u
        return Color(red: r, green: g, blue: b, opacity: a)
    }
    
    public static func rgba(_ color: Color) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
#if canImport(UIKit)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
#elseif canImport(AppKit)
        guard let converted = NSColor(color).usingColorSpace(.deviceRGB) else { return nil }
        return (converted.redComponent, converted.greenComponent, converted.blueComponent, converted.alphaComponent)
#else
        return nil
#endif
    }
}

