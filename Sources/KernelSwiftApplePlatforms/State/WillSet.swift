//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/08/2022.
//

import Foundation
import Combine

@propertyWrapper
public struct WillSet<Value> {
    public static subscript<T: ObservableObject>(
        _enclosingInstance instance: T,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<T, Self>
    ) -> Value {
        get { instance[keyPath: storageKeyPath].storage }
        set {
            if let publisher = instance.objectWillChange as? ObservableObjectPublisher {
                publisher.send()
                instance[keyPath: storageKeyPath].storage = newValue
            } else {
                preconditionFailure("Failed to set property on enclosing instance via WillSet")
            }
        }
    }
    
    @available(*, unavailable, message: "@WillSet can only be applied to classes")
    public var wrappedValue: Value {
        get { preconditionFailure("@WillSet can only be applied to classes") }
        set { preconditionFailure("@WillSet can only be applied to classes") }
    }
    
    private var storage: Value
    
    public init(wrappedValue: Value) {
        storage = wrappedValue
    }
}
