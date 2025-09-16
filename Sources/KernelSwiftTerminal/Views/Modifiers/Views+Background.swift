//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Views {
    struct Background<Content: KernelSwiftTerminal.ViewGraph.View>: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView, KernelSwiftTerminal.ViewGraph.ModifierView {
        let content: Content
        let color: KernelSwiftTerminal.Style.Color
        
        static var size: Int? { Content.size }
        
        func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.addNode(at: 0, KernelSwiftTerminal.ViewGraph.Node(view: content.view))
        }
        
        func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.view = self
            node.children[0].update(using: content.view)
        }
        
        func passControl(_ control: KernelSwiftTerminal.Application.Control) -> KernelSwiftTerminal.Application.Control {
            if let borderControl = control.parent { return borderControl }
            let borderControl = Control(color: color)
            borderControl.addSubview(control, at: 0)
            return borderControl
        }
        
        private class Control: KernelSwiftTerminal.Application.Control {
            var color: KernelSwiftTerminal.Style.Color
            
            init(color: KernelSwiftTerminal.Style.Color) {
                self.color = color
            }
            
            override func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size {
                children[0].size(proposedSize: proposedSize)
            }
            
            override func layout(size: KernelSwiftTerminal.Layout.Size) {
                super.layout(size: size)
                children[0].layout(size: size)
            }
            
            override func cell(at position: KernelSwiftTerminal.Layout.Position) -> KernelSwiftTerminal.Layout.Cell? {
                .init(char: " ", backgroundColor: color)
            }
        }
    }
}

extension KernelSwiftTerminal.ViewGraph.View {
    public func background(_ color: KernelSwiftTerminal.Style.Color) -> some KernelSwiftTerminal.ViewGraph.View {
        KernelSwiftTerminal.Views.Background(content: self, color: color)
    }
}

