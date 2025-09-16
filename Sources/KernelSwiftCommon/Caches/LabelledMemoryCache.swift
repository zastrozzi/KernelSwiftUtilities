//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/09/2023.
//

import Foundation
import Collections

public protocol LabelRepresentable: ExpressibleByStringLiteral, CaseIterable, Hashable, Identifiable, Sendable {
    var label: String { get }
}

extension LabelRepresentable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.label == rhs.label
    }
    
    public func hash(into hasher: inout Hasher) {
        label.hash(into: &hasher)
    }
    
    public var id: String { label }
    
    public init(stringLiteral value: String) {
        guard let labelCase = Self.allCases.first(where: { $0.label == value }) else {
            fatalError("LabelRepresentable: \(value) not found in \(Self.self)")
        }
        self = labelCase
    }
}

extension KernelSwiftCommon {
    public final class LabelledMemoryCache<K: LabelRepresentable & Sendable, Lock: LockRepresentable>: Sendable {
        nonisolated(unsafe) private var cacheStorage: TreeDictionary<K, any Sendable>
        nonisolated(unsafe) private var lock: Lock
        
        public enum LabelledMemoryCacheError: Error, CustomStringConvertible, LocalizedError {
            case valueNotFound(key: K)
            case valueNotConvertible(key: K, valueType: String)
            
            public var reason: String {
                switch self {
                case .valueNotFound(let key): return "Value not found for key \(key)"
                case .valueNotConvertible(let key, let value): return "Value not convertible to \(value) for key \(key)"
                }
            }
            
            public var description: String { "LabelMemoryCacheError: \(reason)" }
            public var errorDescription: String? { description }
        }
        
        public init() {
            self.cacheStorage = [:]
            self.lock = Lock.fromUnderlying()
        }
        
        public init(labelType: K.Type, lockType: Lock.Type) {
            self.cacheStorage = [:]
            self.lock = Lock.fromUnderlying()
        }
        
        public func get<V: Sendable>(_ key: K, as: V.Type) -> V? {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.cacheStorage[key] as? V
        }
        
        public func get(_ key: K) -> (any Sendable)? {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.cacheStorage[key]
        }
        
        public func require(_ key: K) throws -> any Sendable {
            self.lock.lock()
            defer { self.lock.unlock() }
            guard let value = self.cacheStorage[key] else { throw LabelledMemoryCacheError.valueNotFound(key: key) }
            return value
        }
        
        public func require<V: Sendable>(_ key: K, as: V.Type) throws -> V {
            self.lock.lock()
            defer { self.lock.unlock() }
            guard let value = self.cacheStorage[key] else { throw LabelledMemoryCacheError.valueNotFound(key: key) }
            guard let value = value as? V else { throw LabelledMemoryCacheError.valueNotConvertible(
                key: key,
                valueType: typeName(V.self))
            }
            return value
        }
        
        public func has(_ key: K) -> Bool {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.cacheStorage.keys.contains(key)
        }
        
        public func set<V: Sendable>(_ key: K, value: V) {
            self.lock.lock()
            defer { self.lock.unlock() }
            self.cacheStorage.updateValue(value, forKey: key)
        }
        
        public func set<V: Sendable>(_ parameters: Array<(key: K, value: V)>) {
            self.lock.lock()
            defer { self.lock.unlock() }
            parameters.forEach { parameter in
                self.cacheStorage.updateValue(parameter.value, forKey: parameter.key)
            }
        }
        
        public func unset(_ key: K) {
            self.lock.lock()
            defer { self.lock.unlock() }
            self.cacheStorage.removeValue(forKey: key)
        }
    }
}
