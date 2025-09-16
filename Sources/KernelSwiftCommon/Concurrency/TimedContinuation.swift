//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import Foundation

public actor TimedContinuation<T: Sendable> {
    var continuation: EnvironmentContinuation<T, Error>?
    var timeoutTask: Task<Void, Error>?
    
    public init(
        continuation: EnvironmentContinuation<T, Error>,
        error timeoutError: Error,
        timeout: Duration,
        tolerance: Duration? = nil
    ) async {
        self.continuation = continuation
        self.timeoutTask = Task {
            do {
                try await Task.sleep(for: timeout, tolerance: tolerance)
                self.resume(throwing: timeoutError)
            } catch {
                self.resume(throwing: error)
            }
        }
    }
    
    private func cancelTimeout() {
        guard let timeoutTask else { return }
        timeoutTask.cancel()
        self.timeoutTask = nil
    }
    
    public func resume(throwing error: Error) {
        guard let continuation else { return }
        continuation.resume(throwing: error)
        self.continuation = nil
        cancelTimeout()
    }
    
    public func resume(returning value: T) {
        guard let continuation else { return }
        continuation.resume(returning: value)
        self.continuation = nil
        cancelTimeout()
    }
}
