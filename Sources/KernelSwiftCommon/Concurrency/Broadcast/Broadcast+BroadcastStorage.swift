//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/11/2023.
//

import Foundation

extension KernelSwiftCommon.Concurrency.Broadcast {
    public final class BroadcastStorage<Base: AsyncSequence>: Sendable where Base: Sendable, Base.Element: Sendable {
        public typealias BroadcastState = BroadcastStateMachine<Base>
        public typealias Channel = BroadcastState.Channel
        private let stateMachine: KernelSwiftCommon.Concurrency.Core.ManagedCriticalState<BroadcastState>
        private let ids: KernelSwiftCommon.Concurrency.Core.ManagedCriticalState<Int>
        
        public init(base: Base) {
            self.stateMachine = .init(BroadcastStateMachine(base: base))
            self.ids = .init(0)
        }
        
        public func generateId() -> Int {
            self.ids.withCriticalRegion { ids in
                ids += 1
                return ids
            }
        }
        
        func next(id: Int) async -> Channel.Message? {
            let (shouldExit, element) = stateMachine.withCriticalRegion { stateMachine -> (Bool, Channel.Message?) in
                let action = stateMachine.next(id)
                switch action {
                case .suspend:
                    return (false, nil)
                case .exit(let element):
                    return (true, element)
                }
            }
            
            if shouldExit { return element }
            
            return await withTaskCancellationHandler {
                await withUnsafeContinuation { (continuation: Channel.ConsumerContinuation) in
                    stateMachine.withCriticalRegion { state in
                        let action = state.suspendedNext(id, continuation)
                        switch action {
                        case .startTask(let base):
                            self.startTask(state: &state, base: base, id: id, downstreamContinuation: continuation)
                        case let .suspendedNext(.resume(element)): continuation.resume(returning: element)
                        case .suspendedNext(.suspend): break
                        case let .resumeProducerAndSuspendedNext(upstreamContinuation, .resume(element)):
                            upstreamContinuation?.resume()
                            continuation.resume(returning: element)
                        case let .resumeProducerAndSuspendedNext(upstreamContinuation, .suspend):
                            upstreamContinuation?.resume()
                            break
                        }
                    }
                }
            } onCancel: {
                stateMachine.withCriticalRegion { stateMachine in
                    let action = stateMachine.cancelledNext(id)
                    switch action {
                    case let .cancelledNext(continuation): continuation?.resume(returning: .success(nil))
                    }
                }
            }
        }
        
        private func startTask(
            state: inout BroadcastState,
            base: Base,
            id: Int,
            downstreamContinuation: Channel.ConsumerContinuation
        ) {
            let task = Task {
                do {
                    var iterator = base.makeAsyncIterator()
                    startLoop: while true {
                        await withUnsafeContinuation { (continuation: BroadcastState.ProducerContinuation) in
                            stateMachine.withCriticalRegion { state in
                                let action = state.producerSuspended(continuation)
                                switch action {
                                case .resume: continuation.resume()
                                case .suspend: break
                                }
                            }
                        }
                        
                        guard let element = try await iterator.next() else { break startLoop }
                        
                        stateMachine.withCriticalRegion { state in
                            let actions = state.send(element)
                            for action in actions {
                                switch action {
                                case .none: break
                                case let .resume(continuation): continuation?.resume(returning: .success(element))
                                }
                            }
                        }
                    }
                    
                    stateMachine.withCriticalRegion { state in
                        let actions = state.finish()
                        for action in actions {
                            switch action {
                            case .none: break
                            case let .resume(continuation, _): continuation?.resume(returning: .success(nil))
                            }
                        }
                    }
                } catch {
                    stateMachine.withCriticalRegion { state in
                        let actions = state.finish(error)
                        for action in actions {
                            switch action {
                            case .none: break
                            case let .resume(continuation, _): continuation?.resume(returning: .failure(error))
                            }
                        }
                        
                    }
                }
            }
            
            let action = state.taskStarted(id, task, downstreamContinuation)
            
            switch action {
            case .suspend: break
            case let .resume(element): downstreamContinuation.resume(returning: element)
            }
        }
        
        deinit {
            let task = stateMachine.withCriticalRegion { $0.task() }
            task?.cancel()
        }
    }
}
