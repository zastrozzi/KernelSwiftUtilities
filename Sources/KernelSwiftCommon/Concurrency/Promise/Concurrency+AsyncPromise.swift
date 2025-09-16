//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/11/2023.
//

import Foundation

extension KernelSwiftCommon.Concurrency {
    public struct AsyncPromise<Success: Sendable>: Sendable {
        @usableFromInline
        typealias Witness = CheckedContinuation<Success, Error>
        
        @usableFromInline
        struct State: Sendable {
            @usableFromInline
            var witnesses: [Witness] = []
            
            @usableFromInline
            var result: Success? = nil
        }
        
        @usableFromInline
        internal let state = Core.ManagedCriticalState(State())
        
        public init(_ success: Success.Type = Success.self) {}
        
        @discardableResult
        @inlinable
        public func fulfill(with value: Success) -> Bool {
            return state.withCriticalRegion { managedState in
                if managedState.result == nil {
                    managedState.result = value
                    for witness in managedState.witnesses { witness.resume(returning: value) }
                    managedState.witnesses.removeAll()
                    return false
                }
                return true
            }
        }
        
        //    @discardableResult
        @inlinable
        public func fail(with error: Error) {
            return state.withCriticalRegion { managedState in
                for witness in managedState.witnesses { witness.resume(throwing: error) }
                managedState.witnesses.removeAll()
                return
            }
        }
        
        @usableFromInline
        var awaitValue: Success {
            get async throws {
                try await withCheckedThrowingContinuation { continuation in
                    state.withCriticalRegion { managedState in
                        if let result = managedState.result {
                            continuation.resume(returning: result)
                        } else {
                            managedState.witnesses.append(continuation)
                        }
                    }
                }
            }
        }
    }
}

extension KernelSwiftCommon.Concurrency.AsyncPromise where Success == Void {
    @inlinable
    @discardableResult
    public func fulfill() -> Bool { fulfill(with: ()) }
}
