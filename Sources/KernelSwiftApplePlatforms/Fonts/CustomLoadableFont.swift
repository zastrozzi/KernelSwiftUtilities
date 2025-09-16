//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/01/2025.
//

import SwiftUI

public protocol CustomLoadableFont: RawRepresentable, Codable, Equatable, CaseIterable where RawValue == String {
    static var fontExtension: String { get }
}

extension CustomLoadableFont {
    public static func registerFonts(bundle: Bundle) {
        Self.allCases.forEach { loadFont(bundle: bundle, fontName: $0) }
    }
    
    public static func loadFont(bundle: Bundle, fontName: Self) {
        guard
            let fontURL = bundle.url(forResource: fontName.rawValue, withExtension: Self.fontExtension)
        else {
            print("Font load failed for \(fontName.rawValue).\(Self.fontExtension)")
            return
        }
        
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
    }
    
    public static func customFontWithSize(_ weight: Self, _ size: CGFloat) -> Font {
        Font.custom(weight.rawValue, size: size)
    }
    
    public static func customFontWithStyle(_ weight: Self, _ style: Font.TextStyle) -> Font {
        Font.custom(weight.rawValue, size: style.defaultSize, relativeTo: style)
    }
    
    
    public static func customUIFontWithSize(_ weight: Self, _ size: CGFloat) -> UIFont {
        UIFont(name: weight.rawValue, size: size)!
    }
    
    public static func customUIFontWithStyle(_ weight: Self, _ style: Font.TextStyle) -> UIFont {
        UIFont(name: weight.rawValue, size: style.defaultSize)!
    }
}

extension Font.TextStyle {
    public var defaultSize: CGFloat {
        switch self {
        case .largeTitle: 60
        case .title: 48
        case .title2: 34
        case .title3: 24
        case .headline, .body: 18
        case .subheadline, .callout: 16
        case .footnote: 14
        case .caption, .caption2: 12
        @unknown default: 8
        }
    }
}
