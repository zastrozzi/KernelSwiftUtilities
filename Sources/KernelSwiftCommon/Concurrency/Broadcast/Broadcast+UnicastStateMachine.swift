//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/11/2023.
//

import Foundation
import Collections

extension KernelSwiftCommon.Concurrency.Broadcast {
    public struct UnicastStateMachine<Payload: Sendable>: Sendable {
        public typealias Message = Result<Payload?, Error>
        public typealias ConsumerContinuation = UnsafeContinuation<Message, Never>
        
        private var state: State
        
        public init() {
            self.state = .buffering(messages: [], suspended: nil)
        }
    }
}

extension KernelSwiftCommon.Concurrency.Broadcast.UnicastStateMachine {
    public enum State: Sendable {
        case buffering(messages: Deque<Message>, suspended: ConsumerContinuation?)
        case finished(messages: Deque<Message>)
    }
    
    public enum SendAction {
        case none
        case resume(continuation: ConsumerContinuation?)
    }
    
    public enum FinishAction {
        case none
        case resume(continuation: ConsumerContinuation?, error: Error?)
    }
    
    public enum NextAction {
        case suspend
        case exit(message: Message)
    }
    
    public enum SuspendedNextAction {
        case resume(message: Message)
        case suspend
    }
}

extension KernelSwiftCommon.Concurrency.Broadcast.UnicastStateMachine {
    public mutating func send(_ payload: Payload) -> SendAction {
        switch state {
        case let .buffering(messages, suspended) where suspended != nil:
            state = .buffering(messages: messages, suspended: nil)
            return .resume(continuation: suspended)
        case var .buffering(messages, _):
            messages.append(.success(payload))
            state = .buffering(messages: messages, suspended: nil)
            return .none
        case .finished: return .none
        }
    }
    
    public mutating func finish(_ error: Error?) -> FinishAction {
        switch state {
        case let .buffering(_, suspended) where suspended != nil:
            state = .finished(messages: [])
            return .resume(continuation: suspended, error: error)
        case var .buffering(messages, _):
            if let error { messages.append(.failure(error)) }
            state = .finished(messages: messages)
            return .none
        case .finished: return .none
        }
    }
    
    public mutating func next() -> NextAction {
        switch state {
        case var .buffering(messages, _) where !messages.isEmpty:
            let message = messages.popFirst()!
            state = .buffering(messages: messages, suspended: nil)
            return .exit(message: message)
        case let .buffering(_, suspended) where suspended != nil:
            preconditionFailure("Invalid state. A consumer is already suspended")
        case .buffering: return .suspend
        case var .finished(messages) where !messages.isEmpty:
            let message = messages.popFirst()!
            state = .finished(messages: messages)
            return .exit(message: message)
        case .finished: return .exit(message: .success(nil))
        }
    }
    
    public mutating func suspendedNext(_ continuation: ConsumerContinuation) -> SuspendedNextAction {
        switch state {
        case var .buffering(messages, _) where !messages.isEmpty:
            let message = messages.popFirst()!
            state = .buffering(messages: messages, suspended: nil)
            return .resume(message: message)
        case let .buffering(_, suspended) where suspended != nil:
            preconditionFailure("Invalid state. A consumer is already suspended")
        case let .buffering(messages, _):
            state = .buffering(messages: messages, suspended: continuation)
            return .suspend
        case var .finished(messages) where !messages.isEmpty:
            let message = messages.popFirst()!
            state = .finished(messages: messages)
            return .resume(message: message)
        case .finished: return .resume(message: .success(nil))
        }
    }
    
    public mutating func cancelledNext() -> ConsumerContinuation? {
        switch state {
        case let .buffering(_, suspended):
            state = .finished(messages: [])
            return suspended
        case .finished: return nil
        }
    }
}
