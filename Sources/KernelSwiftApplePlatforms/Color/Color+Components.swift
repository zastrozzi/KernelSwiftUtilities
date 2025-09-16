//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

extension Color {
    public func componentsRGBA() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        #if os(iOS)
        guard BKNativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else { return (0, 0, 0, 0) }
        #endif
        return (r, g, b, a)
    }
    
    public func componentsHSBA() -> (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        #if os(iOS)
        guard BKNativeColor(self).getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return (0, 0, 0, 0) }
        #endif
        return (h, s, b, a)
    }
    
    public func componentsHSLA() -> (h: CGFloat, s: CGFloat, l: CGFloat, a: CGFloat) {
        let (_h, _s, _b, _a) = componentsHSBA()
        let l = _b - (_b * (_s / 2))
        let s = (l == 0 || l == 1) ? 0 : (_b - l) / min(l, 1 - l)
        return (h: _h, s: s, l: l, a: _a)
    }
    
    public init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
        let b = lightness + saturation * min(lightness, 1 - lightness)
        let s = b == 0 ? 0 : 2 - 2 * (lightness / b)
        self = Color(
            hue: Double(hue),
            saturation: Double(s),
            brightness: Double(b),
            opacity: Double(alpha)
        )
    }
}

extension Color {
    public static func rgb(_ r255: Int, _ g255: Int, _ b255: Int) -> Self {
        let r = min(255, max(0, r255))
        let g = min(255, max(0, g255))
        let b = min(255, max(0, b255))
        //
        return self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}
