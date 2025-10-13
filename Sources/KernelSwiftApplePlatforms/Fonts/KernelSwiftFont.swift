//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/08/2023.
//

import Foundation
import SwiftUI

public struct KernelSwiftFont {
    public let customFontFamilyName: String?
    public let size: CGFloat
    public let weight: KernelSwiftFontWeight
    public let design: Font.Design
    public let textStyle: Font.TextStyle?
    
    public init(size: CGFloat, weight: KernelSwiftFontWeight, design: Font.Design = .default, relativeTo textStyle: Font.TextStyle? = nil) {
        self.customFontFamilyName = nil
        self.size = size
        self.weight = weight
        self.design = design
        self.textStyle = textStyle
    }
    
    public init(customFontFamilyName: String, size: CGFloat, weight: KernelSwiftFontWeight, design: Font.Design = .default, relativeTo textStyle: Font.TextStyle? = nil) {
        self.customFontFamilyName = customFontFamilyName
        self.size = size
        self.weight = weight
        self.design = design
        self.textStyle = textStyle
    }
    
    public var textFont: Font {
        customFontFamilyName != nil ? customTextFont : systemTextFont
    }
    
    public var iconFont: Font { return systemTextFont }
    
    public var customTextFont: Font {
        guard let fontFamily = customFontFamilyName else { return self.systemTextFont }
        switch weight {
        case .ultraLight: return textStyle != nil ? Font.custom("\(fontFamily)-UltraLight", size: size, relativeTo: textStyle!) : Font.custom("\(fontFamily)-UltraLight", size: size)
        case .light: return textStyle != nil ? Font.custom("\(fontFamily)-Light", size: size, relativeTo: textStyle!) : Font.custom("\(fontFamily)-Light", size: size)
        case .thin: return textStyle != nil ? Font.custom("\(fontFamily)-Thin", size: size, relativeTo: textStyle!) : Font.custom("\(fontFamily)-Thin", size: size)
        case .regular: return textStyle != nil ? Font.custom("\(fontFamily)-Regular", size: size, relativeTo: textStyle!) : Font.custom("\(fontFamily)-Regular", size: size)
        case .book: return textStyle != nil ? Font.custom("\(fontFamily)-Book", size: size, relativeTo: textStyle!) : Font.custom("\(fontFamily)-Book", size: size)
        case .medium: return textStyle != nil ? Font.custom("\(fontFamily)-Medium", size: size, relativeTo: textStyle!) : Font.custom("\(fontFamily)-Medium", size: size)
        case .semibold: return textStyle != nil ? Font.custom("\(fontFamily)-SemiBold", size: size, relativeTo: textStyle!) : Font.custom("\(fontFamily)-SemiBold", size: size)
        case .bold: return textStyle != nil ? Font.custom("\(fontFamily)-Bold", size: size, relativeTo: textStyle!) : Font.custom("\(fontFamily)-Bold", size: size)
        case .heavy: return textStyle != nil ? Font.custom("\(fontFamily)-Heavy", size: size, relativeTo: textStyle!) : Font.custom("\(fontFamily)-Heavy", size: size)
        case .black: return textStyle != nil ? Font.custom("\(fontFamily)-Black", size: size, relativeTo: textStyle!) : Font.custom("\(fontFamily)-Black", size: size)
            //        default: return systemTextFont
        }
    }
    
    public var systemTextFont: Font { return Font.system(size: size, weight: weight.swiftUIFontWeight, design: design) }
    
    #if os(iOS)
    public var systemTextUiFont: UIFont { return UIFont.systemFont(ofSize: size, weight: weight.uiFontWeight) }
    
    public var uiFont: UIFont {
        guard let fontFamily = customFontFamilyName else { return self.systemTextUiFont }
        switch weight {
        case .ultraLight: return UIFont(name: "\(fontFamily)-UltraLight", size: size) ?? systemTextUiFont
        case .light: return UIFont(name: "\(fontFamily)-Light", size: size) ?? systemTextUiFont
        case .thin: return UIFont(name: "\(fontFamily)-Thin", size: size) ?? systemTextUiFont
        case .regular: return UIFont(name: "\(fontFamily)-Regular", size: size) ?? systemTextUiFont
        case .book: return UIFont(name: "\(fontFamily)-Book", size: size) ?? systemTextUiFont
        case .medium: return UIFont(name: "\(fontFamily)-Medium", size: size) ?? systemTextUiFont
        case .semibold: return UIFont(name: "\(fontFamily)-SemiBold", size: size) ?? systemTextUiFont
        case .bold: return UIFont(name: "\(fontFamily)-Bold", size: size) ?? systemTextUiFont
        case .heavy: return UIFont(name: "\(fontFamily)-Heavy", size: size) ?? systemTextUiFont
        case .black: return UIFont(name: "\(fontFamily)-Black", size: size) ?? systemTextUiFont
            //        default: return systemTextFont
        }
    }
    #endif
}
