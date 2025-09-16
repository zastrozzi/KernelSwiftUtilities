//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Views {
    public struct Group<Content: KernelSwiftTerminal.ViewGraph.View>: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView {
        public let content: Content
        
        public init(@KernelSwiftTerminal.ViewGraph.ViewBuilder _ content: () -> Content) {
            self.content = content()
        }
        
        static var size: Int? { Content.size }
        
        func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.addNode(at: 0, KernelSwiftTerminal.ViewGraph.Node(view: content.view))
        }
        
        func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.view = self
            node.children[0].update(using: content.view)
        }
        
    }

}
