//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation
import Collections

public protocol _KernelSwiftCommonMemoryCacheTaggable: Hashable, CaseIterable, Equatable {}

extension KernelSwiftCommon {
    public typealias MemoryCacheTaggable = _KernelSwiftCommonMemoryCacheTaggable
}

extension KernelSwiftCommon {
    public final class TaggedMemoryCache<T: Hashable & CaseIterable & Equatable, K: Hashable & Equatable, V: Sendable, Lock: LockRepresentable>: Sendable {
        nonisolated(unsafe) private var keyValueStorage: TreeDictionary<K, V>
        nonisolated(unsafe) private var tagKeyStorage: TreeDictionary<T, Set<K>>
        nonisolated(unsafe) private var keyTagStorage: TreeDictionary<K, Set<T>>
        nonisolated(unsafe) private var lock: Lock
        
        public enum MatchingMode {
            case inclusive
            case exclusive
        }
        
        public struct Entry {
            public var key: K
            public var tags: Set<T>
            public var value: V
            
            public init(
                key: K,
                tags: Set<T>,
                value: V
            ) {
                self.key = key
                self.tags = tags
                self.value = value
            }
        }
        
        public init() {
            self.keyValueStorage = [:]
            self.tagKeyStorage = T.allCases.reduce(into: [:], { acc, next in
                acc[next] = []
            })
            self.keyTagStorage = [:]
            self.lock = Lock.fromUnderlying()
        }
        
        public func keys() -> [K] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return .init(self.keyValueStorage.keys)
        }
        
