//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/09/2023.
//

import Foundation

@dynamicMemberLookup
public final class LockIsolated<Value: Sendable>: Sendable {
    nonisolated(unsafe) private var _value: Value
    private let lock = NSRecursiveLock()
    
    public init(_ value: @autoclosure @Sendable () throws -> Value) rethrows {
        self._value = try value()
    }
    
    public subscript<Subject: Sendable>(dynamicMember keyPath: KeyPath<Value, Subject>) -> Subject {
        self.lock.sync {
            self._value[keyPath: keyPath]
        }
    }
    
    public func withValue<T: Sendable>(_ operation: (inout Value) throws -> T) rethrows -> T {
        try self.lock.sync(work: {
            var value = self._value
            defer { self._value = value }
            return try operation(&value)
        })
    }
    
    public func setValue(_ newValue: @autoclosure @Sendable () throws -> Value) rethrows {
        try self.lock.sync {
            self._value = try newValue()
        }
    }
    
    public func updateValue<Subject: Sendable>(dynamicMember keyPath: WritableKeyPath<Value, Subject>, newValue: Subject) {
        self.lock.sync {
            self._value[keyPath: keyPath] = newValue
        }
    }
}

extension LockIsolated where Value: Sendable {
    public var value: Value {
        self.lock.sync {
            self._value
        }
    }
}

extension LockIsolated: Equatable where Value: Equatable {
    public static func == (lhs: LockIsolated, rhs: LockIsolated) -> Bool {
        lhs.withValue { lhsVal in
            rhs.withValue { rhsVal in
                lhsVal == rhsVal
            }
        }
    }
}

extension LockIsolated: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.withValue { hasher.combine($0) }
    }
}

extension NSRecursiveLock {
    @inlinable @discardableResult
    @_spi(Internals) public func sync<Result>(work: () throws -> Result) rethrows -> Result {
        self.lock()
        defer { self.unlock() }
        return try work()
    }
}
