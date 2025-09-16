//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Views {
    struct Border<Content: KernelSwiftTerminal.ViewGraph.View>: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView, KernelSwiftTerminal.ViewGraph.ModifierView {
        let content: Content
        let color: KernelSwiftTerminal.Style.Color?
        @KernelSwiftTerminal.Model.Environment(\.foregroundColor) var foregroundColor: KernelSwiftTerminal.Style.Color
        
        static var size: Int? { Content.size }
        
        func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            setupEnvironmentProperties(node: node)
            node.addNode(at: 0, KernelSwiftTerminal.ViewGraph.Node(view: content.view))
        }
        
        func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            setupEnvironmentProperties(node: node)
            node.view = self
            node.children[0].update(using: content.view)
        }
        
        func passControl(_ control: KernelSwiftTerminal.Application.Control) -> KernelSwiftTerminal.Application.Control {
            if let borderControl = control.parent { return borderControl }
            let borderControl = Control(color: color ?? foregroundColor)
            borderControl.addSubview(control, at: 0)
            return borderControl
        }
        
        private class Control: KernelSwiftTerminal.Application.Control {
            var color: KernelSwiftTerminal.Style.Color
            
            init(color: KernelSwiftTerminal.Style.Color) {
                self.color = color
            }
            
            override func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size {
                var proposedSize = proposedSize
                proposedSize.width -= 2
                proposedSize.height -= 2
                var size = children[0].size(proposedSize: proposedSize)
                size.width += 2
                size.height += 2
                return size
            }
            
            override func layout(size: KernelSwiftTerminal.Layout.Size) {
                var contentSize = size
                contentSize.width -= 2
                contentSize.height -= 2
                children[0].layout(size: contentSize)
                children[0].layer.frame.position = KernelSwiftTerminal.Layout.Position(column: 1, line: 1)
                self.layer.frame.size = size
            }
            
            override func cell(at position: KernelSwiftTerminal.Layout.Position) -> KernelSwiftTerminal.Layout.Cell? {
                var char: Character?
                if position.line == 0 {
                    if position.column == 0 {
                        char = "┌"
                    } else if position.column == layer.frame.size.width - 1 {
                        char = "┐"
                    } else {
                        char = "─"
                    }
                } else if position.line == layer.frame.size.height - 1 {
                    if position.column == 0 {
                        char = "└"
                    } else if position.column == layer.frame.size.width - 1 {
                        char = "┘"
                    } else {
                        char = "─"
                    }
                } else if position.column == 0 || position.column == layer.frame.size.width - 1 {
                    char = "│"
                }
                return char.map { KernelSwiftTerminal.Layout.Cell(char: $0, foregroundColor: color) }
            }
        }
    }
}

extension KernelSwiftTerminal.ViewGraph.View {
    public func border(_ color: KernelSwiftTerminal.Style.Color? = nil) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Border(content: self, color: color)
    }
}
