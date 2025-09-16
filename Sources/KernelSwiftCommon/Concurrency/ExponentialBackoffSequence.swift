//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import Foundation

public struct ExponentialBackoffSequence: Sequence, Sendable {
    public var initialDelay: TimeInterval
    public var minDelay: TimeInterval
    public var maxDelay: TimeInterval
    public var jitter: Double
    public var growthFactor: Double
    
    public init(
        initial initialDelay: TimeInterval = 0.0,
        min minDelay: TimeInterval = 0.5,
        max maxDelay: TimeInterval = 30.0,
        jitter: Double = 0.25,
        growthFactor: Double = .phi
    ) {
        precondition(initialDelay >= 0)
        precondition(minDelay > 0)
        precondition(minDelay <= maxDelay)
        precondition(jitter <= minDelay)
        precondition(growthFactor > 0)
        
        self.initialDelay = initialDelay
        self.minDelay = minDelay
        self.maxDelay = maxDelay
        self.jitter = jitter
        self.growthFactor = growthFactor
    }
    
    public func makeIterator() -> Iterator {
        .init(backoff: self)
    }
    
    public static let `default` = ExponentialBackoffSequence()
    
    public struct Iterator: IteratorProtocol {
        let backoff: ExponentialBackoffSequence
        var currentDelay: TimeInterval
        
        public init(backoff: ExponentialBackoffSequence) {
            self.backoff = backoff
            if backoff.initialDelay >= backoff.jitter {
                currentDelay = backoff.initialDelay + Double.random(in: backoff.jitter.negated() ... backoff.jitter)
            }
            else { currentDelay = backoff.initialDelay }
        }
        
        public mutating func next() -> TimeInterval? {
            let t = currentDelay
            currentDelay = Swift.min(Swift.max(currentDelay * backoff.growthFactor, backoff.minDelay), backoff.maxDelay)
            + Double.random(in: -backoff.jitter ... backoff.jitter)
            return t
        }
    }
}
