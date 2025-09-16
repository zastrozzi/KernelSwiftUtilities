//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

extension KernelDI {
    @propertyWrapper
    public struct Injected<Value: Sendable>: @unchecked Sendable, HasInitialValues {
        public let initialValues: Injector
        
        private let keyPath: KeyPath<Injector, Value>
        private let file: StaticString
        private let fileID: StaticString
        private let line: UInt
        
        public init(
            _ keyPath: KeyPath<Injector, Value>,
            file: StaticString = #file,
            fileID: StaticString = #fileID,
            line: UInt = #line
        ) {
            self.initialValues = Injector._current
            self.keyPath = keyPath
            self.file = file
            self.fileID = fileID
            self.line = line
        }
        
        public var wrappedValue: Value { injectable }
        
        fileprivate var injectable: Value {
            let injectables = self.initialValues.merging(Injector._current)
            return Injector.$_current.withValue(injectables) {
                Injector._current[keyPath: self.keyPath]
            }
        }
    }
}

extension WritableKeyPath: @unchecked @retroactive Sendable where Root: Sendable, Value: Sendable {}
