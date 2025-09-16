//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 01/11/2023.
//

import Foundation

@available(macOS 12, *)
extension KernelSwiftTerminal.Style {
    public struct AttributeScopes: AttributeScope {
        public let backgroundColor = BackgroundColorAttribute()
        public let foregroundColor = ForegroundColorAttribute()
        public let bold = BoldAttribute()
        public let italic = ItalicAttribute()
        public let strikethrough = StrikethroughAttribute()
        public let underline = UnderlineAttribute()
        public let inverted = InvertedAttribute()
    }
}

@available(macOS 12, *)
extension KernelSwiftTerminal.Style {
    public struct BackgroundColorAttribute: AttributedStringKey {
        public typealias Value = Color
        public static let name = "BackgroundColor"
    }
    
    public struct ForegroundColorAttribute: AttributedStringKey {
        public typealias Value = Color
        public static let name = "ForegroundColor"
    }
    
    public struct BoldAttribute: AttributedStringKey {
        public typealias Value = Bool
        public static let name = "Bold"
    }
    
    public struct ItalicAttribute: AttributedStringKey {
        public typealias Value = Bool
        public static let name = "Italic"
    }
    
    public struct StrikethroughAttribute: AttributedStringKey {
        public typealias Value = Bool
        public static let name = "Strikethrough"
    }
    
    public struct UnderlineAttribute: AttributedStringKey {
        public typealias Value = Bool
        public static let name = "Underline"
    }
    
    public struct InvertedAttribute: AttributedStringKey {
        public typealias Value = Bool
        public static let name = "Inverted"
    }
}
