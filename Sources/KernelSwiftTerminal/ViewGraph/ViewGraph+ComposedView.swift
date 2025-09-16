//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

extension KernelSwiftTerminal.ViewGraph {
    public struct ComposedView<I: View>: GenericView {
        let view: I
        
        func buildNode(_ node: Node) {
            view.setupStateProperties(node: node)
            view.setupEnvironmentProperties(node: node)
#if os(macOS)
            view.setupObservedObjectProperties(node: node)
#endif
            node.addNode(at: 0, Node(view: view.body.view))
        }
        
        func updateNode(_ node: Node) {
            view.setupStateProperties(node: node)
            view.setupEnvironmentProperties(node: node)
            node.view = self
            node.children[0].update(using: view.body.view)
        }
        
        static var size: Int? {
            I.Body.size
        }
    }
}
