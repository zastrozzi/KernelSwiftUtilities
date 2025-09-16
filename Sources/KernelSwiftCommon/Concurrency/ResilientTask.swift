//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import Foundation

public struct ResilientTask {
    public typealias InitCallback = () async -> Void
    public typealias MonitorFunction = @Sendable (Status) async -> Void
    public typealias Action = @Sendable (InitCallback) async throws -> Void
    
    private let task: Task<Void, Error>
    
    public init(
        backoff: ExponentialBackoffSequence = .default,
        monitor: MonitorFunction? = nil,
        _ action: @escaping Action
    ) {
        task = Task.detached {
            var iterator = backoff.makeIterator()
            while !Task.isCancelled {
                do {
                    await monitor?(.initialising)
                    try await action {
                        iterator = backoff.makeIterator()
                        await monitor?(.running)
                    }
                }
                catch is CancellationError {
                    await monitor?(.cancelled)
                    break
                }
                catch {
                    await monitor?(.failed(error))
                }
                
                if Task.isCancelled {
                    await monitor?(.cancelled)
                    break
                }
                
                if let delay = iterator.next(), delay > 0 {
                    await monitor?(.waiting(delay))
                    try await Task.sleep(for: .seconds(delay))
                }
            }
        }
    }
    
    public func cancel() { task.cancel() }
    
    public var isCancelled: Bool { task.isCancelled }
}

extension ResilientTask {
    public enum Status: Sendable {
        case initialising
        case running
        case waiting(TimeInterval)
        case cancelled
        case failed(Error)
    }
}
