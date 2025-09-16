//
//  File.swift
//
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation
import Collections

public protocol _KernelSwiftCommonDatedMemoryCacheTaggable: Hashable, CaseIterable, Equatable {}

extension KernelSwiftCommon {
    public typealias DatedMemoryCacheTaggable = _KernelSwiftCommonDatedMemoryCacheTaggable
}

extension KernelSwiftCommon {
    public final class TaggedDatedMemoryCache<T: Hashable & CaseIterable & Equatable, K: Hashable & Equatable, V: Sendable, Lock: LockRepresentable>: Sendable {
        nonisolated(unsafe) private var dateKeyValueStorage: TreeDictionary<DateKey, V>
        nonisolated(unsafe) private var tagDateKeyStorage: TreeDictionary<T, Set<DateKey>>
        nonisolated(unsafe) private var dateKeyTagStorage: TreeDictionary<DateKey, Set<T>>
        nonisolated(unsafe) private var lock: Lock
        
        public enum MatchingMode {
            case inclusive
            case exclusive
        }
        
        public struct DateKey: Hashable, Equatable {
            public var key: K
            public var date: Date
            
            public init(
                key: K,
                date: Date
            ) {
                self.key = key
                self.date = date
            }
        }
        
        public struct DateValue {
            public var date: Date
            public var value: V
            
            public init(
                date: Date,
                value: V
            ) {
                self.date = date
                self.value = value
            }
        }
        
        public struct Entry {
            public var key: K
            public var date: Date
            public var tags: Set<T>
            public var value: V
            
            public init(
                key: K,
                date: Date,
                tags: Set<T>,
                value: V
            ) {
                self.key = key
                self.date = date
                self.tags = tags
                self.value = value
            }
        }
        
        public init() {
            self.dateKeyValueStorage = [:]
            self.tagDateKeyStorage = T.allCases.reduce(into: [:], { acc, next in
                acc[next] = []
            })
            self.dateKeyTagStorage = [:]
            self.lock = Lock.fromUnderlying()
        }
        
        public func keys(
            ignoreLock: Bool = false
        ) -> [K] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return .init(self.dateKeyValueStorage.keys.map(\.key))
        }
        
