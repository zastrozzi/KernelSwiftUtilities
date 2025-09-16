//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

protocol _KernelSwiftTerminalPrimitiveView: KernelSwiftTerminal.GenericView {}

extension KernelSwiftTerminal.ViewGraph {
    typealias PrimitiveView = _KernelSwiftTerminalPrimitiveView
}

extension KernelSwiftTerminal {
    typealias PrimitiveView = KernelSwiftTerminal.ViewGraph.PrimitiveView
}

extension KernelSwiftTerminal.PrimitiveView {
    public var body: Never { fatalError("Cannot evaluate body of primitive view") }
}

extension KernelSwiftTerminal.View {
    static var size: Int? {
        if let I = Self.self as? any KernelSwiftTerminal.PrimitiveView.Type {
            return I.size
        }
        return Body.size
    }
}

extension KernelSwiftTerminal.View {
    var view: any KernelSwiftTerminal.GenericView {
        if let primitiveView = self as? any KernelSwiftTerminal.PrimitiveView {
            return primitiveView
        }
        return KernelSwiftTerminal.ViewGraph.ComposedView(view: self)
    }
}
