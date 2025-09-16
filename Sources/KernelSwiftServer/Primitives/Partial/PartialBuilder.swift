//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/04/2023.
//

import Foundation
import Collections

open class PartialBuilder<Wrapped>: PartialProtocol, CustomStringConvertible {
    public struct KeyPathUpdate<Value> {
        public enum Kind {
            case valueSet(_ value: Value)
            case valueRemoved
        }
        
        public let kind: Kind
        public let keyPath: KeyPath<Wrapped, Value>
        public let oldValue: Value?
        public var newValue: Value? {
            switch kind {
            case .valueSet(let value):
                return value
            case .valueRemoved:
                return nil
            }
        }
        
        init(kind: Kind, keyPath: KeyPath<Wrapped, Value>, oldValue: Value?) {
            self.kind = kind
            self.keyPath = keyPath
            self.oldValue = oldValue
        }
    }
    
    public typealias AllChangesUpdateListener = (_ keyPath: PartialKeyPath<Wrapped>, PartialBuilder<Wrapped>) -> Void
    public typealias KeyPathUpdateListener<Value> = (_ update: KeyPathUpdate<Value>) -> Void
    
    public var description: String {
        return "\(type(of: self))(partial: \(partial)"
    }
    
    public private(set) var partial: Partial<Wrapped>
    
    private var allChangesSubscriptions: Set<Weak<AllChangesSubscription>> = []
    private var keyPathSubscriptions: TreeDictionary<PartialKeyPath<Wrapped>, Set<Weak<KeyPathChangesSubscription>>> = [:]
    private var attachedSubscription: Subscription?
    
    required public init() {
        partial = Partial<Wrapped>()
    }
    
    required public init(from decoder: Decoder) throws where Wrapped: PartialCodable {
         let container = try decoder.singleValueContainer()
         partial = try container.decode(Partial<Wrapped>.self)
     }
    
    public init(partial: Partial<Wrapped>) {
        self.partial = partial
    }
    
    public func subscribeToAllChanges(updateListener: @escaping AllChangesUpdateListener) -> Subscription {
            let subscription = AllChangesSubscription(updateListener: updateListener) { [weak self] subscription in
                self?.allChangesSubscriptions.remove(Weak(subscription))
            }
            allChangesSubscriptions.insert(Weak(subscription))
            return subscription
        }

    public func subscribeForChanges<Value>(
        to keyPath: KeyPath<Wrapped, Value>,
        updateListener: @escaping KeyPathUpdateListener<Value>
    ) -> Subscription {
        let subscription = KeyPathChangesSubscription(
            keyPath: keyPath,
            updateListener: updateListener,
            cancelAction: { [weak self] subscription in
                guard let self = self else { return }
                self.keyPathSubscriptions[keyPath]?.remove(Weak(subscription))
            }
        )

        keyPathSubscriptions[keyPath, default: []].insert(Weak(subscription))
        return subscription
    }

    public func value<Value>(for keyPath: KeyPath<Wrapped, Value>) throws -> Value {
        return try partial.value(for: keyPath)
    }

    public func setValue<Value>(_ value: Value, for keyPath: KeyPath<Wrapped, Value>) {
        let oldValue = partial[keyPath]
        partial.setValue(value, for: keyPath)
        notifyUpdateListeners(ofChangeTo: keyPath, from: oldValue, to: value)
    }

    public func removeValue<Value>(for keyPath: KeyPath<Wrapped, Value>) {
        let oldValue = partial[keyPath]
        partial.removeValue(for: keyPath)
        notifyUpdateListenersOfRemoval(of: keyPath, oldValue: oldValue)
    }

    private func notifyUpdateListeners<Value>(ofChangeTo keyPath: PartialKeyPath<Wrapped>, from oldValue: Value?, to newValue: Value) {
        keyPathSubscriptions[keyPath]?.forEach { $0.wrapped?.notifyOfUpdate(from: oldValue, to: newValue) }
        allChangesSubscriptions.forEach { $0.wrapped?.updateListener(keyPath, self) }
    }

    private func notifyUpdateListenersOfRemoval<Value>(of keyPath: KeyPath<Wrapped, Value>, oldValue: Value?) {
        keyPathSubscriptions[keyPath]?.forEach { $0.wrapped?.notifyOfRemovable(old: oldValue) }
        allChangesSubscriptions.forEach { $0.wrapped?.updateListener(keyPath, self) }
    }
    
    public func builder<Value: PartialConvertible>(for keyPath: KeyPath<Wrapped, Value>) -> PartialBuilder<Value> {
        let result = PartialBuilder<Value>()
        result.attachedSubscription = result.subscribeToAllChanges { _, builder in
            do { try self.setValue(Value(partial: builder), for: keyPath) }
            catch { self.removeValue(for: keyPath) }
        }
        return result
    }
    
    public func detach() {
        attachedSubscription = nil
    }
}

extension PartialBuilder.KeyPathUpdate.Kind: Equatable where Value: Equatable {}
extension PartialBuilder.KeyPathUpdate: Equatable where Value: Equatable {}
extension PartialBuilder: Decodable where Wrapped: PartialCodable {}

extension PartialBuilder: Encodable where Wrapped: PartialCodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(partial)
    }
}

extension PartialBuilder where Wrapped: PartialCodable & Codable {
    public func decoded() throws -> Wrapped {
        return try partial.decoded()
    }
}
