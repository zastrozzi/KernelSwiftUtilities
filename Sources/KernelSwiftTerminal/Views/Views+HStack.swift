//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Views {
    public struct HStack<Content: ViewGraph.View>: ViewGraph.View, ViewGraph.PrimitiveView, ViewGraph.LayoutRootView {
        public let content: Content
        let alignment: Layout.VerticalAlignment
        let spacing: Int?
        
        public init(alignment: Layout.VerticalAlignment = .top, spacing: Int? = nil, @ViewGraph.ViewBuilder _ content: () -> Content) {
            self.content = content()
            self.alignment = alignment
            self.spacing = spacing
        }
        
        init(content: Content, alignment: Layout.VerticalAlignment = .top, spacing: Int? = nil) {
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
            node.environment = { $0.axis = .horizontal }
        }
        
        func updateNode(_ node: ViewGraph.Node) {
            node.view = self
            node.children[0].update(using: content.view)
            let control = node.control as! Control
            control.alignment = alignment
            control.spacing = spacing ?? 1
        }
        
        func insertControl(at index: Int, node: ViewGraph.Node) {
            (node.control as! Control).addSubview(node.children[0].control(at: index), at: index)
        }
        
        func removeControl(at index: Int, node: ViewGraph.Node) {
            (node.control as! Control).removeSubview(at: index)
        }
    }
}

extension KernelSwiftTerminal.Views.HStack {
    private class Control: KernelSwiftTerminal.Application.Control {
        var alignment: KernelSwiftTerminal.Layout.VerticalAlignment
        var spacing: Int
        
        init(alignment: KernelSwiftTerminal.Layout.VerticalAlignment, spacing: Int) {
            self.alignment = alignment
            self.spacing = spacing
        }
        
        override func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size {
            var size: KernelSwiftTerminal.Layout.Size = .zero
            var remainingItems = children.count
            for control in children.sorted(by: { $0.horizontalFlexibility(height: proposedSize.height) < $1.horizontalFlexibility(height: proposedSize.height) }) {
                let childSize = control.size(proposedSize: .init(width: (proposedSize.width - size.width) / remainingItems, height: proposedSize.height))
                size.width += childSize.width
                if remainingItems > 1 { size.width += spacing }
                size.height = max(size.height, childSize.height)
                remainingItems -= 1
            }
            return size
        }
        
        override func layout(size: KernelSwiftTerminal.Layout.Size) {
            super.layout(size: size)
            var remainingItems = children.count
            var remainingWidth = size.width
            for control in children.sorted(by: { $0.horizontalFlexibility(height: size.height) < $1.horizontalFlexibility(height: size.height) }) {
                let childSize = control.size(proposedSize: .init(width: remainingWidth / remainingItems, height: size.height))
                control.layout(size: childSize)
                if remainingItems > 1 { remainingWidth -= spacing }
                remainingItems -= 1
                remainingWidth -= childSize.width
            }
            var column = Int.zero
            for control in children {
                control.layer.frame.position.column = column
                column += control.layer.frame.size.width
                column += spacing
                switch alignment {
                case .top: control.layer.frame.position.line = .zero
                case .center: control.layer.frame.position.line = (size.height - control.layer.frame.size.height) / 2
                case .bottom: control.layer.frame.position.line = size.height - control.layer.frame.size.height
                }
            }
        }
        
    }
}
