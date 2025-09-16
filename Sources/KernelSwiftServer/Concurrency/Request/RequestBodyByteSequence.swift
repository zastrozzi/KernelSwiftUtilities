//
//  File.swift
//
//
//  Created by Jonathan Forbes on 26/05/2023.
//

import Foundation
import Vapor
import NIOCore
import KernelSwiftCommon

public struct RequestBodyByteAsyncSequence: AsyncSequence, Sendable {
    public typealias Element = [UInt8]
    
    let request: Request
    let lowWatermark: Int
    let highWatermark: Int
    
    public func makeAsyncIterator() -> RequestBodyByteAsyncIterator {
        let delegate = RequestBodyByteAsyncSequenceDelegate()
        let producer = NIOThrowingAsyncSequenceProducer.makeSequence(
            elementType: ByteBuffer.self,
            failureType: Error.self,
            backPressureStrategy: NIOAsyncSequenceProducerBackPressureStrategies.HighLowWatermark(
                lowWatermark: lowWatermark,
                highWatermark: highWatermark
            ),
            finishOnDeinit: true,
            delegate: delegate
        )
        
        let source = producer.source
        
        self.request.body.drain { streamResult in
            switch streamResult {
            
            case .error(let error):
                source.finish(error)
                return request.eventLoop.makeSucceededVoidFuture()
            case .end:
                source.finish()
                return request.eventLoop.makeSucceededVoidFuture()
            case .buffer(let byteBuffer):
                let result = source.yield(byteBuffer)
                switch result {
                case .produceMore: return request.eventLoop.makeSucceededVoidFuture()
                case .stopProducing:
                    let asyncPromise = AsyncPromise(Bool.self)
                    delegate.registerBackpressurePromise(asyncPromise)
                    return asyncPromise.voidFuture(for: request.eventLoop)
                case .dropped:
                    return request.eventLoop.makeFailedFuture(CancellationError())
                }
            }
        }
        
        return RequestBodyByteAsyncIterator(underlying: producer.sequence.makeAsyncIterator())
    }
    
    public init(
        request: Request,
        lowWatermark: Int = 5,
        highWatermark: Int = 50
    ) {
        self.request = request
        self.lowWatermark = lowWatermark
        self.highWatermark = highWatermark
    }
}

public struct RequestBodyByteAsyncIterator: AsyncIteratorProtocol {
    public typealias Element = [UInt8]
    public typealias Underlying = NIOThrowingAsyncSequenceProducer<ByteBuffer, any Error, NIOAsyncSequenceProducerBackPressureStrategies.HighLowWatermark, RequestBodyByteAsyncSequenceDelegate>.AsyncIterator
    
    private var underlying: Underlying
    
    public init(underlying: Underlying) {
        self.underlying = underlying
    }
    
    public mutating func next() async throws -> [UInt8]? {
        if var nextBuffer = try await self.underlying.next(), let nextBytes = nextBuffer.readBytes(length: nextBuffer.readableBytes) { return nextBytes }
        return nil
    }
}

public struct RequestBodyByteAsyncSequenceDelegate: NIOAsyncSequenceProducerDelegate {
    
    public struct State: Sendable {
        @usableFromInline
        var delegateState: DelegateState = .noSignalReceived
    }
    
    public enum DelegateState: Sendable {
        case noSignalReceived
        case waitingForSignalFromConsumer(signal: AsyncPromise<Bool>)
    }
    
    @usableFromInline
    internal let state = KernelSwiftCommon.Concurrency.Core.ManagedCriticalState(State())
    
//    @usableFromInline
//    internal var isolationLock: CriticalLock = .allocate()
//    private let eventLoop: any EventLoop
    
    @usableFromInline
    init(
//        state: State
//        eventLoop: any EventLoop
    ) {
//        self.state = state
//        self.eventLoop = eventLoop
    }
    
    @inlinable
    public func produceMore() {
//        self.isolationLock.withLockVoid {
        self.state.withCriticalRegion { managedState in
            switch managedState.delegateState {
            case .noSignalReceived:
                break
            case .waitingForSignalFromConsumer(let signal):
                managedState.delegateState = .noSignalReceived
                signal.fulfill(with: true)
                break
            }
        }
            
//        }
        
    }
    
    @inlinable
    public func didTerminate() {
        self.state.withCriticalRegion { managedState in
            switch managedState.delegateState {
            case .noSignalReceived:
                break
            case .waitingForSignalFromConsumer(let signal):
                managedState.delegateState = .noSignalReceived
                signal.fulfill(with: false)
                break
            }
        }
//        }
    }
    
    @inlinable
    public func registerBackpressurePromise(_ promise: AsyncPromise<Bool>) {
        self.state.withCriticalRegion { managedState in
            switch managedState.delegateState {
            case .noSignalReceived:
                managedState.delegateState = .waitingForSignalFromConsumer(signal: promise)
            case .waitingForSignalFromConsumer:
                break
            }
        }
    }
}
