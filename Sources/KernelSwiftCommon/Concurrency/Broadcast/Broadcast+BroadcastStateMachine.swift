//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/11/2023.
//

import Foundation

extension KernelSwiftCommon.Concurrency.Broadcast {
    public struct BroadcastStateMachine<Base: AsyncSequence>: Sendable where Base: Sendable, Base.Element: Sendable {
        public typealias Channel = UnicastStateMachine<Base.Element>
        public typealias ProducerTask = Task<Void, Never>
        public typealias ProducerContinuation = UnsafeContinuation<Void, Never>
        
        private var state: State
        
        public init(base: Base) {
            self.state = .initial(base: base, channels: [:])
        }
        
        public func task() -> ProducerTask? {
            switch state {
            case let .broadcasting(task, _, _, _, _): task
            default: nil
            }
        }
    }
}

extension KernelSwiftCommon.Concurrency.Broadcast.BroadcastStateMachine {
    public enum State: Sendable {
        case initial(base: Base, channels: [Int: Channel])
        case broadcasting(
            task: ProducerTask,
            producer: ProducerContinuation?,
            channels: [Int: Channel],
            isBusy: Bool,
            demands: Set<Int>
        )
        case finished(channels: [Int: Channel])
    }
    
    public enum SuspendedProducerAction {
        case resume
        case suspend
    }
    
    public enum SuspendedNextAction {
        case suspendedNext(action: Channel.SuspendedNextAction)
        case resumeProducerAndSuspendedNext(continuation: ProducerContinuation?, action: Channel.SuspendedNextAction)
        case startTask(base: Base)
    }
    
    public enum CancelledNextAction {
        case cancelledNext(continuation: Channel.ConsumerContinuation?)
    }
}

extension KernelSwiftCommon.Concurrency.Broadcast.BroadcastStateMachine {
    public mutating func taskStarted(
        _ id: Int,
        _ task: ProducerTask,
        _ continuation: Channel.ConsumerContinuation
    ) -> Channel.SuspendedNextAction {
        guard case var .initial(_, channels) = state else { preconditionFailure("Invalid state.") }
        guard var channel = channels[id] else { preconditionFailure("Invalid state.") }
        let action = channel.suspendedNext(continuation)
        channels[id] = channel
        state = .broadcasting(task: task, producer: nil, channels: channels, isBusy: true, demands: [id])
        return action
    }
    
    public mutating func producerSuspended(_ continuation: ProducerContinuation) -> SuspendedProducerAction {
        guard case let .broadcasting(task, nil, channels, _, demands) = state else { preconditionFailure("Invalid state.") }
        if !demands.isEmpty {
            state = .broadcasting(task: task, producer: continuation, channels: channels, isBusy: true, demands: [])
            return .resume
        }
        state = .broadcasting(task: task, producer: continuation, channels: channels, isBusy: false, demands: demands)
        return .suspend
    }
    
    public mutating func send(_ message: Base.Element) -> [Channel.SendAction] {
        guard case .broadcasting(let task, _, var channels, _, let demands) = state else { preconditionFailure("Invalid state.") }
        var actions: [Channel.SendAction] = []
        for entry in channels {
            let id = entry.key
            var channel = entry.value
            actions.append(channel.send(message))
            channels[id] = channel
        }
        state = .broadcasting(task: task, producer: nil, channels: channels, isBusy: false, demands: demands)
        return actions
    }
    
    public mutating func finish(_ error: Error? = nil) -> [Channel.FinishAction] {
        guard case var .broadcasting(_, _, channels, _, _) = state else { preconditionFailure("Invalid state.") }
        var actions: [Channel.FinishAction] = []
        for entry in channels {
            let id = entry.key
            var channel = entry.value
            actions.append(channel.finish(error))
            channels[id] = channel
        }
        state = .finished(channels: channels)
        return actions
    }
    
    public mutating func next(_ id: Int) -> Channel.NextAction {
        switch state {
        case .initial(let base, var channels):
            var channel: Channel = .init()
            let action = channel.next()
            channels[id] = channel
            state = .initial(base: base, channels: channels)
            return action
        case .broadcasting(let task, let producer, var channels, let isBusy, let demands):
            var channel: Channel = channels[id] ?? .init()
            let action = channel.next()
            channels[id] = channel
            state = .broadcasting(task: task, producer: producer, channels: channels, isBusy: isBusy, demands: demands)
            return action
        case var .finished(channels):
            var channel: Channel = channels[id] ?? .init()
            let action = channel.next()
            channels[id] = channel
            state = .finished(channels: channels)
            return action
        }
    }
    
    public mutating func suspendedNext(_ id: Int, _ continuation: Channel.ConsumerContinuation) -> SuspendedNextAction {
        switch state {
        case let .initial(base, _): return .startTask(base: base)
        case .broadcasting(let task, let producer, var channels, let isBusy, var demands):
            guard var channel = channels[id] else { return .suspendedNext(action: .resume(message: .success(nil))) }
            if isBusy {
                demands.update(with: id)
                let action = channel.suspendedNext(continuation)
                channels[id] = channel
                state = .broadcasting(task: task, producer: producer, channels: channels, isBusy: isBusy, demands: demands)
                return .suspendedNext(action: action)
            }
            demands.removeAll()
            let action = channel.suspendedNext(continuation)
            channels[id] = channel
            state = .broadcasting(task: task, producer: producer, channels: channels, isBusy: true, demands: demands)
            return .resumeProducerAndSuspendedNext(continuation: producer, action: action)
        case var .finished(channels):
            guard var channel = channels[id] else { preconditionFailure("Invalid state.") }
            let action = channel.suspendedNext(continuation)
            channels[id] = channel
            state = .finished(channels: channels)
            return .suspendedNext(action: action)
        }
    }
    
    public mutating func cancelledNext(_ id: Int) -> CancelledNextAction {
        switch state {
        case .initial: preconditionFailure("Invalid state.")
        case .broadcasting(let task, let producer, var channels, let isBusy, var demands):
            guard var channel = channels[id] else { preconditionFailure("Invalid state.") }
            demands.remove(id)
            let continuation = channel.cancelledNext()
            channels[id] = nil
            state = .broadcasting(task: task, producer: producer, channels: channels, isBusy: isBusy, demands: demands)
            return .cancelledNext(continuation: continuation)
        case var .finished(channels):
            guard var channel = channels[id] else { preconditionFailure("Invalid state.") }
            let continuation = channel.cancelledNext()
            channels[id] = nil
            state = .finished(channels: channels)
            return .cancelledNext(continuation: continuation)
        }
    }
}
