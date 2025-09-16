//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelSwiftTerminal.Views {
    public struct TextField: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView {
        public let action: (String) -> Void
        public let placeholder: String
        
        public init(_ placeholder: String = "", action: @escaping (String) -> Void) {
            self.action = action
            self.placeholder = placeholder
        }
        
        static var size: Int? { 1 }
        
        func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.control = Control(placeholder: placeholder, action: action)
        }
        
        func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.view = self
            (node.control as! Control).action = action
        }
        
        private class Control: KernelSwiftTerminal.Application.Control, SelectableControl, TextReceivableControl {
            var text: String = ""
            let placeholder: String
            var action: (String) -> Void
            override var isSelectable: Bool { true }
            override var isFocusable: Bool { true }
            var showPlaceholder: Bool { !hasFocus || text.isEmpty }
            var actualWidth: Int = 0

            func handleSelection() {
                action(text)
                self.text.removeAll()
                layer.invalidate()
            }
            
            init(placeholder: String, action: @escaping (String) -> Void) {
                self.action = action
                self.placeholder = placeholder
                super.init()
                setupSelectionHandler()
                setupTextReceivingHandler()
            }
            
            override func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size {
                actualWidth = max(proposedSize.width, text.count + 3)
                return .init(width: actualWidth, height: 1)
            }
            
//            func handleEvent(_ char: Character) {
//                if char == "\n" {
//                    action(text)
//                    self.text = ""
//                    layer.invalidate()
//                    return
//                }
//                
//                if char.asciiValue == .ascii.delete {
//                    if !self.text.isEmpty {
//                        self.text.removeLast()
//                        layer.invalidate()
//                    }
//                    return
//                }
//                
//                self.text += String(char)
//                layer.invalidate()
//            }
            
            override func cell(at position: KernelSwiftTerminal.Layout.Position) -> KernelSwiftTerminal.Layout.Cell? {
                guard position.line == .zero else { return nil }
                let displayText = (showPlaceholder ? placeholder : text)
                return switch position.column {
                case .zero: .init(char: "[")
                case actualWidth - 1: .init(char: "]")
                case (displayText.count + 1): .init(char: hasFocus && !showPlaceholder ? "_" : " ")
                case (displayText.count + 1)...: .init(char: " ")
                default: .init(char: displayText[displayText.index(displayText.startIndex, offsetBy: position.column - 1)], attributes: .init(italic: showPlaceholder))
                }
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
