//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/08/2023.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

@propertyWrapper
public struct InjectedBinding<Value: Sendable>: Sendable, _KernelDIHasInitialValues {
    public let initialValues: KernelDI.Injector
    
    private let keyPath: WritableKeyPath<KernelDI.Injector, Value>
    private let file: StaticString
    private let fileID: StaticString
    private let line: UInt
    private let animation: Animation?
//    private let lock = NSRecursiveLock()
//    private let threadLockEnabled: Bool
    
    public init(
        _ keyPath: WritableKeyPath<KernelDI.Injector, Value>,
        withAnimation animation: Animation? = nil,
//        withLock threadLockEnabled: Bool = false,
        file: StaticString = #file,
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) {
        self.initialValues = KernelDI.Injector._current
        self.keyPath = keyPath
        self.file = file
        self.fileID = fileID
        self.line = line
        self.animation = animation
//        self.threadLockEnabled = threadLockEnabled
        #if DEBUG
        print(keyPath, fileID, "injected binding init")
        #endif
    }
    
    public var wrappedValue: Value {
        get { self.projectedValue.wrappedValue }
        nonmutating set { self.projectedValue.wrappedValue = newValue }
    }
    
    public var projectedValue: Binding<Value> {
//        print(keyPath, fileID, "injected binding projectedValue")
        return Binding<Value>.init {
            let merged = self.initialValues.merging(KernelDI.Injector._current)
            return KernelDI.Injector.$_current.withValue(merged) {
                return withAnimation(animation) {
                    return KernelDI.Injector._current[keyPath: self.keyPath]
                }
            }
        } set: { newValue in
            var mutable = self.initialValues.merging(KernelDI.Injector._current)
            return KernelDI.Injector.$_current.withValue(mutable) {
                withAnimation(animation) {
                    mutable[keyPath: self.keyPath] = newValue
                }
            }
        }
    }
}


extension KernelDI.Injectable {
    public func binding<Value: Sendable>(_ keyPath: WritableKeyPath<Self, Value>, animation: Animation? = nil) -> Binding<Value> where Self: Sendable {
//        print(keyPath, "injectable binding")
        return Binding<Value>.init {
            let merged = KernelDI.Injector._current.merging(KernelDI.Injector._current)
            return KernelDI.Injector.$_current.withValue(merged) {
                return withAnimation(animation) {
                    return merged[KernelDI.DefaultInjectableToken<Self>.self][keyPath: keyPath]
                }
            }
        } set: { newValue in
            var mutable = KernelDI.Injector._current.merging(KernelDI.Injector._current)
            return KernelDI.Injector.$_current.withValue(mutable) {
                withAnimation(animation) {
                    mutable[KernelDI.DefaultInjectableToken<Self>.self][keyPath: keyPath] = newValue
                }
            }
        }
    }
}