        public func keys(where condition: (K) -> Bool) -> [K] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return .init(self.keyValueStorage.keys.filter(condition))
        }
        
        public func keys(for tags: Set<T>, mode: MatchingMode = .inclusive) -> [K] {
            self.lock.lock()
            defer { self.lock.unlock() }
            var isFirst = true
            let keys = switch mode {
            case .exclusive: tags
                    .reduce(into: Set<K>()) {
                        isFirst ? $0.formUnion(self.tagKeyStorage[$1, default: []]) : $0.formIntersection(self.tagKeyStorage[$1, default: $0])
                        isFirst = false
                    }
            case .inclusive: tags.reduce(into: Set<K>()) { $0.formUnion(self.tagKeyStorage[$1, default: []]) }
            }
            return .init(keys)
        }
        
        public func keys(for tag: T) -> [K] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return .init(self.tagKeyStorage[tag, default: []])
        }
        
        public func keys(for tag: T, where condition: (K) -> Bool) -> [K] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return .init(self.tagKeyStorage[tag, default: []].filter(condition))
        }
        
        public func closestKey(for tags: Set<T>, mode: MatchingMode = .inclusive, ignoreLock: Bool = false) -> K? {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.keyTagStorage.compactMap { entry -> (K, Int, Int)? in
                if mode == .exclusive { guard entry.value.contains(tags) else { return nil } }
                return (entry.key, entry.value.intersection(tags).count, abs(entry.value.count - tags.count))
            }.sorted { $0.1 == $1.1 ? ($0.2 < $1.2) : ($0.1 > $1.1) }.first?.0
        }
        
        public func tags() -> Set<T> {
            self.lock.lock()
            defer { self.lock.unlock() }
            return .init(self.tagKeyStorage.keys)
        }
        
        public func tags(where condition: (T) -> Bool) -> Set<T> {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.tags().filter(condition)
        }
        
        public func tags(for key: K) -> Set<T> {
            self.lock.lock()
            defer { self.lock.unlock() }
            
            return self.keyTagStorage[key, default: []]
        }
        
        public func tags(for key: K, where condition: (T) -> Bool) -> Set<T> {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.keyTagStorage[key, default: []].filter(condition)
        }
        
        public func tags(for keys: Set<K>, mode: MatchingMode = .inclusive) -> Set<T> {
            self.lock.lock()
            defer { self.lock.unlock() }
            var isFirst = true
            return switch mode {
            case .exclusive: keys
                    .reduce(into: Set<T>()) {
                        isFirst ? $0.formUnion(self.keyTagStorage[$1, default: $0]) : $0.formIntersection(self.keyTagStorage[$1, default: $0])
                        isFirst = false
                    }
            case .inclusive: keys.reduce(into: Set<T>()) { $0.formUnion(self.keyTagStorage[$1, default: []]) }
            }
        }
        
        public func has(_ key: K) -> Bool {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.keyValueStorage.keys.contains(key)
        }
        
        public func set(_ key: K, tag: T, value: V) {
            self.lock.lock()
            defer { self.lock.unlock() }
            self.keyValueStorage.updateValue(value, forKey: key)
            self.keyTagStorage.updateValue([tag], forKey: key)
            self.tagKeyStorage[tag, default: []].insert(key)
        }
        
        public func set(_ key: K, tags: Set<T>, value: V) {
            self.lock.lock()
            defer { self.lock.unlock() }
            self.keyValueStorage.updateValue(value, forKey: key)
            self.keyTagStorage.updateValue(tags, forKey: key)
            for tag in tags { self.tagKeyStorage[tag, default: []].insert(key) }
        }
        
        public func remove(_ key: K, ignoreLock: Bool = false) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            self.keyValueStorage.removeValue(forKey: key)
            let tags = self.keyTagStorage.removeValue(forKey: key)
            for tag in (tags ?? []) {
                self.tagKeyStorage[tag, default: []].remove(key)
            }
        }
        
        public func remove(_ keys: Set<K>, ignoreLock: Bool = false) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            for key in keys { remove(key, ignoreLock: true) }
        }
        
        public func remove(_ tags: Set<T>, mode: MatchingMode = .inclusive) {
            self.lock.lock()
            defer { self.lock.unlock() }
            let keys: Set<K> = switch mode {
            case .inclusive: tags.reduce(into: Set<K>()) { $0.formUnion(tagKeyStorage[$1, default: []]) }
            case .exclusive: .init(keyTagStorage.compactMap { $0.value.contains(tags) ? $0.key : nil })
            }
            remove(keys, ignoreLock: true)
        }
        
        public func remove(where condition: (K) -> Bool) {
            let keysToRemove = keys(where: condition)
            self.lock.lock()
            defer { self.lock.unlock() }
            remove(.init(keysToRemove), ignoreLock: true)
//            self.keyValueStorage.removeAll { condition($0.key) }
//            self.keyTagStorage.removeAll { condition($0.key) }
//            self.tagKeyStorage.forEach { tagKey in
//                tagKey.value.forEach { key in
//                    if condition(key) {
//                        self.tagKeyStorage[tagKey.key]?.remove(key)
//                    }
//                }
//            }
        }
        
        public func setTag(_ key: K, tag: T) {
            self.lock.lock()
            defer { self.lock.unlock() }
            guard self.keyTagStorage[key] != nil else { return }
            self.keyTagStorage[key]?.insert(tag)
            self.tagKeyStorage[tag, default: []].insert(key)
        }
        
        public func setTag(_ keys: Set<K>, tag: T) {
            self.lock.lock()
            defer { self.lock.unlock() }
            var keys = keys
            for key in keys {
                guard self.keyTagStorage[key] != nil else {
                    keys.remove(key)
                    continue
                }
                self.keyTagStorage[key]?.insert(tag)
            }
            self.tagKeyStorage[tag, default: []].formUnion(keys)
        }
        
        public func setTags(_ key: K, tags: Set<T>) {
            self.lock.lock()
            defer { self.lock.unlock() }
            guard self.keyTagStorage[key] != nil else { return }
            self.keyTagStorage[key]?.formUnion(tags)
            for tag in tags { self.tagKeyStorage[tag, default: []].insert(key) }
        }
        
        public func setTags(_ keys: Set<K>, tags: Set<T>) {
            self.lock.lock()
            defer { self.lock.unlock() }
            var keys = keys
            for key in keys {
                guard self.keyTagStorage[key] != nil else {
                    keys.remove(key)
                    continue
                }
                self.keyTagStorage[key]?.formUnion(tags)
            }
            for tag in tags { self.tagKeyStorage[tag, default: []].formUnion(keys) }
        }
        
        public func removeTag(_ key: K, tag: T) {
            self.lock.lock()
            defer { self.lock.unlock() }
            self.keyTagStorage[key]?.remove(tag)
            self.tagKeyStorage[tag]?.remove(key)
        }
        
        public func removeTag(_ key: K, where condition: (T) -> Bool) {
            self.lock.lock()
            defer { self.lock.unlock() }
            for tag in self.keyTagStorage[key, default: []] {
                if condition(tag) {
                    self.keyTagStorage[key]?.remove(tag)
                    self.tagKeyStorage[tag]?.remove(key)
                }
            }
        }
        
        public func removeTag(_ keys: Set<K>, tag: T) {
            self.lock.lock()
            defer { self.lock.unlock() }
            for key in keys { self.keyTagStorage[key]?.remove(tag) }
            self.tagKeyStorage[tag]?.subtract(keys)
        }
        
        public func removeTags(_ key: K, tags: Set<T>) {
            self.lock.lock()
            defer { self.lock.unlock() }
            self.keyTagStorage[key]?.subtract(tags)
            for tag in tags { self.tagKeyStorage[tag]?.remove(key) }
        }
        
        public func removeTags(_ keys: Set<K>, tags: Set<T>) {
            self.lock.lock()
            defer { self.lock.unlock() }
            for key in keys { self.keyTagStorage[key]?.subtract(tags) }
            for tag in tags { self.tagKeyStorage[tag]?.subtract(keys) }
        }
        
        public func replaceTag(_ key: K, tag: T) {
            self.lock.lock()
            defer { self.lock.unlock() }
            guard self.keyTagStorage[key] != nil else { return }
            for oldTag in T.allCases { self.tagKeyStorage[oldTag]?.remove(key) }
            self.keyTagStorage[key] = [tag]
            self.tagKeyStorage[tag, default: []].insert(key)
        }
        
        public func replaceTags(_ key: K, tags: Set<T>) {
            self.lock.lock()
            defer { self.lock.unlock() }
            guard self.keyTagStorage[key] != nil else { return }
            for oldTag in T.allCases { self.tagKeyStorage[oldTag]?.remove(key) }
            self.keyTagStorage[key] = tags
            for tag in tags { self.tagKeyStorage[tag, default: []].insert(key) }
        }
        
        public func update(_ tag: T, operation: (inout V) -> Void) {
            self.lock.lock()
            defer { self.lock.unlock() }
            update(tagKeyStorage[tag, default: []], ignoreLock: true, operation: operation)
        }
        
        public func update(_ tags: Set<T>, mode: MatchingMode = .inclusive, operation: (inout V) -> Void) {
            self.lock.lock()
            defer { self.lock.unlock() }
            let keys: Set<K> = switch mode {
            case .inclusive: tags.reduce(into: Set<K>()) { $0.formUnion(tagKeyStorage[$1, default: []]) }
            case .exclusive: .init(keyTagStorage.compactMap { $0.value.contains(tags) ? $0.key : nil })
            }
            update(keys, ignoreLock: true, operation: operation)
        }
        
        public func update(_ key: K, ignoreLock: Bool = false, operation: (inout V) -> Void) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            guard self.keyValueStorage.keys.contains(key) else { return }
            operation(&self.keyValueStorage[key]!)
        }
        
        public func update(_ keys: Set<K>, ignoreLock: Bool = false, operation: (inout V) -> Void) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            for key in keys { update(key, ignoreLock: true, operation: operation) }
        }
        
        public func value(_ key: K) -> V? {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.keyValueStorage[key]
        }
        
        public func values() -> [V] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return Array(self.keyValueStorage.values)
        }
        
        public func values(for tag: T) -> [V] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.tagKeyStorage[tag, default: []].compactMap { key in
                self.keyValueStorage[key]
            }
        }
        
        public func values(for tags: Set<T>, mode: MatchingMode = .inclusive) -> [V] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.keyTagStorage
                .compactMap {
                    switch mode {
                    case .exclusive: $0.value.contains(tags) ? $0.key : nil
                    case .inclusive: $0.value.intersection(tags).isEmpty ? nil : $0.key
                    }
                }
                .uniqued()
                .compactMap { self.keyValueStorage[$0] }
        }
        
        public func values(where valuePredicate: (V) throws -> Bool) throws -> [V] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return try keyValueStorage.values
                .filter(valuePredicate)
        }
        
        public func entry(_ key: K, ignoreLock: Bool = false) -> Entry? {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            guard let value = self.keyValueStorage[key] else { return nil }
            let tags = self.keyTagStorage[key, default: []]
            return .init(key: key, tags: tags, value: value)
        }
        
        public func entries() -> [Entry] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.keyValueStorage.map { keyValue in
                .init(key: keyValue.key, tags: self.keyTagStorage[keyValue.key, default: []], value: keyValue.value)
            }
        }
        
        public func entries(for tag: T) -> [Entry] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.tagKeyStorage[tag, default: []].compactMap { key in
                entry(key, ignoreLock: true)
            }
        }
        
        public func entries(for tags: Set<T>, mode: MatchingMode = .inclusive) -> [Entry] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.keyTagStorage
                .compactMap {
                    switch mode {
                    case .exclusive: $0.value.contains(tags) ? $0.key : nil
                    case .inclusive: $0.value.intersection(tags).isEmpty ? nil : $0.key
                    }
                }
                .uniqued()
                .compactMap { entry($0, ignoreLock: true) }
        }
        
        public func entries(forTags tags: Set<T>, forKeys keys: [K], mode: MatchingMode = .inclusive) -> [Entry] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.keyTagStorage
                .filter { keys.contains($0.key) }
                .compactMap {
                    switch mode {
                    case .exclusive: $0.value.contains(tags) ? $0.key : nil
                    case .inclusive: $0.value.intersection(tags).isEmpty ? nil : $0.key
                    }
                }
                .uniqued()
                .compactMap { entry($0, ignoreLock: true) }
        }
        
        public func entries(where valuePredicate: (V) -> Bool) -> [Entry] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return keyValueStorage
                .filter { valuePredicate($0.value) }
                .map {
                    .init(key: $0.key, tags: keyTagStorage[$0.key, default: []], value: $0.value)
                }
        }
        
        public func takeFirst(for tag: T) -> V? {
            self.lock.lock()
            defer { self.lock.unlock() }
            guard
                let key = self.tagKeyStorage[tag]?.removeFirst(),
                let value = self.keyValueStorage.removeValue(forKey: key)
            else { return nil }
            keyTagStorage.removeValue(forKey: key)
            return value
        }
        
        public func takeFirst(for tags: Set<T>, mode: MatchingMode = .inclusive) -> V? {
            self.lock.lock()
            defer { self.lock.unlock() }
            guard
                let key = self.closestKey(for: tags, mode: mode, ignoreLock: true),
                let value = self.keyValueStorage.removeValue(forKey: key)
            else { return nil }
            keyTagStorage.removeValue(forKey: key)
            return value
        }
        
        public var count: Int {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.keyValueStorage.count
        }
        
        public func count(for tag: T) -> Int {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.tagKeyStorage[tag, default: []].count
        }
        
        public func count(for tags: Set<T>, mode: MatchingMode = .inclusive) -> Int {
            lock.lock()
            defer { lock.unlock() }
            return switch mode {
            case .exclusive: keyTagStorage.compactMap { $0.value.contains(tags) ? $0.key : nil }.uniqueCount()
            case .inclusive: tags.reduce(into: Set<K>()) { $0.formUnion(tagKeyStorage[$1, default: []]) }.count
            }
        }
    }
}
