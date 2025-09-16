//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelSwiftTerminal.Renderer {
    public enum EscapeSequence {
        public static let clearScreen = "\u{1b}[2J"
        
        public static let enableAlternateBuffer = "\u{1b}[?1049h"
        public static let disableAlternateBuffer = "\u{1b}[?1049l"
        
        public static let showCursor = "\u{1b}[?25h"
        public static let hideCursor = "\u{1b}[?25l"
        
        public static func moveTo(_ position: KernelSwiftTerminal.Layout.Position) -> String { "\u{1b}[\(position.line + 1);\(position.column + 1)H" }
        
        public static func setForegroundColor(_ color: KernelSwiftTerminal.Style.Color) -> String { "\u{1b}[\(color.foregroundCode)m" }
        public static func setBackgroundColor(_ color: KernelSwiftTerminal.Style.Color) -> String { "\u{1b}[\(color.backgroundCode)m" }
        
        public static let enableBold = String(utf8EncodedBytes: [0x1b, 0x5b, 0x31, 0x6d])
        public static let disableBold = String(utf8EncodedBytes: [0x1b, 0x5b, 0x32, 0x32, 0x6d])
        
        public static let enableItalic = "\u{1b}[3m"
        public static let disableItalic = "\u{1b}[23m"
        
        public static let enableUnderline = "\u{1b}[4m"
        public static let disableUnderline = "\u{1b}[24m"
        
        public static let enableStrikethrough = "\u{1b}[9m"
        public static let disableStrikethrough = "\u{1b}[29m"
        
        public static let enableInverted = "\u{1b}[7m"
        public static let disableInverted = "\u{1b}[27m"
    }
}
