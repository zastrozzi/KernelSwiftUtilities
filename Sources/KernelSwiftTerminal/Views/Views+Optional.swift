//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation

extension Optional: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView, KernelSwiftTerminal.ViewGraph.GenericView, _KernelSwiftTerminalOptionalView where Wrapped: KernelSwiftTerminal.ViewGraph.View {
    public typealias Body = Never
    
    static var size: Int? {
        if Wrapped.size == 0 { return 0 }
        return nil
    }
    
    func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
        if let view = self {
            node.addNode(at: 0, .init(view: view.view))
        }
    }
    
    func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
        let last = node.view as! Self
        node.view = self
        switch (last, self) {
        case (.none, .none):
            break
        case (.none, .some(let newValue)):
            node.addNode(at: 0, .init(view: newValue.view))
        case (.some, .none):
            node.removeNode(at: 0)
        case (.some, .some(let newValue)):
            node.children[0].update(using: newValue.view)
        }
    }
}
