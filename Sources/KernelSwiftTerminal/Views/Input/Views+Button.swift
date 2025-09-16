//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Views {
    public struct Button: KernelSwiftTerminal.ViewGraph.View,
                          KernelSwiftTerminal.ViewGraph.PrimitiveView {
        
        public let n: String
        public let action: () -> Void
        
        @KernelSwiftTerminal.Model.Environment(\.foregroundColor) private var foregroundColor: KernelSwiftTerminal.Style.Color
        @KernelSwiftTerminal.Model.Environment(\.bold) private var bold: Bool
        @KernelSwiftTerminal.Model.Environment(\.italic) private var italic: Bool
        @KernelSwiftTerminal.Model.Environment(\.underline) private var underline: Bool
        @KernelSwiftTerminal.Model.Environment(\.strikethrough) private var strikethrough: Bool
        
        public init(_ label: String, action: @escaping () -> Void) {
            self.n = "[" + label + "]"
            self.action = action
        }
        
        static var size: Int? { 1 }
        
        func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            setupEnvironmentProperties(node: node)
            node.control = Control(
                text: n,
                action: action,
                foregroundColor: foregroundColor,
                bold: bold,
                italic: italic,
                underline: underline,
                strikethrough: strikethrough
            )
        }
        
        func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            setupEnvironmentProperties(node: node)
            node.view = self
            let control = node.control as! Control
            control.text = n
//            control._attributedText = _attributedText
            control.foregroundColor = foregroundColor
            control.bold = bold
            control.italic = italic
            control.underline = underline
            control.strikethrough = strikethrough
            control.layer.invalidate()
        }
        
        private class Control: KernelSwiftTerminal.Application.Control, SelectableControl {
            var text: String
            var _attributedText: Any?
            
            @available(macOS 12, *)
            var attributedText: AttributedString? { _attributedText as? AttributedString }
            
            
            override var isFocusable: Bool { true }
            override var isSelectable: Bool { true }
            
            var action: () -> Void
            
            func handleSelection() {
                action()
            }
            
            var foregroundColor: KernelSwiftTerminal.Style.Color
            var bold: Bool
            var italic: Bool
            var underline: Bool
            var strikethrough: Bool
            
            init(
                text: String,
                action: @escaping () -> Void,
                foregroundColor: KernelSwiftTerminal.Style.Color,
                 bold: Bool,
                 italic: Bool,
                 underline: Bool,
                 strikethrough: Bool
            ) {
                self.text = text
                self.action = action
                self.foregroundColor = foregroundColor
                self.bold = bold
                self.italic = italic
                self.underline = underline
                self.strikethrough = strikethrough
                super.init()
                setupSelectionHandler()
            }
            
            override func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size {
                return .init(width:  text.count, height: 1)
            }
            
            override func cell(at position: KernelSwiftTerminal.Layout.Position) -> KernelSwiftTerminal.Layout.Cell? {
                guard position.line == 0 else { return nil }
                guard position.column < text.count else { return .init(char: " ") }
                let char = text[text.index(text.startIndex, offsetBy: position.column)]
                return .init(
                    char: char,
                    attributes: .init()
                )
            }
            
            
//            override func becomeFirstResponder() {
//                super.becomeFirstResponder()
//                layer.invalidate()
//            }
//            
//            override func resignFirstResponder() {
//                super.resignFirstResponder()
//                layer.invalidate()
//            }
        }
    }

}
