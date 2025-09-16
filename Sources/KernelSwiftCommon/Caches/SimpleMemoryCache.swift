//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/09/2023.
//

import Foundation
import Collections

extension KernelSwiftCommon {
    public final class SimpleMemoryCache<K: Hashable & Sendable, V: Sendable, Lock: LockRepresentable>: Sendable {
        nonisolated(unsafe) private var cacheStorage: TreeDictionary<K, V>
        nonisolated(unsafe) private var lock: Lock
        
        public enum SimpleMemoryCacheError: Error {
            case notFound(key: K)
        }
        
        public init() {
            self.cacheStorage = [:]
            self.lock = Lock.fromUnderlying()
        }
        
        public func keys() -> [K] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return .init(self.cacheStorage.keys)
        }
        
        public func get(_ key: K) -> V? {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.cacheStorage[key]
        }
        
        public func require(_ key: K) throws -> V {
            self.lock.lock()
            defer { self.lock.unlock() }
            if let value = self.cacheStorage[key] {
                return value
            } else {
                throw SimpleMemoryCacheError.notFound(key: key)
            }
        }
        
        public func takeFirst() -> V? {
            self.lock.lock()
            defer { self.lock.unlock() }
            guard self.cacheStorage.count > 0  else { return nil }
            return self.cacheStorage.remove(at: self.cacheStorage.startIndex).value
        }
        
        public func has(_ key: K) -> Bool {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.cacheStorage.keys.contains(key)
        }
        
        @discardableResult
        public func set(_ key: K, value: V) -> V {
            self.lock.lock()
            defer { self.lock.unlock() }
            self.cacheStorage.updateValue(value, forKey: key)
            return value
        }
        
        public func unset(_ key: K) {
            self.lock.lock()
            defer { self.lock.unlock() }
            self.cacheStorage.removeValue(forKey: key)
        }
        
        public func update(_ key: K, operation: (inout V) -> Void) {
            self.lock.lock()
            defer { self.lock.unlock() }
            guard self.cacheStorage.keys.contains(key) else { return }
            operation(&self.cacheStorage[key]!)
        }
        
        public func all() -> [V] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return Array(self.cacheStorage.values)
        }
        
        public func paginated<Property: Comparable>(
            limit: Int? = nil,
            offset: Int? = nil,
            order: SortOrder = .forward,
            orderBy propertyPath: KeyPath<V, Property>
        ) -> ([V], Int) {
            self.lock.lock()
            defer { self.lock.unlock() }
            let allValues = cacheStorage.values
                .sorted(propertyPath, order: order)
            return (Array(
                allValues.dropFirst(offset ?? 0)
                .prefix(limit ?? cacheStorage.values.count)
            ), allValues.count)
        }
        
        public func paginated(
            limit: Int? = nil,
            offset: Int? = nil,
            order: SortOrder = .forward,
            orderBy propertyPath: String
        ) -> ([V], Int) where V: DynamicPropertyAccessible {
            self.lock.lock()
            defer { self.lock.unlock() }
            let allValues = cacheStorage.values
                .sorted(propertyPath, order: order)
            return (Array(
                allValues.dropFirst(offset ?? 0)
                    .prefix(limit ?? cacheStorage.values.count)
            ), allValues.count)
        }
        
        public func paginatedFilter<Property: Comparable>(
            limit: Int? = nil,
            offset: Int? = nil,
            order: SortOrder = .forward,
            orderBy propertyPath: KeyPath<V, Property>,
            selector: (V) throws -> Bool
        ) throws -> ([V], Int) {
            self.lock.lock()
            defer { self.lock.unlock() }
            let filteredValues = try cacheStorage.values
                .filter(selector)
                .sorted(propertyPath, order: order)
            return (Array(
                filteredValues
                    .dropFirst(offset ?? 0)
                    .prefix(limit ?? cacheStorage.values.count)
            ), filteredValues.count)
        }
        
        public func paginatedFilter(
            limit: Int? = nil,
            offset: Int? = nil,
            order: SortOrder = .forward,
            orderBy propertyPath: String,
            selector: (V) throws -> Bool
        ) throws -> ([V], Int) where V: DynamicPropertyAccessible {
            self.lock.lock()
            defer { self.lock.unlock() }
            let filteredValues = try cacheStorage.values
                .filter(selector)
                .sorted(propertyPath, order: order)
            return (Array(
                filteredValues
                    .dropFirst(offset ?? 0)
                    .prefix(limit ?? cacheStorage.values.count)
            ), filteredValues.count)
        }
        
        public func filter(selector: (V) throws -> Bool) throws -> [V] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return try self.cacheStorage.values.filter(selector)
        }
        
        public func filterEntries(selector: (K, V) throws -> Bool) throws -> [(K, V)] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return try self.cacheStorage.filter(selector)
        }
        
        public var count: Int {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.cacheStorage.count
        }
        
        public func reset() {
            self.lock.lock()
            defer { self.lock.unlock() }
            self.cacheStorage = [:]
        }
    }
}
