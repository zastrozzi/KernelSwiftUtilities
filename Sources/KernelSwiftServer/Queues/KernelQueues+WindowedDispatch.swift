//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 22/06/2025.
//

import Vapor
import Queues

public enum QueuesDispatchWindowError: Error, CustomStringConvertible {
    case invalidRateLimit(Int)
    case invalidCustomInterval(TimeInterval)
    
    public var description: String {
        switch self {
        case .invalidRateLimit(let value):
            return "QueuesDispatchWindowError: rate limit must be greater than 0, but got \(value)."
        case .invalidCustomInterval(let value):
            return "QueuesDispatchWindowError: custom interval must be greater than 0, but got \(value)."
        }
    }
}

public enum QueuesDispatchWindow {
    case perSecond(Int)
    case perMinute(Int)
    case perHour(Int)
    case custom(interval: TimeInterval, limit: Int)
    
    var limit: Int {
        switch self {
        case .perSecond(let l), .perMinute(let l), .perHour(let l): l
        case .custom(_, let l): l
        }
    }
    
    func validatedInterval() throws -> TimeInterval {
        guard limit > 0 else {
            throw QueuesDispatchWindowError.invalidRateLimit(limit)
        }
        
        switch self {
        case .perSecond(let limit): return 1.0 / Double(limit)
        case .perMinute(let limit): return 60.0 / Double(limit)
        case .perHour(let limit): return 3600.0 / Double(limit)
        case .custom(let interval, let limit):
            guard interval > 0 else {
                throw QueuesDispatchWindowError.invalidCustomInterval(interval)
            }
            return interval / Double(limit)
        }
    }
}

extension Queue {
    public func dispatch<J: Job>(
        _ job: J.Type,
        _ payloads: [J.Payload],
        window: QueuesDispatchWindow,
        delayUntil initialDelay: TimeInterval = 0,
        jitter: ClosedRange<TimeInterval>? = nil,
        maxRetryCount: Int = 0
    ) async throws {
        let interval = try window.validatedInterval()
        let now = Date()
        
        for (index, payload) in payloads.enumerated() {
            try Task.checkCancellation()
            
            let delay = initialDelay + (interval * Double(index)) + (jitter.map { .random(in: $0) } ?? 0)
            
            let scheduledTime = now.addingTimeInterval(delay)
            
            try await self.dispatch(
                J.self,
                payload,
                maxRetryCount: maxRetryCount,
                delayUntil: scheduledTime
            )
        }
    }
}
