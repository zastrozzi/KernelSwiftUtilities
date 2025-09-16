//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 01/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Views {
    public struct VStack<Content: ViewGraph.View>: ViewGraph.View, ViewGraph.PrimitiveView, ViewGraph.LayoutRootView {
        public let content: Content
        let alignment: Layout.HorizontalAlignment
        let spacing: Int?
        
        public init(alignment: Layout.HorizontalAlignment = .leading, spacing: Int? = nil, @ViewGraph.ViewBuilder _ content: () -> Content) {
            self.content = content()
            self.alignment = alignment
            self.spacing = spacing
        }
        
        init(content: Content, alignment: Layout.HorizontalAlignment = .leading, spacing: Int? = nil) {
            self.content = content
            self.alignment = alignment
            self.spacing = spacing
        }
        
        static var size: Int? { 1 }
        
        func loadData(node: ViewGraph.Node) {
            for i in .zero..<node.children[0].size {
                (node.control as! Control).addSubview(node.children[0].control(at: i), at: i)
            }
        }
        
        func buildNode(_ node: ViewGraph.Node) {
            node.addNode(at: .zero, .init(view: content.view))
            node.control = Control(alignment: alignment, spacing: spacing ?? .zero)
            node.environment = { $0.axis = .vertical }
        }
        
        func updateNode(_ node: ViewGraph.Node) {
            node.view = self
            node.children[0].update(using: content.view)
            let control = node.control as! Control
            control.alignment = alignment
            control.spacing = spacing ?? .zero
        }
        
        func insertControl(at index: Int, node: ViewGraph.Node) {
            (node.control as! Control).addSubview(node.children[0].control(at: index), at: index)
        }
        
        func removeControl(at index: Int, node: ViewGraph.Node) {
            (node.control as! Control).removeSubview(at: index)
        }
    }
}

extension KernelSwiftTerminal.Views.VStack {
    private class Control: KernelSwiftTerminal.Application.Control {
        var alignment: KernelSwiftTerminal.Layout.HorizontalAlignment
        var spacing: Int
        
        init(alignment: KernelSwiftTerminal.Layout.HorizontalAlignment, spacing: Int) {
            self.alignment = alignment
            self.spacing = spacing
        }
        
        override func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size {
            var size: KernelSwiftTerminal.Layout.Size = .zero
            var remainingItems = children.count
            for control in children.sorted(by: { $0.verticalFlexibility(width: proposedSize.width) < $1.verticalFlexibility(width: proposedSize.width) }) {
                let childSize = control.size(proposedSize: .init(width: proposedSize.width, height: (proposedSize.height - size.height) / remainingItems))
                size.height += childSize.height
                if remainingItems > 1 { size.height += spacing }
                size.width = max(size.width, childSize.width)
                remainingItems -= 1
            }
            return size
        }
        
        override func layout(size: KernelSwiftTerminal.Layout.Size) {
            super.layout(size: size)
            var remainingItems = children.count
            var remainingHeight = size.height
            for control in children.sorted(by: { $0.verticalFlexibility(width: size.width) < $1.verticalFlexibility(width: size.width) }) {
                let childSize = control.size(proposedSize: .init(width: size.width, height: remainingHeight / remainingItems))
                control.layout(size: childSize)
                if remainingItems > 1 { remainingHeight -= spacing }
                remainingItems -= 1
                remainingHeight -= childSize.height
            }
            var line = Int.zero
            for control in children {
                control.layer.frame.position.line = line
                line += control.layer.frame.size.height
                line += spacing
                switch alignment {
                case .leading: control.layer.frame.position.column = .zero
                case .center: control.layer.frame.position.column = (size.width - control.layer.frame.size.width) / 2
                case .trailing: control.layer.frame.position.column = size.width - control.layer.frame.size.width
                }
            }
        }

    }
}
