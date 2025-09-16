//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Views {
    public struct ScrollView<Content: KernelSwiftTerminal.ViewGraph.View>: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView {
        let content: VStack<Content>
        
        public init(@KernelSwiftTerminal.ViewGraph.ViewBuilder _ content: () -> Content) {
            self.content = .init(content: content())
        }
        
        static var size: Int? { 1 }
        
        func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.addNode(at: 0, .init(view: content.view))
            let control = Control()
            control.contentControl = node.children[0].control(at: 0)
            control.addSubview(control.contentControl, at: 0)
            node.control = control
        }
        
        func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.view = self
            node.children[0].update(using: content.view)
        }
        
        private class Control: KernelSwiftTerminal.Application.Control {
            var contentControl: KernelSwiftTerminal.Application.Control!
            var contentOffset: Int = 0
            
            override func layout(size: KernelSwiftTerminal.Layout.Size) {
                super.layout(size: size)
                let contentSize = contentControl.size(proposedSize: .zero)
                contentControl.layout(size: contentSize)
                contentControl.layer.frame.position.line = -contentOffset
            }
            
            override func scroll(to position: KernelSwiftTerminal.Layout.Position) {
                let destination = position.line - contentControl.layer.frame.position.line
                guard layer.frame.size.height > 0 else { return }
                if contentOffset > destination {
                    contentOffset = destination
                } else if contentOffset < destination - layer.frame.size.height + 1 {
                    contentOffset = destination - layer.frame.size.height + 1
                }
            }
        }
    }

}
