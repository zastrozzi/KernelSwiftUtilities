//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/04/2023.
//

import Foundation

@dynamicMemberLookup
public protocol PartialProtocol<Wrapped> {
    associatedtype Wrapped
    init()
    func value<V>(for keyPath: KeyPath<Wrapped, V>) throws -> V
    mutating func setValue<V>(_ value: V, for keyPath: KeyPath<Wrapped, V>)
    mutating func removeValue<V>(for keyPath: KeyPath<Wrapped, V>)
}

extension PartialProtocol  {
    
    mutating func setValue<V, P: PartialProtocol<V>>(_ partial: P, for keyPath: KeyPath<Wrapped, V>, unwrapper: (_ partial: P) throws -> V) rethrows {
        let value = try unwrapper(partial)
        setValue(value, for: keyPath)
    }

    mutating func setValue<V, P: PartialProtocol<V>>(_ partial: P, for keyPath: KeyPath<Wrapped, V?>, unwrapper: (_ partial: P) throws -> V) rethrows {
        let value = try unwrapper(partial)
        setValue(value, for: keyPath)
    }

    mutating func setValue<V: PartialConvertible, P: PartialProtocol<V>>(
        _ partial: P,
        for keyPath: KeyPath<Wrapped, V>,
        customUnwrapper unwrapper: (_ partial: P) throws -> V = V.init(partial:)
    ) rethrows {
        try setValue(partial, for: keyPath, unwrapper: unwrapper)
    }

    mutating func setValue<V: PartialConvertible, P: PartialProtocol<V>>(
        _ partial: P,
        for keyPath: KeyPath<Wrapped, V?>,
        customUnwrapper unwrapper: (_ partial: P) throws -> V = V.init(partial:)
    ) rethrows {
        try setValue(partial, for: keyPath, unwrapper: unwrapper)
    }

    public subscript<V>(keyPath: KeyPath<Wrapped, V>) -> V? {
        get {
            return try? self.value(for: keyPath)
        }
        set {
            if let newValue = newValue {
                setValue(newValue, for: keyPath)
            } else {
                removeValue(for: keyPath)
            }
        }
    }

    public subscript<V>(dynamicMember keyPath: KeyPath<Wrapped, V>) -> V? {
        get {
            return try? self.value(for: keyPath)
        }
        set {
            if let newValue = newValue {
                setValue(newValue, for: keyPath)
            } else {
                removeValue(for: keyPath)
            }
        }
    }
}

extension PartialProtocol where Wrapped: PartialConvertible {

    /// Attempts to initialise a new `Wrapped` with self
    ///
    /// Any errors thrown by `Wrapped.init(partial:)` will be rethrown
    ///
    /// - Returns: The new `Wrapped` instance
    public func unwrapped() throws -> Wrapped {
        return try Wrapped(partial: self)
    }

}
