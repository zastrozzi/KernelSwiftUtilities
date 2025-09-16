//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/01/2022.
//

import SwiftUI
import Combine
import KernelSwiftCommon

public typealias StateStore<State> = CurrentValueSubject<State, Never>

public extension StateStore {
    subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
        get { value[keyPath: keyPath] }
        set {
            var value = self.value
            if value[keyPath: keyPath] != newValue {
                value[keyPath: keyPath] = newValue
                self.value = value
            }
        }
    }
    
    func bulkUpdate(_ update: (inout Output) -> Void) {
        var value = self.value
        update(&value)
        self.value = value
    }
    
    func updates<Value>(for keyPath: KeyPath<Output, Value>) -> AnyPublisher<Value, Failure> where Value: Equatable {
        return map(keyPath).removeDuplicates().eraseToAnyPublisher()
    }
}

public extension ObservableObject {
    func loadableSubject<Value: Sendable>(_ keyPath: WritableKeyPath<Self, Loadable<Value>>) -> LoadableSubject<Value> {
#if swift(>=6)
        nonisolated(unsafe) var concurrentSelf = self
        nonisolated(unsafe) let concurrentKeyPath = keyPath
#else
        var concurrentSelf = self
        let concurrentKeyPath = keyPath
#endif
//        let defaultValue = concurrentSelf[keyPath: keyPath]
        return .init(
            get: {
                concurrentSelf[keyPath: concurrentKeyPath]
            },
            set: {
                concurrentSelf[keyPath: concurrentKeyPath] = $0
                
            }
        )
    }
}
