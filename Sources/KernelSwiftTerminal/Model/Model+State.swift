//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelSwiftTerminal.Model {
    @propertyWrapper
    public struct State<T>: _KernelSwiftTerminalAnyState {
        public let initialValue: T
        
        public init(initialValue: T) {
            self.initialValue = initialValue
        }
        
        public init(wrappedValue: T) {
            self.initialValue = wrappedValue
        }
        
        var valueReference = StateReference()
        
        public var wrappedValue: T {
            get {
                guard let node = valueReference.node,
                      let label = valueReference.label
                else {
                    assertionFailure("Attempting to access @State variable before view is instantiated")
                    return initialValue
                }
                if let value = node.state[label] {
                    return value as! T
                }
                return initialValue
            }
            nonmutating set {
                guard let node = valueReference.node,
                      let label = valueReference.label
                else {
                    assertionFailure("Attempting to modify @State variable before view is instantiated")
                    return
                }
                node.state[label] = newValue
                KernelDI.inject(\.viewGraph).invalidateNode(node)
            }
        }
        
        public var projectedValue: Binding<T> {
            // Note: this works, but it is not as efficient as in SwiftUI.
            // In SwiftUI, Bindings can actively observe state. If you have a
            // @State variable in a view that is not directly used in the body,
            // but only in child views through @Bindings, updating the @Bindings
            // will only invalidate the child views.
            Binding<T>(get: { wrappedValue }, set: { wrappedValue = $0 })
        }
    }
    
    
    
    class StateReference {
        weak var node: KernelSwiftTerminal.ViewGraph.Node?
        var label: String?
    }
}

protocol _KernelSwiftTerminalAnyState {
    var valueReference: KernelSwiftTerminal.Model.StateReference { get }
}

extension KernelSwiftTerminal.ViewGraph.View {
    func setupStateProperties(node: KernelSwiftTerminal.ViewGraph.Node) {
        for (label, value) in Mirror(reflecting: self).children {
            if let stateValue = value as? _KernelSwiftTerminalAnyState {
                // Note: this is not how SwiftUI handles state.
                // This will break if you initialize a View, and then use it
                // multiple times, because we would be editing the same View.
                stateValue.valueReference.node = node
                stateValue.valueReference.label = label
            }
        }
    }
}