        public func keys(
            ignoreLock: Bool = false,
            where condition: (K) -> Bool
        ) -> [K] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return .init(self.dateKeyValueStorage.keys.map(\.key).filter(condition))
        }
        
        public func keys(
            for tags: Set<T>,
            mode: MatchingMode = .inclusive,
            ignoreLock: Bool = false
        ) -> [K] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            var isFirst = true
            let keys = switch mode {
            case .exclusive: tags
                    .reduce(into: Set<DateKey>()) {
                        isFirst ? $0.formUnion(self.tagDateKeyStorage[$1, default: []]) : $0.formIntersection(self.tagDateKeyStorage[$1, default: $0])
                        isFirst = false
                    }
            case .inclusive: tags.reduce(into: Set<DateKey>()) { $0.formUnion(self.tagDateKeyStorage[$1, default: []]) }
            }
            return .init(keys.map(\.key))
        }
        
        public func keys(
            for tag: T,
            ignoreLock: Bool = false
        ) -> [K] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return .init(self.tagDateKeyStorage[tag, default: []].map(\.key))
        }
        
        public func keys(
            for tag: T,
            ignoreLock: Bool = false,
            where condition: (DateKey) -> Bool
        ) -> [K] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return .init(self.tagDateKeyStorage[tag, default: []].filter(condition).map(\.key))
        }
        
        public func dateKeys(
            ignoreLock: Bool = false
        ) -> [DateKey] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return .init(self.dateKeyValueStorage.keys)
        }
        
        public func dateKeys(
            ignoreLock: Bool = false,
            where condition: (DateKey) -> Bool
        ) -> [DateKey] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return .init(self.dateKeyValueStorage.keys.filter(condition))
        }
        
        public func dateKeys(
            ignoreLock: Bool = false,
            where condition: (Date) -> Bool
        ) -> [DateKey] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return .init(self.dateKeyValueStorage.keys.filter { condition($0.date) })
        }
        
        public func dateKeys(
            for tag: T,
            ignoreLock: Bool = false,
            where condition: (DateKey) -> Bool
        ) -> [DateKey] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return .init(self.tagDateKeyStorage[tag, default: []].filter(condition))
        }
        
        public func closestDateKey(
            for tags: Set<T>,
            mode: MatchingMode = .inclusive,
            ignoreLock: Bool = false
        ) -> DateKey? {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.dateKeyTagStorage.compactMap { entry -> (DateKey, Int, Int)? in
                if mode == .exclusive { guard entry.value.contains(tags) else { return nil } }
                return (entry.key, entry.value.intersection(tags).count, abs(entry.value.count - tags.count))
            }.sorted { $0.1 == $1.1 ? ($0.2 < $1.2) : ($0.1 > $1.1) }.first?.0
        }
        
        public func closestKey(
            for tags: Set<T>,
            mode: MatchingMode = .inclusive,
            ignoreLock: Bool = false
        ) -> K? {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return closestDateKey(for: tags, mode: mode, ignoreLock: ignoreLock)?.key
        }
        
        public func tags(
            ignoreLock: Bool = false
        ) -> Set<T> {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return .init(self.tagDateKeyStorage.keys)
        }
        
        public func tags(
            ignoreLock: Bool = false,
            where condition: (T) -> Bool
        ) -> Set<T> {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.tags().filter(condition)
        }
        
        public func tags(
            for key: K,
            ignoreLock: Bool = false
        ) -> Set<T> {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.keyTags[key, default: []]
        }
        
        public func tags(
            for key: DateKey,
            ignoreLock: Bool = false
        ) -> Set<T> {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.dateKeyTagStorage[key, default: []]
        }
        
        public func tags(
            for key: K,
            ignoreLock: Bool = false,
            where condition: (T) -> Bool
        ) -> Set<T> {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.keyTags[key, default: []].filter(condition)
        }
        
        public func tags(
            for keys: Set<K>,
            mode: MatchingMode = .inclusive,
            ignoreLock: Bool = false
        ) -> Set<T> {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            var isFirst = true
            return switch mode {
            case .exclusive: keys
                    .reduce(into: Set<T>()) {
                        isFirst ? $0.formUnion(self.keyTags[$1, default: $0]) : $0.formIntersection(self.keyTags[$1, default: $0])
                        isFirst = false
                    }
            case .inclusive: keys.reduce(into: Set<T>()) { $0.formUnion(self.keyTags[$1, default: []]) }
            }
        }
        
        public func has(
            _ key: K,
            ignoreLock: Bool = false
        ) -> Bool {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.keyDateValues.keys.contains(key)
        }
        
        public func set(
            _ key: DateKey,
            tag: T,
            value: V,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            self.dateKeyValueStorage.updateValue(value, forKey: key)
            self.dateKeyTagStorage.updateValue([tag], forKey: key)
            self.tagDateKeyStorage[tag, default: []].insert(key)
        }
        
        public func set(
            _ key: DateKey,
            tags: Set<T>,
            value: V,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            self.dateKeyValueStorage.updateValue(value, forKey: key)
            self.dateKeyTagStorage.updateValue(tags, forKey: key)
            for tag in tags { self.tagDateKeyStorage[tag, default: []].insert(key) }
        }
        
        public func remove(
            _ key: K,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            for dateKey in self.dateKeyValueStorage.keys.filter({ dateKey in
                dateKey.key == key
            }) {
                self.dateKeyValueStorage.removeValue(forKey: dateKey)
                let tags = self.dateKeyTagStorage.removeValue(forKey: dateKey)
                for tag in (tags ?? []) {
                    self.tagDateKeyStorage[tag, default: []].remove(dateKey)
                }
            }
        }
        
        public func remove(
            _ key: DateKey,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            self.dateKeyValueStorage.removeValue(forKey: key)
            let tags = self.dateKeyTagStorage.removeValue(forKey: key)
            for tag in (tags ?? []) {
                self.tagDateKeyStorage[tag, default: []].remove(key)
            }
            
        }
        
        public func remove(
            _ keys: Set<K>,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            for key in keys { remove(key, ignoreLock: true) }
        }
        
        public func remove(
            _ keys: Set<DateKey>,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            for key in keys { remove(key, ignoreLock: true) }
        }
        
        public func remove(
            _ tags: Set<T>,
            mode: MatchingMode = .inclusive,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            let keys: Set<K> = switch mode {
            case .inclusive: tags.reduce(into: Set<K>()) { $0.formUnion(tagKeys[$1, default: []]) }
            case .exclusive: .init(keyTags.compactMap { $0.value.contains(tags) ? $0.key : nil })
            }
            remove(keys, ignoreLock: true)
        }
        
        public func remove(
            ignoreLock: Bool = false,
            where condition: (K) -> Bool
        ) {
            let keysToRemove = keys(where: condition)
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            remove(.init(keysToRemove), ignoreLock: true)
        }
        
        public func remove(
            ignoreLock: Bool = false,
            where condition: (DateKey) -> Bool
        ) {
            let keysToRemove = dateKeys(where: condition)
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            remove(.init(keysToRemove), ignoreLock: true)
        }
        
        public func remove(
            ignoreLock: Bool = false,
            where condition: (Date) -> Bool
        ) {
            let keysToRemove = dateKeys(where: condition)
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            remove(.init(keysToRemove), ignoreLock: true)
        }
        
        public func setTag(
            _ key: DateKey,
            tag: T,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            guard self.dateKeyTagStorage[key] != nil else { return }
            self.dateKeyTagStorage[key]?.insert(tag)
            self.tagDateKeyStorage[tag, default: []].insert(key)
        }
        
        public func setTag(
            _ key: K,
            tag: T,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            setTag(dateKeysForKey(key), tag: tag, ignoreLock: true)
        }
        

        
        public func setTag(
            _ keys: Set<K>,
            tag: T,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            setTag(dateKeysForKeys(keys), tag: tag, ignoreLock: true)
        }
        
        public func setTag(
            _ keys: Set<DateKey>,
            tag: T,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            var keys = keys
            for key in keys {
                guard self.dateKeyTagStorage[key] != nil else {
                    keys.remove(key)
                    continue
                }
                self.dateKeyTagStorage[key]?.insert(tag)
            }
            self.tagDateKeyStorage[tag, default: []].formUnion(keys)
        }
        
        public func setTags(
            _ key: DateKey,
            tags: Set<T>,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            guard self.dateKeyTagStorage[key] != nil else { return }
            self.dateKeyTagStorage[key]?.formUnion(tags)
            for tag in tags { self.tagDateKeyStorage[tag, default: []].insert(key) }
        }
        
        public func setTags(
            _ keys: Set<K>,
            tags: Set<T>,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            let dateKeys = keys.reduce(into: Set<DateKey>()) { $0.formUnion(self.keyDateKeys[$1, default: []]) }
            setTags(dateKeys, tags: tags, ignoreLock: true)
        }
        
        public func setTags(
            _ keys: Set<DateKey>,
            tags: Set<T>,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            var keys = keys
            for key in keys {
                guard self.dateKeyTagStorage[key] != nil else {
                    keys.remove(key)
                    continue
                }
                self.dateKeyTagStorage[key]?.formUnion(tags)
            }
            for tag in tags { self.tagDateKeyStorage[tag, default: []].formUnion(keys) }
        }
        
        public func removeTag(
            _ key: DateKey,
            tag: T,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            self.dateKeyTagStorage[key]?.remove(tag)
            self.tagDateKeyStorage[tag]?.remove(key)
        }
        
        public func removeTag(
            _ key: K,
            tag: T,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            removeTag(dateKeysForKey(key), tag: tag, ignoreLock: true)
        }
        
        public func removeTag(
            _ key: K,
            ignoreLock: Bool = false,
            where condition: (T) -> Bool
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            removeTag(dateKeysForKey(key), ignoreLock: true, where: condition)
        }
        
        public func removeTag(
            _ keys: Set<DateKey>,
            ignoreLock: Bool = false,
            where condition: (T) -> Bool
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            for key in keys {
                for tag in self.dateKeyTagStorage[key, default: []] {
                    if condition(tag) {
                        self.dateKeyTagStorage[key]?.remove(tag)
                        self.tagDateKeyStorage[tag]?.remove(key)
                    }
                }
            }
        }
        
        public func removeTag(
            _ key: DateKey,
            ignoreLock: Bool = false,
            where condition: (T) -> Bool
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            for tag in self.dateKeyTagStorage[key, default: []] {
                if condition(tag) {
                    self.dateKeyTagStorage[key]?.remove(tag)
                    self.tagDateKeyStorage[tag]?.remove(key)
                }
            }
        }
        
        public func removeTag(
            _ keys: Set<K>,
            tag: T,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            removeTag(dateKeysForKeys(keys), tag: tag, ignoreLock: true)
        }
        
        public func removeTag(
            _ keys: Set<DateKey>,
            tag: T,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            for key in keys { self.dateKeyTagStorage[key]?.remove(tag) }
            self.tagDateKeyStorage[tag]?.subtract(keys)
        }
        
        public func removeTags(
            _ key: K,
            tags: Set<T>,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            removeTags(dateKeysForKey(key), tags: tags, ignoreLock: true)
        }
        
        public func removeTags(
            _ keys: Set<K>,
            tags: Set<T>,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            removeTags(dateKeysForKeys(keys), tags: tags, ignoreLock: true)
        }
        
        public func removeTags(
            _ key: DateKey,
            tags: Set<T>,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            self.dateKeyTagStorage[key]?.subtract(tags)
            for tag in tags { self.tagDateKeyStorage[tag]?.remove(key) }
        }
        
        public func removeTags(
            _ keys: Set<DateKey>,
            tags: Set<T>,
            ignoreLock: Bool = false
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            for key in keys { self.dateKeyTagStorage[key]?.subtract(tags) }
            for tag in tags { self.tagDateKeyStorage[tag]?.subtract(keys) }
        }
        
        
        
        public func update(
            _ tag: T,
            ignoreLock: Bool = false,
            operation: (inout V) -> Void
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            update(tagDateKeyStorage[tag, default: []], ignoreLock: true, operation: operation)
        }
        
        public func update(
            _ tags: Set<T>,
            mode: MatchingMode = .inclusive,
            ignoreLock: Bool = false,
            operation: (inout V) -> Void
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            let keys: Set<DateKey> = switch mode {
            case .inclusive: tags.reduce(into: Set<DateKey>()) { $0.formUnion(tagDateKeyStorage[$1, default: []]) }
            case .exclusive: .init(dateKeyTagStorage.compactMap { $0.value.contains(tags) ? $0.key : nil })
            }
            update(keys, ignoreLock: true, operation: operation)
        }
        
        public func update(
            _ key: K,
            ignoreLock: Bool = false,
            operation: (inout V) -> Void
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            update(dateKeysForKey(key), ignoreLock: true, operation: operation)
        }
        
        public func update(
            _ key: DateKey,
            ignoreLock: Bool = false,
            operation: (inout V) -> Void
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            guard self.dateKeyValueStorage.keys.contains(key) else { return }
            operation(&self.dateKeyValueStorage[key]!)
        }
        
        public func update(
            _ keys: Set<K>,
            ignoreLock: Bool = false,
            operation: (inout V) -> Void
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            for key in keys { update(key, ignoreLock: true, operation: operation) }
        }
        
        public func update(
            _ keys: Set<DateKey>,
            ignoreLock: Bool = false,
            operation: (inout V) -> Void
        ) {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            for key in keys { update(key, ignoreLock: true, operation: operation) }
        }
        
        public func values(
            _ key: K,
            ignoreLock: Bool = false
        ) -> [V] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.keyDateValues[key, default: []].map(\.value)
        }
        
        public func values(
            ignoreLock: Bool = false
        ) -> [V] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return Array(self.dateKeyValueStorage.values)
        }
        
        public func values(
            for tag: T,
            ignoreLock: Bool = false
        ) -> [V] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.tagDateKeyStorage[tag, default: []].compactMap { key in
                self.dateKeyValueStorage[key]
            }
        }
        
        public func values(
            for tags: Set<T>,
            mode: MatchingMode = .inclusive,
            ignoreLock: Bool = false
        ) -> [V] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.dateKeyTagStorage
                .compactMap {
                    switch mode {
                    case .exclusive: $0.value.contains(tags) ? $0.key : nil
                    case .inclusive: $0.value.intersection(tags).isEmpty ? nil : $0.key
                    }
                }
                .uniqued()
                .compactMap { self.dateKeyValueStorage[$0] }
        }
        
        public func dateValues(
            _ key: K,
            ignoreLock: Bool = false
        ) -> [DateValue] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.keyDateValues[key, default: []]
        }
        
        public func dateValues(
            ignoreLock: Bool = false
        ) -> [DateValue] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return Array(self.keyDateValues.values.joined())
        }
        
        public func dateValues(
            for tag: T,
            ignoreLock: Bool = false
        ) -> [DateValue] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return Array(self.tagDateKeyStorage[tag, default: []].compactMap { key in
                self.keyDateValues[key.key, default: []]
            }.joined())
        }
        
        public func dateValues(
            for tags: Set<T>,
            mode: MatchingMode = .inclusive,
            ignoreLock: Bool = false
        ) -> [DateValue] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return Array(self.dateKeyTagStorage
                .compactMap {
                    switch mode {
                    case .exclusive: $0.value.contains(tags) ? $0.key.key : nil
                    case .inclusive: $0.value.intersection(tags).isEmpty ? nil : $0.key.key
                    }
                }
                .uniqued()
                .compactMap { self.keyDateValues[$0] }.joined())
        }
        
        public func entry(
            _ key: DateKey,
            ignoreLock: Bool = false
        ) -> Entry? {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            guard let storageEntry = self.dateKeyValueStorage[key] else { return nil }
            return
                .init(
                    key: key.key,
                    date: key.date,
                    tags: tags(for: key, ignoreLock: true),
                    value: storageEntry
                )
        }
        
        public func entries(
            _ key: K,
            ignoreLock: Bool = false
        ) -> [Entry] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.dateKeyValueStorage
                .filter({ $0.key.key == key })
                .map { storageEntry in
                .init(
                    key: storageEntry.key.key,
                    date: storageEntry.key.date,
                    tags: tags(for: storageEntry.key, ignoreLock: true),
                    value: storageEntry.value
                )
            }
        }
        
        public func entries(
            ignoreLock: Bool = false
        ) -> [Entry] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.dateKeyValueStorage.map { storageEntry in
                .init(
                    key: storageEntry.key.key,
                    date: storageEntry.key.date,
                    tags: tags(for: storageEntry.key, ignoreLock: true),
                    value: storageEntry.value
                )
            }
        }
        
        public func entries(
            for tag: T,
            ignoreLock: Bool = false
        ) -> [Entry] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            let dateKeys = self.tagDateKeyStorage[tag, default: []]
            return dateKeys.compactMap { entry($0, ignoreLock: true) }
        }
        
        public func entries(
            for tags: Set<T>,
            mode: MatchingMode = .inclusive,
            ignoreLock: Bool = false
        ) -> [Entry] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.dateKeyTagStorage
                .compactMap {
                    switch mode {
                    case .exclusive: $0.value.contains(tags) ? $0.key : nil
                    case .inclusive: $0.value.intersection(tags).isEmpty ? nil : $0.key
                    }
                }
                .uniqued()
                .compactMap { entry($0, ignoreLock: true) }
        }
        
        public func entries(
            _ key: K,
            for tags: Set<T>,
            mode: MatchingMode = .inclusive,
            ignoreLock: Bool = false
        ) -> [Entry] {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.dateKeyTagStorage
                .filter({ $0.key.key == key })
                .compactMap {
                    switch mode {
                    case .exclusive: $0.value.contains(tags) ? $0.key : nil
                    case .inclusive: $0.value.intersection(tags).isEmpty ? nil : $0.key
                    }
                }
                .uniqued()
                .compactMap { entry($0, ignoreLock: true) }
        }
        
        public func takeFirst(
            for tag: T,
            ignoreLock: Bool = false
        ) -> V? {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            guard
                let key = self.tagDateKeyStorage[tag]?.removeFirst(),
                let value = self.dateKeyValueStorage.removeValue(forKey: key)
            else { return nil }
            dateKeyTagStorage.removeValue(forKey: key)
            return value
        }
        
        public func takeFirst(
            for tags: Set<T>,
            mode: MatchingMode = .inclusive,
            ignoreLock: Bool = false
        ) -> V? {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            guard
                let key = self.closestDateKey(for: tags, mode: mode, ignoreLock: true),
                let value = self.dateKeyValueStorage.removeValue(forKey: key)
            else { return nil }
            dateKeyTagStorage.removeValue(forKey: key)
            return value
        }
        
        public var count: Int {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.dateKeyValueStorage.count
        }
        
        public func count(
            for tag: T,
            ignoreLock: Bool = false
        ) -> Int {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return self.tagDateKeyStorage[tag, default: []].count
        }
        
        public func count(
            for tags: Set<T>,
            mode: MatchingMode = .inclusive,
            ignoreLock: Bool = false
        ) -> Int {
            if !ignoreLock { self.lock.lock() }
            defer { if !ignoreLock { self.lock.unlock() } }
            return switch mode {
            case .exclusive: keyTags.compactMap { $0.value.contains(tags) ? $0.key : nil }.uniqueCount()
            case .inclusive: tags.reduce(into: Set<K>()) { $0.formUnion(tagKeys[$1, default: []]) }.count
            }
        }
        
        private var keyDateValues: TreeDictionary<K, Array<DateValue>> {
            self.dateKeyValueStorage.reduce(into: [:], { acc, next in
                acc[next.key.key, default: []].append(.init(date: next.key.date, value: next.value))
            })
        }
        
        private var keyTags: TreeDictionary<K, Set<T>> {
            self.dateKeyTagStorage.reduce(into: [:], { acc, next in
                acc[next.key.key, default: []].formUnion(next.value)
            })
        }
        
        private var tagKeys: TreeDictionary<T, Set<K>> {
            self.tagDateKeyStorage.reduce(into: [:], { acc, next in
                acc[next.key, default: []].formUnion(next.value.map(\.key))
            })
        }
        
        private var keyDateKeys: TreeDictionary<K, Set<DateKey>> {
            self.dateKeyTagStorage.reduce(into: [:], { acc, next in
                acc[next.key.key, default: []].insert(next.key)
            })
        }
        
        private func dateKeysForKey(_ key: K) -> Set<DateKey> {
            self.keyDateKeys[key, default: []]
        }
        
        
        
        private func dateKeysForKeys(_ keys: Set<K>) -> Set<DateKey> {
            keys.reduce(into: Set<DateKey>()) { $0.formUnion(self.keyDateKeys[$1, default: []]) }
        }
    }
}
