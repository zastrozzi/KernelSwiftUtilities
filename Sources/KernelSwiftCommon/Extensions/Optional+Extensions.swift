//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/02/2022.
//

import Foundation

public extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        guard let strongSelf = self else {
            return true
        }
        
        return strongSelf.isEmptyOrBlank
    }
}

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
    
    var nonEmpty: Wrapped? {
        isNilOrEmpty ? nil : self
    }
}

extension Optional {
    public func unwrap(or someValue: Wrapped) -> Wrapped {
        return self ?? someValue
    }
    
    public func unwrap<T>(either transform: (Wrapped) -> T, or someValue: T) -> T {
        return map(transform) ?? someValue
    }
    
    public func unwrap<T>(either keyPath: KeyPath<Wrapped, T>, or someValue: T) -> T {
        return unwrap(either: { $0[keyPath: keyPath] }, or: someValue)
    }
    
    public func unwrap<T>(either keyPath: KeyPath<Wrapped, T?>, or someValue: T) -> T {
        return unwrap(either: { $0[keyPath: keyPath] ?? someValue }, or: someValue)
    }
    
    public func unwrapIfPresent<T>(either transform: (Wrapped) -> T, or someValue: T? = nil) -> T? {
        return map(transform) ?? someValue
    }
    
    public func unwrapIfPresent<T>(either transform: (Wrapped) -> T?, or someValue: T? = nil) -> T? {
        return map(transform) ?? someValue
    }
    
    public func unwrapConditionally(where predicate: (Wrapped) -> Bool) -> Wrapped? {
        return unwrap(either: { predicate($0) ? $0 : nil }, or: nil)
    }
}

public extension Optional {
    func `continue`(ifPresent operation: (Wrapped) -> Void, else elseOperation: (() -> Void)? = nil) {
        if let value = self {
            operation(value)
        } else {
            elseOperation?()
        }
    }
}
