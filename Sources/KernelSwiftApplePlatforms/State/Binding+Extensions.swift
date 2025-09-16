//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/08/2022.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

extension Binding {
    public func didSet(_ perform: @escaping @Sendable (Value) -> Void) -> Self where Value: Sendable {
        return .init(
            get: { self.wrappedValue },
            set: { newValue, txn in
                self.transaction(txn).wrappedValue = newValue
                perform(newValue)
            }
        )
    }
}

extension Binding {
    public init?(unwrapping base: Binding<Value?>) where Value: Sendable {
        self.init(unwrapping: base, case: /Optional.some)
    }
    
    
    public init?<Enum: Sendable>(unwrapping bkEnum: Binding<Enum>, case casePath: KernelCasePath<Enum, Value>) where Value: Sendable {
        guard let _bkCase = casePath.extract(from: bkEnum.wrappedValue) else { return nil }
        #if swift(>=6)
        nonisolated(unsafe) var bkCase = _bkCase
        #else
        var bkCase = _bkCase
        #endif
        let fallback = bkCase
        
        self.init(
            get: { casePath.extract(from: bkEnum.wrappedValue) ?? fallback },
            set: { newValue, txn in
                bkCase = newValue
                bkEnum.transaction(txn).wrappedValue = casePath.embed(newValue)
            }
        )
    }
    
    public func bkCase<Enum, Case>(_ casePath: KernelCasePath<Enum, Case>) -> Binding<Case?> where Value == Enum? {
        .init(
            get: { self.wrappedValue.flatMap(casePath.extract(from:)) },
            set: { newValue, txn in self.transaction(txn).wrappedValue = newValue.map(casePath.embed) }
        )
    }
    
    public func isPresent<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        #if swift(>=6)
        nonisolated(unsafe) let concurrentSelf = self
        #else
        let concurrentSelf = self
        #endif
        return .init(
            get: { concurrentSelf.wrappedValue != nil },
            set: { newValue, txn in if !newValue { concurrentSelf.transaction(txn).wrappedValue = nil } }
        )
    }
    
    public func isPresent<Enum, Case>(_ casePath: KernelCasePath<Enum, Case>) -> Binding<Bool> where Value == Enum? {
        self.bkCase(casePath).isPresent()
    }
    
    public func removeDuplicates(by isDuplicate: @escaping @Sendable (Value, Value) -> Bool) -> Self {
        #if swift(>=6)
        nonisolated(unsafe) let concurrentSelf = self
        #else
        let concurrentSelf = self
        #endif
        return .init(
            get: { concurrentSelf.wrappedValue },
            set: { newValue, txn in
                guard !isDuplicate(concurrentSelf.wrappedValue, newValue) else { return }
                concurrentSelf.transaction(txn).wrappedValue = newValue
            }
        )
    }
}

extension Binding where Value == Bool {
    
    public init(binding: Binding<(some Any)?>) {
#if swift(>=6)
        nonisolated(unsafe) let concurrentBinding = binding
#else
        let concurrentBinding = binding
#endif
        self.init(
            get: { concurrentBinding.wrappedValue != nil },
            set: { newValue in
                guard newValue == false else { return }
                concurrentBinding.wrappedValue = nil
            }
        )
    }
}

extension Binding where Value: Equatable {
    public func removeDuplicates() -> Self {
        self.removeDuplicates { c0, c1 in
            c0 == c1
        }
    }
}

extension Binding {
    public func exists<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        .init(binding: self)
    }
}
