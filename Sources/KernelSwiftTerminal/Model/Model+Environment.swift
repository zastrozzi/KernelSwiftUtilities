//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Model {
    @propertyWrapper
    public struct Environment<T>: _KernelSwiftTerminalAnyEnvironment {
        let keyPath: KeyPath<EnvironmentValues, T>
        
        public init(_ keyPath: KeyPath<EnvironmentValues, T>) {
            self.keyPath = keyPath
        }
        
        var valueReference = EnvironmentReference()
        
        public var wrappedValue: T {
            get {
                guard let node = valueReference.node else {
                    assertionFailure("Attempting to access @Environment variable before view is instantiated")
                    return EnvironmentValues()[keyPath: keyPath]
                }
                let environmentValues = makeEnvironment(node: node, transform: { _ in })
                return environmentValues[keyPath: self.keyPath]
            }
            set {}
        }
        
        private func makeEnvironment(node: KernelSwiftTerminal.ViewGraph.Node, transform: (inout EnvironmentValues) -> Void) -> EnvironmentValues {
            if let parent = node.parent {
                return makeEnvironment(node: parent) {
                    node.environment?(&$0)
                    transform(&$0)
                }
            }
            var environmentValues = EnvironmentValues()
            node.environment?(&environmentValues)
            transform(&environmentValues)
            return environmentValues
        }
    }
    
    
    
    class EnvironmentReference {
        weak var node: KernelSwiftTerminal.ViewGraph.Node?
    }
}

protocol _KernelSwiftTerminalAnyEnvironment {
    var valueReference: KernelSwiftTerminal.Model.EnvironmentReference { get }
}

extension KernelSwiftTerminal.ViewGraph.View {
    func setupEnvironmentProperties(node: KernelSwiftTerminal.ViewGraph.Node) {
        for (_, value) in Mirror(reflecting: self).children {
            if let environmentValue = value as? _KernelSwiftTerminalAnyEnvironment {
                environmentValue.valueReference.node = node
            }
        }
    }
}
