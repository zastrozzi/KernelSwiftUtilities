//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/11/2023.
//

import Foundation

public enum TimeoutHandlerError: Error {
    case timeoutOccured
}

public func withTimeout<Return: Sendable>(
    nanoseconds: UInt64,
    _ operation: @escaping @Sendable () async throws -> Return
) async throws -> Return {
    let task = Ref<Task<(), Never>>(value: nil)
    let timeoutTask = Ref<Task<(), any Error>>(value: nil)
    let flag = Flag()
    
    return try await withTaskCancellationHandler {
        try await withCheckedThrowingContinuation( { (cont: CheckedContinuation<Return, Error>) in
            do { try Task.checkCancellation() }
            catch {
                cont.resume(throwing: error)
                return
            }
            
            let _task = Task {
                do {
                    let taskRes = try await operation()
                    await flag.performIf(expected: false) {
                        cont.resume(returning: taskRes)
                        return true
                    }
                } catch {
                    await flag.performIf(expected: false) {
                        cont.resume(throwing: error)
                        return true
                    }
                }
            }
            
            task.value = _task
            
            let _timeoutTask = Task {
                try await Task.sleep(nanoseconds: nanoseconds)
                _task.cancel()
                
                await flag.performIf(expected: false) {
                    cont.resume(throwing: TimeoutHandlerError.timeoutOccured)
                    return true
                }
            }
            
            timeoutTask.value = _timeoutTask
        })
    } onCancel: {
        task.value?.cancel()
        timeoutTask.value?.cancel()
    }

}

private actor Flag {
    var value: Bool = false
    
    func set(value: Bool) { self.value = value }
    
    func performIf(expected: Bool, perform: @Sendable () -> Bool) {
        if value == expected { value = perform() }
    }
}

private final class Ref<T: Sendable>: Sendable {
    nonisolated(unsafe) var value: T?
    
    init(value: T?) {
        self.value = value
    }
}
