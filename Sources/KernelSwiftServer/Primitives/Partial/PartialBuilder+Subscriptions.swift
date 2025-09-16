//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/04/2023.
//

import Foundation

extension PartialBuilder {
    public class Subscription: Hashable {
        private let uuid = UUID()
        
        init() {}
        deinit { cancel() }
        
        public func cancel() { preconditionFailure("\(#function) must be overridden") }
        public func hash(into hasher: inout Hasher) { uuid.hash(into: &hasher) }
        
        public static func == (lhs: PartialBuilder<Wrapped>.Subscription, rhs: PartialBuilder<Wrapped>.Subscription) -> Bool {
            lhs.uuid == rhs.uuid
        }
    }
    
    final class AllChangesSubscription: Subscription {
        typealias CancelAction = (AllChangesSubscription) -> Void
        let updateListener: AllChangesUpdateListener
        private let cancelAction: CancelAction
        
        init(updateListener: @escaping AllChangesUpdateListener, cancelAction: @escaping CancelAction) {
            self.updateListener = updateListener
            self.cancelAction = cancelAction
            super.init()
        }
        
        override func cancel() { cancelAction(self) }
    }
    
    final class KeyPathChangesSubscription: Subscription {
        typealias CancelAction = (KeyPathChangesSubscription) -> Void
        private let _notifyOfValue: (_ oldValue: Any?, _ newValue: Any?) -> Void
        private let _notifyOfRemovable: (_ oldValue: Any?) -> Void
        private let cancelAction: CancelAction
        
        init<Value>(keyPath: KeyPath<Wrapped, Value>, updateListener: @escaping KeyPathUpdateListener<Value>, cancelAction: @escaping CancelAction) {
            self._notifyOfValue = { old, new in
                guard let old = old as? Value?, let new = new as? Value else {
                    assertionFailure("Update listener value to does not match \(Value?.self)")
                    return
                }
                let update = KeyPathUpdate<Value>(kind: .valueSet(new), keyPath: keyPath, oldValue: old)
                updateListener(update)
            }
            
            self._notifyOfRemovable = { old in
                guard let old = old as? Value? else {
                    assertionFailure("Update listener value to does not match \(Value?.self)")
                    return
                }
                let update = KeyPathUpdate<Value>(kind: .valueRemoved, keyPath: keyPath, oldValue: old)
                updateListener(update)
            }
            self.cancelAction = cancelAction
            super.init()
        }
        
        func notifyOfUpdate<Value>(from old: Value?, to new: Value) { _notifyOfValue(old, new) }
        func notifyOfRemovable(old: Any?) { _notifyOfRemovable(old) }
        
        override func cancel() { cancelAction(self) }
    }
}
