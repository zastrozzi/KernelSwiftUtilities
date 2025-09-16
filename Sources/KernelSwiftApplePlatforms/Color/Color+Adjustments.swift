//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

extension Color {
    public func adjustRGBA(by p: CGFloat = 30.0) -> Color {
        guard p < 100 && p > -100 else { return self }
        let rgba = componentsRGBA()
        return Color(
            red: min(Double(rgba.r + p/100), 1.0),
            green: min(Double(rgba.g + p/100), 1.0),
            blue: min(Double(rgba.b + p/100), 1.0),
            opacity: Double(rgba.a)
        )
    }
    
    public func adjustHSBABrightness(by p: Int = 30) -> Color {
        guard p < 100 && p > -100 else { return self }
        let hsba = componentsHSBA()
        return Color(
            hue: Double(hsba.h),
            saturation: Double(hsba.s),
            brightness: min(Double(hsba.b + CGFloat(p)/100), 1.0),
            opacity: Double(hsba.a)
        )
    }
    
    public func adjustHSLALightness(by p: Int = 30) -> Color {
        guard p < 100 && p > -100 else { return self }
        let hsla = componentsHSLA()
        return Color(
            hue: hsla.h,
            saturation: hsla.s,
            lightness: min(hsla.l + CGFloat(p) / 100, 1.0),
            alpha: hsla.a
        )
    }
    
    public func adjustHSBAHue(by p: Int = 30) -> Color {
        guard p < 100 && p > -100 else { return self }
        let hsba = componentsHSBA()
        return Color(
            hue: min(Double(hsba.h + CGFloat(p)/100), 1.0),
            saturation: Double(hsba.s),
            brightness: Double(hsba.b),
            opacity: Double(hsba.a)
        )
    }
    
    public func adjustHSBASaturation(by p: Int = 30) -> Color {
        guard p < 100 && p > -100 else { return self }
        let hsba = componentsHSBA()
        return Color(
            hue: Double(hsba.h),
            saturation: min(Double(hsba.s + CGFloat(p)/100), 1.0),
            brightness: Double(hsba.b),
            opacity: Double(hsba.a)
        )
    }
    
    public func lighterRGBA(by percentage: CGFloat = 30.0) -> Color {
        return self.adjustRGBA(by: abs(percentage) )
    }
    
    public func darkerRGBA(by percentage: CGFloat = 30.0) -> Color {
        return self.adjustRGBA(by: -1 * abs(percentage) )
    }
}
