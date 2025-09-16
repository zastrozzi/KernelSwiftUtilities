//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation


extension KernelSwiftTerminal.ViewGraph.View {
    public func environment<T>(_ keyPath: WritableKeyPath<KernelSwiftTerminal.Model.EnvironmentValues, T>, _ value: T) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.ViewGraph.SetEnvironment(content: self, keyPath: keyPath, value: value)
    }
}

extension KernelSwiftTerminal.ViewGraph {
    struct SetEnvironment<Content: KernelSwiftTerminal.ViewGraph.View, T>: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView {
        let content: Content
        let keyPath: WritableKeyPath<KernelSwiftTerminal.Model.EnvironmentValues, T>
        let value: T
        
        init(content: Content, keyPath: WritableKeyPath<KernelSwiftTerminal.Model.EnvironmentValues, T>, value: T) {
            self.content = content
            self.keyPath = keyPath
            self.value = value
        }
        
        static var size: Int? { Content.size }
        
        func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.addNode(at: 0, .init(view: content.view))
            node.environment = { $0[keyPath: keyPath] = value }
        }
        
        func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.view = self
            node.children[0].update(using: content.view)
            node.environment = { $0[keyPath: keyPath] = value }
        }
        
    }
}
