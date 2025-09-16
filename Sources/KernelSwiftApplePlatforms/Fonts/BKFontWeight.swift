//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/08/2023.
//

import Foundation
import SwiftUI

public enum BKFontWeight {
    case ultraLight
    case thin
    case light
    case regular
    case book
    case medium
    case semibold
    case bold
    case heavy
    case black
    
    var swiftUIFontWeight: Font.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .book: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        }
    }
    
    #if os(iOS)
    var uiFontWeight: UIFont.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .book: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        }
    }
    #endif
}
