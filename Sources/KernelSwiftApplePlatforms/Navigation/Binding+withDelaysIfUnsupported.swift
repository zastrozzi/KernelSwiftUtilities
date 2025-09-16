//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/08/2022.
//

import Foundation
import SwiftUI

#if compiler(>=5.7)
extension Binding where Value: Collection {
    @_disfavoredOverload
    @preconcurrency
    public func withDelaysIfUnsupported<S>(_ transform: (inout [S]) -> Void, delay: TimeInterval = 0.65, onCompletion: (() -> Void)? = nil) async where Value == [S] {
//        preconditionFailure("swift 5.9 deprecation")
        let start = wrappedValue
        let end = applyTransform(transform, to: start)
        let steps = calculateSteps(from: start, to: end)
        self.wrappedValue[keyPath: \.self] = steps.first!
        await self.scheduleRemainingSteps(withDelay: delay, steps: Array(steps.dropFirst()), keyPath: \.self)
        onCompletion?()
    }
    
    @preconcurrency
    public func withDelaysIfUnsupported<S>(_ transform: (inout [S]) -> Void, delay: TimeInterval = 0.65) async where Value == [S] {
        let start = wrappedValue
        let end = applyTransform(transform, to: start)
        await withDelaysIfUnsupported(delay: delay, from: start, to: end, keyPath: \.self)
    }
}

@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension Binding where Value == BackportNavigationPath {
    @_disfavoredOverload @preconcurrency
    public func withDelaysIfUnsupported(_ transform: (inout BackportNavigationPath) -> Void, delay: TimeInterval = 0.65, onCompletion: (() -> Void)? = nil) async {
        let start = wrappedValue
        let end = applyTransform(transform, to: start)
        await withDelaysIfUnsupported(delay: delay, from: start.elements, to: end.elements, keyPath: \.elements)
        onCompletion?()
    }
    
    @preconcurrency
    public func withDelaysIfUnsupported(_ transform: (inout BackportNavigationPath) -> Void, delay: TimeInterval = 0.65) async {
        let start = wrappedValue
        let end = applyTransform(transform, to: start)
        await withDelaysIfUnsupported(delay: delay, from: start.elements, to: end.elements, keyPath: \.elements)
    }
}

extension Binding {
    @preconcurrency
    func withDelaysIfUnsupported<S>(_ transform: (inout [S]) -> Void, delay: TimeInterval, keyPath: WritableKeyPath<Value, [S]>) async {
        let start = wrappedValue[keyPath: keyPath]
        let end = applyTransform(transform, to: start)
        await withDelaysIfUnsupported(delay: delay, from: start, to: end, keyPath: keyPath)
    }
    
    @preconcurrency
    nonisolated func withDelaysIfUnsupported<S>(delay: TimeInterval, from start: [S], to end: [S], keyPath: WritableKeyPath<Value, [S]>) async {
        let steps = calculateSteps(from: start, to: end)
        
        wrappedValue[keyPath: keyPath] = steps.first!
        await scheduleRemainingSteps(withDelay: delay, steps: Array(steps.dropFirst()), keyPath: keyPath)
    }
    
//    @MainActor
    @preconcurrency
    func scheduleRemainingSteps<S>(withDelay delay: TimeInterval, steps: [[S]], keyPath: WritableKeyPath<Value, [S]>) async {
        guard let firstStep = steps.first else { return }
        
        wrappedValue[keyPath: keyPath] = firstStep
        
        do {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            await scheduleRemainingSteps(withDelay: delay, steps: Array(steps.dropFirst()), keyPath: keyPath)
        } catch { }
    }
}

func applyTransform<T>(_ transform: (inout T) -> Void, to input: T) -> T {
    var output = input
    transform(&output)
    return output
}

public func calculateSteps<S>(from start: [S], to end: [S]) -> [[S]] {
    let replaceable = end.prefix(start.count)
    let remaining = start.count < end.count ? end.suffix(from: start.count) : []
    
    var steps = [Array(replaceable)]
    var lastStep: [S] { steps.last! }
    
    for step in remaining {
        steps.append(lastStep + [step])
    }
    
    return steps
}
#endif
