//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/11/2023.
//

import Foundation

@propertyWrapper
public enum Indirect<T> {
    indirect case wrapped(T)
    
    public init(wrappedValue initialValue: T) {
        self = .wrapped(initialValue)
    }
    
    public var wrappedValue: T {
        get {
            guard case let .wrapped(t) = self else { preconditionFailure("invalid indirection") }
            return t
        }
        set { self = .wrapped(newValue) }
    }
}
