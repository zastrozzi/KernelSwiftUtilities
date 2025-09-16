//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Views {
    public struct Text: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView {
        public var text: String?
        public let focusable: Bool
        
        private var _attributedText: Any?
        
        @available(macOS 12, *)
        private var attributedText: AttributedString? { _attributedText as? AttributedString }
        
        @KernelSwiftTerminal.Model.Environment(\.foregroundColor) private var foregroundColor: KernelSwiftTerminal.Style.Color
        @KernelSwiftTerminal.Model.Environment(\.bold) private var bold: Bool
        @KernelSwiftTerminal.Model.Environment(\.italic) private var italic: Bool
        @KernelSwiftTerminal.Model.Environment(\.underline) private var underline: Bool
        @KernelSwiftTerminal.Model.Environment(\.strikethrough) private var strikethrough: Bool
        
        public init(_ text: String, focusable: Bool = true) {
            self.text = text
            self.focusable = focusable
        }
        
        @available(macOS 12, *)
        public init(_ attributedText: AttributedString, focusable: Bool = true) {
            self._attributedText = attributedText
            self.focusable = focusable
        }
        
        static var size: Int? { 1 }
        
        func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            setupEnvironmentProperties(node: node)
            node.control = Control(
                text: text,
                attributedText: _attributedText,
                foregroundColor: foregroundColor,
                bold: bold,
                italic: italic,
                underline: underline,
                strikethrough: strikethrough,
                focusable: focusable
            )
        }
        
        func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            setupEnvironmentProperties(node: node)
            node.view = self
            let control = node.control as! Control
            control.text = text
            control._attributedText = _attributedText
            control.foregroundColor = foregroundColor
            control.bold = bold
            control.italic = italic
            control.underline = underline
            control.strikethrough = strikethrough
            control.layer.invalidate()
        }
        
        private class Control: KernelSwiftTerminal.Application.Control {
            var text: String?
            
            override var isFocusable: Bool { _focusable }
            
            var _attributedText: Any?
            
            @available(macOS 12, *)
            var attributedText: AttributedString? { _attributedText as? AttributedString }
            
            var maxWidth: Int = 0
            
            var foregroundColor: KernelSwiftTerminal.Style.Color
            var bold: Bool
            var italic: Bool
            var underline: Bool
            var strikethrough: Bool
            var _focusable: Bool
            
            init(
                text: String?,
                attributedText: Any?,
                foregroundColor: KernelSwiftTerminal.Style.Color,
                bold: Bool,
                italic: Bool,
                underline: Bool,
                strikethrough: Bool,
                focusable: Bool
            ) {
                self.text = text
                self._attributedText = attributedText
                self.foregroundColor = foregroundColor
                self.bold = bold
                self.italic = italic
                self.underline = underline
                self.strikethrough = strikethrough
                self._focusable = focusable
            }
            
            override func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size {
                
                let defaultMetric = 1
                let safeWidth = proposedSize.width != 0 ? proposedSize.width : defaultMetric
                maxWidth = safeWidth
                let needsWrap = characterCount > proposedSize.width
                let newHeight = characterCount.quotientAndRemainder(dividingBy: safeWidth).quotient + 1
                
                return KernelSwiftTerminal.Layout.Size(
                    width: needsWrap ? proposedSize.width : characterCount,
                    height: needsWrap ? newHeight : defaultMetric
                )
            }
            
            override func cell(at position: KernelSwiftTerminal.Layout.Position) -> KernelSwiftTerminal.Layout.Cell? {
//                guard position.line == 0 else { return nil }
                guard (position.column + (position.line * maxWidth)) < characterCount else { return .init(char: " ") }
                if #available(macOS 12, *), let attributedText {
                    let characters = attributedText.characters
                    let i = characters.index(characters.startIndex, offsetBy: position.column + (position.line * maxWidth))
                    let char = attributedText[i ..< characters.index(after: i)]
                    let cellAttributes = KernelSwiftTerminal.Style.CellAttributes(
                        bold: char.bold ?? bold,
                        italic: char.italic ?? italic,
                        underline: char.underline ?? underline,
                        strikethrough: char.strikethrough ?? strikethrough,
                        inverted: char.inverted ?? false
                    )
                    return .init(
                        char: char.characters[char.startIndex],
                        foregroundColor: char.foregroundColor ?? foregroundColor,
                        backgroundColor: char.backgroundColor,
                        attributes: cellAttributes
                    )
                }
                if let text {
                    let cellAttributes = KernelSwiftTerminal.Style.CellAttributes(
                        bold: bold,
                        italic: italic,
                        underline: underline,
                        strikethrough: strikethrough
                    )
                    return .init(
                        char: text[text.index(text.startIndex, offsetBy: position.column + (position.line * maxWidth))],
                        foregroundColor: foregroundColor,
                        attributes: cellAttributes
                    )
                }
                return nil
            }
            
            private var characterCount: Int {
                if #available(macOS 12, *), let attributedText { attributedText.characters.count }
                else { text?.count ?? .zero }
            }
        }
    }

}
