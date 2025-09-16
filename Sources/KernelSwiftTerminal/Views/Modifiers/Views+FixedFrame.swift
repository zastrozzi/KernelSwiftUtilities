//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Views {
    struct FixedFrame<Content: KernelSwiftTerminal.ViewGraph.View>: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView, KernelSwiftTerminal.ViewGraph.ModifierView {
        let content: Content
        let width: Int?
        let height: Int?
        let alignment: KernelSwiftTerminal.Layout.Alignment
        
        init(content: Content, width: Int?, height: Int?, alignment: KernelSwiftTerminal.Layout.Alignment) {
            self.content = content
            self.width = width
            self.height = height
            self.alignment = alignment
        }
        
        static var size: Int? { Content.size }
        
        func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.addNode(at: 0, KernelSwiftTerminal.ViewGraph.Node(view: content.view))
        }
        
        func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.view = self
            node.children[0].update(using: content.view)
        }
        
        func passControl(_ control: KernelSwiftTerminal.Application.Control) -> KernelSwiftTerminal.Application.Control {
            if let fixedFrameControl = control.parent { return fixedFrameControl }
            let fixedFrameControl = Control(width: width, height: height, alignment: alignment)
            fixedFrameControl.addSubview(control, at: 0)
            return fixedFrameControl
        }
        
        private class Control: KernelSwiftTerminal.Application.Control {
            var width: Int?
            var height: Int?
            var alignment: KernelSwiftTerminal.Layout.Alignment
            
            init(width: Int?, height: Int?, alignment: KernelSwiftTerminal.Layout.Alignment) {
                self.width = width
                self.height = height
                self.alignment = alignment
            }
            
            override func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size {
                var proposedSize = proposedSize
                proposedSize.width = width ?? proposedSize.width
                proposedSize.height = height ?? proposedSize.height
                var size = children[0].size(proposedSize: proposedSize)
                size.width = width ?? size.width
                size.height = height ?? size.height
                return size
            }
            
            override func layout(size: KernelSwiftTerminal.Layout.Size) {
                super.layout(size: size)
                children[0].layout(size: children[0].size(proposedSize: size))
                switch alignment.verticalAlignment {
                case .top: children[0].layer.frame.position.line = 0
                case .center: children[0].layer.frame.position.line = (size.height - children[0].layer.frame.size.height) / 2
                case .bottom: children[0].layer.frame.position.line = size.height - children[0].layer.frame.size.height
                }
                switch alignment.horizontalAlignment {
                case .leading: children[0].layer.frame.position.column = 0
                case .center: children[0].layer.frame.position.column = (size.width - children[0].layer.frame.size.width) / 2
                case .trailing: children[0].layer.frame.position.column = size.width - children[0].layer.frame.size.width
                }
            }
        }
    }
}

extension KernelSwiftTerminal.ViewGraph.View {
    public func frame(width: Int? = nil, height: Int? = nil, alignment: KernelSwiftTerminal.Layout.Alignment = .topLeading) -> some KernelSwiftTerminal.ViewGraph.View {
        KernelSwiftTerminal.Views.FixedFrame(content: self, width: width, height: height, alignment: alignment)
    }
}
