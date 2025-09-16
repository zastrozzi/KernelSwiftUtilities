//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

#if os(macOS)
import Foundation
import Combine
import KernelSwiftCommon

extension KernelSwiftTerminal.Model {
    @propertyWrapper
    public struct ObservedObject<T: ObservableObject>: _KernelSwiftTerminalAnyObservedObject {
        public let initialValue: T
        
        public init(initialValue: T) {
            self.initialValue = initialValue
        }
        
        public init(wrappedValue: T) {
            self.initialValue = wrappedValue
        }
        
        public var wrappedValue: T { initialValue }
        
        func subscribe(_ action: @escaping () -> Void) -> AnyCancellable {
            initialValue.objectWillChange.sink(receiveValue: { _ in action() })
        }
    }
    
    
}

protocol _KernelSwiftTerminalAnyObservedObject {
    func subscribe(_ action: @escaping () -> Void) -> AnyCancellable
}

extension KernelSwiftTerminal.ViewGraph.View {
    func setupObservedObjectProperties(node: KernelSwiftTerminal.ViewGraph.Node) {
        let viewGraph = KernelDI.inject(\.viewGraph)
        for (label, value) in Mirror(reflecting: self).children {
            if let label, let observedObject = value as? _KernelSwiftTerminalAnyObservedObject {
                node.subscriptions[label] = observedObject.subscribe {
                    viewGraph.invalidateNode(node)
                }
            }
        }
    }
}
#endif
