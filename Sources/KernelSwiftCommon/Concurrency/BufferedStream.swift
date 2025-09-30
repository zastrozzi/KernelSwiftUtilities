//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation
import DequeModule

extension KernelSwiftCommon.Concurrency {
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public struct BufferedStream<Element: Sendable> {
        @usableFromInline
        final class _Backing: Sendable {
            @usableFromInline
            let storage: _BackPressuredStorage
            
            @usableFromInline
            init(storage: _BackPressuredStorage) {
                self.storage = storage
            }
            
            deinit {
                self.storage.sequenceDeinitialized()
            }
        }
        
        @usableFromInline
        enum _Implementation: Sendable {
            case backpressured(_Backing)
        }
        
        @usableFromInline
        let implementation: _Implementation
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension KernelSwiftCommon.Concurrency.BufferedStream: AsyncSequence {
    public struct Iterator: AsyncIteratorProtocol {
        
        public final class _Backing {
            @usableFromInline
            let storage: _BackPressuredStorage
            
            @usableFromInline
            init(storage: _BackPressuredStorage) {
                self.storage = storage
                self.storage.iteratorInitialized()
            }
            
            deinit {
                self.storage.iteratorDeinitialized()
            }
        }
        
        
        public enum _Implementation {
            case backpressured(_Backing)
        }
        
        @usableFromInline
        var implementation: _Implementation
        
        public init(implementation: _Implementation) {
            self.implementation = implementation
        }
        
        @inlinable
        public mutating func next() async throws -> Element? {
            switch self.implementation {
            case .backpressured(let backing):
                return try await backing.storage.next()
            }
        }
    }
    
    @inlinable
    public func makeAsyncIterator() -> Iterator {
        switch self.implementation {
        case .backpressured(let backing):
            return Iterator(implementation: .backpressured(.init(storage: backing.storage)))
        }
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension KernelSwiftCommon.Concurrency.BufferedStream: Sendable where Element: Sendable {}

extension KernelSwiftCommon.Concurrency.BufferedStream {
    @usableFromInline
    internal struct _ManagedCriticalState<State: Sendable>: @unchecked Sendable {
        @usableFromInline
        let lock: KernelSwiftCommon.Concurrency.Core.StreamLock.LockedValueBox<State>
        
        @usableFromInline
        internal init(_ initial: State) {
            self.lock = .init(initial)
        }
        
        @inlinable
        internal func withCriticalRegion<R>(
            _ critical: (inout State) throws -> R
        ) rethrows -> R {
            try self.lock.withLockedValue(critical)
        }
    }
    
    @usableFromInline
    internal struct AlreadyFinishedError: Error {
        @usableFromInline
        init() {}
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension KernelSwiftCommon.Concurrency.BufferedStream {
    public struct Source: Sendable {
        public struct BackPressureStrategy: Sendable {
            @inlinable
            internal static func watermark(low: Int, high: Int) -> BackPressureStrategy {
                BackPressureStrategy(
                    internalBackPressureStrategy: .watermark(.init(low: low, high: high))
                )
            }
            
            public static func customWatermark(
                low: Int,
                high: Int,
                waterLevelForElement: @escaping @Sendable (Element) -> Int
            ) -> BackPressureStrategy where Element: RandomAccessCollection {
                BackPressureStrategy(
                    internalBackPressureStrategy: .watermark(.init(low: low, high: high, waterLevelForElement: waterLevelForElement))
                )
            }
            
            @usableFromInline
            init(internalBackPressureStrategy: _InternalBackPressureStrategy) {
                self._internalBackPressureStrategy = internalBackPressureStrategy
            }
            
            @usableFromInline
            let _internalBackPressureStrategy: _InternalBackPressureStrategy
        }
        
        public enum WriteResult: Sendable {
            public struct CallbackToken: Sendable {
                @usableFromInline
                let id: UInt
                @usableFromInline
                init(id: UInt) {
                    self.id = id
                }
            }
            
            case produceMore
            
            case enqueueCallback(CallbackToken)
        }
        
        @usableFromInline
        final class _Backing: Sendable {
            @usableFromInline
            let storage: _BackPressuredStorage
            
            @usableFromInline
            init(storage: _BackPressuredStorage) {
                self.storage = storage
            }
            
            deinit {
                self.storage.sourceDeinitialized()
            }
        }
        
        @inlinable
        internal var onTermination: (@Sendable () -> Void)? {
            set {
                self._backing.storage.onTermination = newValue
            }
            get {
                self._backing.storage.onTermination
            }
        }
        
        @usableFromInline
        var _backing: _Backing
        
        @usableFromInline
        internal init(storage: _BackPressuredStorage) {
            self._backing = .init(storage: storage)
        }
        
        public func write<S>(contentsOf sequence: S) throws -> WriteResult
        where Element == S.Element, S: Sequence {
            try self._backing.storage.write(contentsOf: sequence)
        }
        
        @inlinable
        internal func write(_ element: Element) throws -> WriteResult {
            try self._backing.storage.write(contentsOf: CollectionOfOne(element))
        }
        
        public func enqueueCallback(
            callbackToken: WriteResult.CallbackToken,
            onProduceMore: @escaping @Sendable (Result<Void, any Error>) -> Void
        ) {
            self._backing.storage.enqueueProducer(
                callbackToken: callbackToken,
                onProduceMore: onProduceMore
            )
        }
        
        @inlinable
        internal func cancelCallback(callbackToken: WriteResult.CallbackToken) {
            self._backing.storage.cancelProducer(callbackToken: callbackToken)
        }

        @inlinable
        internal func write<S>(
            contentsOf sequence: S,
            onProduceMore: @escaping @Sendable (Result<Void, any Error>) -> Void
        ) where Element == S.Element, S: Sequence {
            do {
                let writeResult = try self.write(contentsOf: sequence)
                
                switch writeResult {
                case .produceMore:
                    onProduceMore(Result<Void, any Error>.success(()))
                    
                case .enqueueCallback(let callbackToken):
                    self.enqueueCallback(callbackToken: callbackToken, onProduceMore: onProduceMore)
                }
            } catch {
                onProduceMore(.failure(error))
            }
        }

        @inlinable
        internal func write(
            _ element: Element,
            onProduceMore: @escaping @Sendable (Result<Void, any Error>) -> Void
        ) {
            self.write(contentsOf: CollectionOfOne(element), onProduceMore: onProduceMore)
        }
        
        @inlinable
        internal func write<S>(contentsOf sequence: S) async throws
        where Element == S.Element, S: Sequence {
            let writeResult = try { try self.write(contentsOf: sequence) }()
            
            switch writeResult {
            case .produceMore:
                return
                
            case .enqueueCallback(let callbackToken):
                try await withTaskCancellationHandler {
                    try await withCheckedThrowingContinuation { continuation in
                        self.enqueueCallback(
                            callbackToken: callbackToken,
                            onProduceMore: { result in
                                switch result {
                                case .success():
                                    continuation.resume(returning: ())
                                case .failure(let error):
                                    continuation.resume(throwing: error)
                                }
                            }
                        )
                    }
                } onCancel: {
                    self.cancelCallback(callbackToken: callbackToken)
                }
            }
        }

        @inlinable
        internal func write(_ element: Element) async throws {
            try await self.write(contentsOf: CollectionOfOne(element))
        }

        @inlinable
        internal func write<S>(contentsOf sequence: S) async throws
        where Element == S.Element, S: AsyncSequence {
            for try await element in sequence {
                try await self.write(contentsOf: CollectionOfOne(element))
            }
        }

        public func finish(throwing error: (any Error)?) {
            self._backing.storage.finish(error)
        }
    }

    @inlinable
    public static func makeStream(
        of elementType: Element.Type = Element.self,
        throwing failureType: any Error.Type = (any Error).self,
        backPressureStrategy: Source.BackPressureStrategy
    ) -> (`Self`, Source) where any Error == any Error {
        let storage = _BackPressuredStorage(
            backPressureStrategy: backPressureStrategy._internalBackPressureStrategy
        )
        let source = Source(storage: storage)
        
        return (.init(storage: storage), source)
    }
    
    @usableFromInline
    init(storage: _BackPressuredStorage) {
        self.implementation = .backpressured(.init(storage: storage))
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension KernelSwiftCommon.Concurrency.BufferedStream {
    @usableFromInline
    struct _WatermarkBackPressureStrategy: Sendable {
        
        @usableFromInline
        let _low: Int
        
        @usableFromInline
        let _high: Int
        
        @usableFromInline
        private(set) var _current: Int
        
        @usableFromInline
        let _waterLevelForElement: (@Sendable (Element) -> Int)?
        
        @usableFromInline
        init(low: Int, high: Int, waterLevelForElement: (@Sendable (Element) -> Int)? = nil) {
            precondition(low <= high)
            self._low = low
            self._high = high
            self._current = 0
            self._waterLevelForElement = waterLevelForElement
        }
        
        @usableFromInline
        mutating func didYield(elements: Deque<Element>.SubSequence) -> Bool {
            if let waterLevelForElement = self._waterLevelForElement {
                self._current += elements.reduce(0) { $0 + waterLevelForElement($1) }
            } else {
                self._current += elements.count
            }
            precondition(self._current >= 0, "Watermark below zero")
            
            return self._current < self._high
        }
        
        @usableFromInline
        mutating func didConsume(elements: Deque<Element>.SubSequence) -> Bool {
            if let waterLevelForElement = self._waterLevelForElement {
                self._current -= elements.reduce(0) { $0 + waterLevelForElement($1) }
            } else {
                self._current -= elements.count
            }
            precondition(self._current >= 0, "Watermark below zero")
            
            return self._current < self._low
        }
        
        @usableFromInline
        mutating func didConsume(element: Element) -> Bool {
            if let waterLevelForElement = self._waterLevelForElement {
                self._current -= waterLevelForElement(element)
            } else {
                self._current -= 1
            }
            precondition(self._current >= 0, "Watermark below zero")
            
            return self._current < self._low
        }
    }
    
    @usableFromInline
    enum _InternalBackPressureStrategy: Sendable {
        case watermark(_WatermarkBackPressureStrategy)
        
        @inlinable
        mutating func didYield(elements: Deque<Element>.SubSequence) -> Bool {
            switch self {
            case .watermark(var strategy):
                let result = strategy.didYield(elements: elements)
                self = .watermark(strategy)
                return result
            }
        }
        
        @usableFromInline
        mutating func didConsume(elements: Deque<Element>.SubSequence) -> Bool {
            switch self {
            case .watermark(var strategy):
                let result = strategy.didConsume(elements: elements)
                self = .watermark(strategy)
                return result
            }
        }
        
        @usableFromInline
        mutating func didConsume(element: Element) -> Bool {
            switch self {
            case .watermark(var strategy):
                let result = strategy.didConsume(element: element)
                self = .watermark(strategy)
                return result
            }
        }
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension KernelSwiftCommon.Concurrency.BufferedStream {
    
    @usableFromInline
    final class _BackPressuredStorage: Sendable {
        
        @usableFromInline
        let _stateMachine: _ManagedCriticalState<_StateMachine>
        
        @usableFromInline
        var onTermination: (@Sendable () -> Void)? {
            set {
                self._stateMachine.withCriticalRegion {
                    $0._onTermination = newValue
                }
            }
            get {
                self._stateMachine.withCriticalRegion {
                    $0._onTermination
                }
            }
        }
        
        @usableFromInline
        init(
            backPressureStrategy: _InternalBackPressureStrategy
        ) {
            self._stateMachine = .init(.init(backPressureStrategy: backPressureStrategy))
        }
        
        @inlinable
        func sequenceDeinitialized() {
            let action = self._stateMachine.withCriticalRegion {
                $0.sequenceDeinitialized()
            }
            
            switch action {
            case .callOnTermination(let onTermination):
                onTermination?()
                
            case .failProducersAndCallOnTermination(let producerContinuations, let onTermination):
                for producerContinuation in producerContinuations {
                    producerContinuation(.failure(AlreadyFinishedError()))
                }
                onTermination?()
                
            case .none:
                break
            }
        }
        
        @inlinable
        func iteratorInitialized() {
            self._stateMachine.withCriticalRegion {
                $0.iteratorInitialized()
            }
        }
        
        @inlinable
        func iteratorDeinitialized() {
            let action = self._stateMachine.withCriticalRegion {
                $0.iteratorDeinitialized()
            }
            
            switch action {
            case .callOnTermination(let onTermination):
                onTermination?()
                
            case .failProducersAndCallOnTermination(let producerContinuations, let onTermination):
                for producerContinuation in producerContinuations {
                    producerContinuation(.failure(AlreadyFinishedError()))
                }
                onTermination?()
                
            case .none:
                break
            }
        }
        
        @inlinable
        func sourceDeinitialized() {
            let action = self._stateMachine.withCriticalRegion {
                $0.sourceDeinitialized()
            }
            
            switch action {
            case .callOnTermination(let onTermination):
                onTermination?()
                
            case .failProducersAndCallOnTermination(
                let consumer,
                let producerContinuations,
                let onTermination
            ):
                consumer?.resume(returning: nil)
                for producerContinuation in producerContinuations {
                    producerContinuation(.failure(AlreadyFinishedError()))
                }
                onTermination?()
                
            case .failProducers(let producerContinuations):
                for producerContinuation in producerContinuations {
                    producerContinuation(.failure(AlreadyFinishedError()))
                }
                
            case .none:
                break
            }
        }
        
        @inlinable
        func write(
            contentsOf sequence: some Sequence<Element>
        ) throws -> Source.WriteResult {
            let action = self._stateMachine.withCriticalRegion {
                return $0.write(sequence)
            }
            
            switch action {
            case .returnProduceMore:
                return .produceMore
                
            case .returnEnqueue(let callbackToken):
                return .enqueueCallback(callbackToken)
                
            case .resumeConsumerAndReturnProduceMore(let continuation, let element):
                continuation.resume(returning: element)
                return .produceMore
                
            case .resumeConsumerAndReturnEnqueue(let continuation, let element, let callbackToken):
                continuation.resume(returning: element)
                return .enqueueCallback(callbackToken)
                
            case .throwFinishedError:
                throw AlreadyFinishedError()
            }
        }
        
        @inlinable
        func enqueueProducer(
            callbackToken: Source.WriteResult.CallbackToken,
            onProduceMore: @escaping @Sendable (Result<Void, any Error>) -> Void
        ) {
            let action = self._stateMachine.withCriticalRegion {
                $0.enqueueProducer(callbackToken: callbackToken, onProduceMore: onProduceMore)
            }
            
            switch action {
            case .resumeProducer(let onProduceMore):
                onProduceMore(Result<Void, any Error>.success(()))
                
            case .resumeProducerWithError(let onProduceMore, let error):
                onProduceMore(Result<Void, any Error>.failure(error))
                
            case .none:
                break
            }
        }
        
        @inlinable
        func cancelProducer(callbackToken: Source.WriteResult.CallbackToken) {
            let action = self._stateMachine.withCriticalRegion {
                $0.cancelProducer(callbackToken: callbackToken)
            }
            
            switch action {
            case .resumeProducerWithCancellationError(let onProduceMore):
                onProduceMore(Result<Void, any Error>.failure(CancellationError()))
                
            case .none:
                break
            }
        }
        
        @inlinable
        func finish(_ failure: (any Error)?) {
            let action = self._stateMachine.withCriticalRegion {
                $0.finish(failure)
            }
            
            switch action {
            case .callOnTermination(let onTermination):
                onTermination?()
                
            case .resumeConsumerAndCallOnTermination(
                let consumerContinuation,
                let failure,
                let onTermination
            ):
                switch failure {
                case .some(let error):
                    consumerContinuation.resume(throwing: error)
                case .none:
                    consumerContinuation.resume(returning: nil)
                }
                
                onTermination?()
                
            case .resumeProducers(let producerContinuations):
                for producerContinuation in producerContinuations {
                    producerContinuation(.failure(AlreadyFinishedError()))
                }
                
            case .none:
                break
            }
        }
        
        @inlinable
        func next() async throws -> Element? {
            let action = self._stateMachine.withCriticalRegion {
                $0.next()
            }
            
            switch action {
            case .returnElement(let element):
                return element
                
            case .returnElementAndResumeProducers(let element, let producerContinuations):
                for producerContinuation in producerContinuations {
                    producerContinuation(Result<Void, any Error>.success(()))
                }
                
                return element
                
            case .returnErrorAndCallOnTermination(let failure, let onTermination):
                onTermination?()
                switch failure {
                case .some(let error):
                    throw error
                    
                case .none:
                    return nil
                }
                
            case .returnNil:
                return nil
                
            case .suspendTask:
                return try await self.suspendNext()
            }
        }
        
        @inlinable
        func suspendNext() async throws -> Element? {
            return try await withTaskCancellationHandler {
                return try await withCheckedThrowingContinuation { continuation in
                    let action = self._stateMachine.withCriticalRegion {
                        $0.suspendNext(continuation: continuation)
                    }
                    
                    switch action {
                    case .resumeConsumerWithElement(let continuation, let element):
                        continuation.resume(returning: element)
                        
                    case .resumeConsumerWithElementAndProducers(
                        let continuation,
                        let element,
                        let producerContinuations
                    ):
                        continuation.resume(returning: element)
                        for producerContinuation in producerContinuations {
                            producerContinuation(Result<Void, any Error>.success(()))
                        }
                        
                    case .resumeConsumerWithErrorAndCallOnTermination(
                        let continuation,
                        let failure,
                        let onTermination
                    ):
                        switch failure {
                        case .some(let error):
                            continuation.resume(throwing: error)
                            
                        case .none:
                            continuation.resume(returning: nil)
                        }
                        onTermination?()
                        
                    case .resumeConsumerWithNil(let continuation):
                        continuation.resume(returning: nil)
                        
                    case .none:
                        break
                    }
                }
            } onCancel: {
                let action = self._stateMachine.withCriticalRegion {
                    $0.cancelNext()
                }
                
                switch action {
                case .resumeConsumerWithCancellationErrorAndCallOnTermination(
                    let continuation,
                    let onTermination
                ):
                    continuation.resume(throwing: CancellationError())
                    onTermination?()
                    
                case .failProducersAndCallOnTermination(
                    let producerContinuations,
                    let onTermination
                ):
                    for producerContinuation in producerContinuations {
                        producerContinuation(.failure(AlreadyFinishedError()))
                    }
                    onTermination?()
                    
                case .none:
                    break
                }
            }
        }
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension KernelSwiftCommon.Concurrency.BufferedStream {
    
    @usableFromInline
    struct _StateMachine: Sendable {
        @usableFromInline
        enum _State: Sendable {
            @usableFromInline
            struct Initial: Sendable {
                
                @usableFromInline
                var backPressureStrategy: _InternalBackPressureStrategy
                
                @usableFromInline
                var iteratorInitialized: Bool
                
                @usableFromInline
                var onTermination: (@Sendable () -> Void)?
                
                @usableFromInline
                init(
                    backPressureStrategy: _InternalBackPressureStrategy,
                    iteratorInitialized: Bool,
                    onTermination: (@Sendable () -> Void)? = nil
                ) {
                    self.backPressureStrategy = backPressureStrategy
                    self.iteratorInitialized = iteratorInitialized
                    self.onTermination = onTermination
                }
            }
            
            @usableFromInline
            struct Streaming: Sendable {
                
                @usableFromInline
                var backPressureStrategy: _InternalBackPressureStrategy
                
                @usableFromInline
                var iteratorInitialized: Bool
                
                @usableFromInline
                var onTermination: (@Sendable () -> Void)?
                
                @usableFromInline
                var buffer: Deque<Element>
                
                @usableFromInline
                var consumerContinuation: CheckedContinuation<Element?, any Error>?
                
                @usableFromInline
                var producerContinuations: Deque<(UInt, @Sendable (Result<Void, any Error>) -> Void)>
                
                @usableFromInline
                var cancelledAsyncProducers: Deque<UInt>
                
                @usableFromInline
                var hasOutstandingDemand: Bool
                
                @usableFromInline
                init(
                    backPressureStrategy: _InternalBackPressureStrategy,
                    iteratorInitialized: Bool,
                    onTermination: (@Sendable () -> Void)? = nil,
                    buffer: Deque<Element>,
                    consumerContinuation: CheckedContinuation<Element?, any Error>? = nil,
                    producerContinuations: Deque<(UInt, @Sendable (Result<Void, any Error>) -> Void)>,
                    cancelledAsyncProducers: Deque<UInt>,
                    hasOutstandingDemand: Bool
                ) {
                    self.backPressureStrategy = backPressureStrategy
                    self.iteratorInitialized = iteratorInitialized
                    self.onTermination = onTermination
                    self.buffer = buffer
                    self.consumerContinuation = consumerContinuation
                    self.producerContinuations = producerContinuations
                    self.cancelledAsyncProducers = cancelledAsyncProducers
                    self.hasOutstandingDemand = hasOutstandingDemand
                }
            }
            
            @usableFromInline
            struct SourceFinished: Sendable {
                
                @usableFromInline
                var iteratorInitialized: Bool
                
                @usableFromInline
                var buffer: Deque<Element>
                
                @usableFromInline
                var failure: (any Error)?
                
                @usableFromInline
                var onTermination: (@Sendable () -> Void)?
                
                @usableFromInline
                init(
                    iteratorInitialized: Bool,
                    buffer: Deque<Element>,
                    failure: (any Error)? = nil,
                    onTermination: (@Sendable () -> Void)?
                ) {
                    self.iteratorInitialized = iteratorInitialized
                    self.buffer = buffer
                    self.failure = failure
                    self.onTermination = onTermination
                }
            }
            
            case initial(Initial)
            case streaming(Streaming)
            case sourceFinished(SourceFinished)
            
            case finished(iteratorInitialized: Bool)
            
            case modify
        }
        
        @usableFromInline
        var _state: _State
        
        @usableFromInline
        var nextCallbackTokenID: UInt = 0
        
        @inlinable
        var _onTermination: (@Sendable () -> Void)? {
            set {
                switch self._state {
                case .initial(var initial):
                    initial.onTermination = newValue
                    self._state = .initial(initial)
                    
                case .streaming(var streaming):
                    streaming.onTermination = newValue
                    self._state = .streaming(streaming)
                    
                case .sourceFinished(var sourceFinished):
                    sourceFinished.onTermination = newValue
                    self._state = .sourceFinished(sourceFinished)
                    
                case .finished:
                    break
                    
                case .modify:
                    fatalError("AsyncStream internal inconsistency")
                }
            }
            get {
                switch self._state {
                case .initial(let initial):
                    return initial.onTermination
                    
                case .streaming(let streaming):
                    return streaming.onTermination
                    
                case .sourceFinished(let sourceFinished):
                    return sourceFinished.onTermination
                    
                case .finished:
                    return nil
                    
                case .modify:
                    fatalError("AsyncStream internal inconsistency")
                }
            }
        }
        
        @usableFromInline
        init(
            backPressureStrategy: _InternalBackPressureStrategy
        ) {
            self._state = .initial(
                .init(
                    backPressureStrategy: backPressureStrategy,
                    iteratorInitialized: false
                )
            )
        }
        
        @inlinable
        mutating func nextCallbackToken() -> Source.WriteResult.CallbackToken {
            let id = self.nextCallbackTokenID
            self.nextCallbackTokenID += 1
            return .init(id: id)
        }
        
        @usableFromInline
        enum SequenceDeinitializedAction {
            case callOnTermination((@Sendable () -> Void)?)
            
            case failProducersAndCallOnTermination(
                [(Result<Void, any Error>) -> Void],
                (@Sendable () -> Void)?
            )
        }
        
        @inlinable
        mutating func sequenceDeinitialized() -> SequenceDeinitializedAction? {
            switch self._state {
            case .initial(let initial):
                if initial.iteratorInitialized {
                    return .none
                } else {
                    self._state = .finished(iteratorInitialized: false)
                    
                    return .callOnTermination(initial.onTermination)
                }
                
            case .streaming(let streaming):
                if streaming.iteratorInitialized {
                    return .none
                } else {
                    self._state = .finished(iteratorInitialized: false)
                    
                    return .failProducersAndCallOnTermination(
                        Array(streaming.producerContinuations.map { $0.1 }),
                        streaming.onTermination
                    )
                }
                
            case .sourceFinished(let sourceFinished):
                if sourceFinished.iteratorInitialized {
                    return .none
                } else {
                    self._state = .finished(iteratorInitialized: false)
                    
                    return .callOnTermination(sourceFinished.onTermination)
                }
                
            case .finished:
                return .none
                
            case .modify:
                fatalError("AsyncStream internal inconsistency")
            }
        }
        
        @inlinable
        mutating func iteratorInitialized() {
            switch self._state {
            case .initial(var initial):
                if initial.iteratorInitialized {
                    fatalError("Only a single AsyncIterator can be created")
                } else {
                    initial.iteratorInitialized = true
                    self._state = .initial(initial)
                }
                
            case .streaming(var streaming):
                if streaming.iteratorInitialized {
                    fatalError("Only a single AsyncIterator can be created")
                } else {
                    streaming.iteratorInitialized = true
                    self._state = .streaming(streaming)
                }
                
            case .sourceFinished(var sourceFinished):
                if sourceFinished.iteratorInitialized {
                    fatalError("Only a single AsyncIterator can be created")
                } else {
                    sourceFinished.iteratorInitialized = true
                    self._state = .sourceFinished(sourceFinished)
                }
                
            case .finished(iteratorInitialized: true):
                fatalError("Only a single AsyncIterator can be created")
                
            case .finished(iteratorInitialized: false):
                self._state = .finished(iteratorInitialized: true)
                
            case .modify:
                fatalError("AsyncStream internal inconsistency")
            }
        }
        
        @usableFromInline
        enum IteratorDeinitializedAction {
            case callOnTermination((@Sendable () -> Void)?)
            case failProducersAndCallOnTermination(
                [(Result<Void, any Error>) -> Void],
                (@Sendable () -> Void)?
            )
        }
        
        @inlinable
        mutating func iteratorDeinitialized() -> IteratorDeinitializedAction? {
            switch self._state {
            case .initial(let initial):
                if initial.iteratorInitialized {
                    self._state = .finished(iteratorInitialized: true)
                    return .callOnTermination(initial.onTermination)
                } else {
                    fatalError("AsyncStream internal inconsistency")
                }
                
            case .streaming(let streaming):
                if streaming.iteratorInitialized {
                    self._state = .finished(iteratorInitialized: true)
                    
                    return .failProducersAndCallOnTermination(
                        Array(streaming.producerContinuations.map { $0.1 }),
                        streaming.onTermination
                    )
                } else {
                    fatalError("AsyncStream internal inconsistency")
                }
                
            case .sourceFinished(let sourceFinished):
                if sourceFinished.iteratorInitialized {
                    self._state = .finished(iteratorInitialized: true)
                    return .callOnTermination(sourceFinished.onTermination)
                } else {
                    fatalError("AsyncStream internal inconsistency")
                }
                
            case .finished:
                return .none
                
            case .modify:
                fatalError("AsyncStream internal inconsistency")
            }
        }
    
        @usableFromInline
        enum SourceDeinitializedAction {
            case callOnTermination((() -> Void)?)
            case failProducersAndCallOnTermination(
                CheckedContinuation<Element?, any Error>?,
                [(Result<Void, any Error>) -> Void],
                (@Sendable () -> Void)?
            )
            case failProducers([(Result<Void, any Error>) -> Void])
        }
        
        @inlinable
        mutating func sourceDeinitialized() -> SourceDeinitializedAction? {
            switch self._state {
            case .initial(let initial):

                self._state = .finished(iteratorInitialized: initial.iteratorInitialized)
                return .callOnTermination(initial.onTermination)
                
            case .streaming(let streaming):
                if streaming.buffer.isEmpty {
    
                    self._state = .finished(iteratorInitialized: streaming.iteratorInitialized)
                    
                    return .failProducersAndCallOnTermination(
                        streaming.consumerContinuation,
                        Array(streaming.producerContinuations.map { $0.1 }),
                        streaming.onTermination
                    )
                } else {
    
                    precondition(streaming.consumerContinuation == nil)
                    
                    self._state = .sourceFinished(
                        .init(
                            iteratorInitialized: streaming.iteratorInitialized,
                            buffer: streaming.buffer,
                            failure: nil,
                            onTermination: streaming.onTermination
                        )
                    )
                    
                    return .failProducers(
                        Array(streaming.producerContinuations.map { $0.1 })
                    )
                }
                
            case .sourceFinished, .finished:

                return .none
                
            case .modify:
                fatalError("AsyncStream internal inconsistency")
            }
        }
    
        @usableFromInline
        enum WriteAction {
            case returnProduceMore
            case returnEnqueue(
                callbackToken: Source.WriteResult.CallbackToken
            )
            case resumeConsumerAndReturnProduceMore(
                continuation: CheckedContinuation<Element?, any Error>,
                element: Element
            )
            case resumeConsumerAndReturnEnqueue(
                continuation: CheckedContinuation<Element?, any Error>,
                element: Element,
                callbackToken: Source.WriteResult.CallbackToken
            )
            case throwFinishedError
            
            @inlinable
            init(
                callbackToken: Source.WriteResult.CallbackToken?,
                continuationAndElement: (CheckedContinuation<Element?, any Error>, Element)? = nil
            ) {
                switch (callbackToken, continuationAndElement) {
                case (.none, .none):
                    self = .returnProduceMore
                    
                case (.some(let callbackToken), .none):
                    self = .returnEnqueue(callbackToken: callbackToken)
                    
                case (.none, .some((let continuation, let element))):
                    self = .resumeConsumerAndReturnProduceMore(
                        continuation: continuation,
                        element: element
                    )
                    
                case (.some(let callbackToken), .some((let continuation, let element))):
                    self = .resumeConsumerAndReturnEnqueue(
                        continuation: continuation,
                        element: element,
                        callbackToken: callbackToken
                    )
                }
            }
        }
        
        @inlinable
        mutating func write(_ sequence: some Sequence<Element>) -> WriteAction {
            switch self._state {
            case .initial(var initial):
                var buffer = Deque<Element>()
                buffer.append(contentsOf: sequence)
                
                let shouldProduceMore = initial.backPressureStrategy.didYield(elements: buffer[...])
                let callbackToken = shouldProduceMore ? nil : self.nextCallbackToken()
                
                self._state = .streaming(
                    .init(
                        backPressureStrategy: initial.backPressureStrategy,
                        iteratorInitialized: initial.iteratorInitialized,
                        onTermination: initial.onTermination,
                        buffer: buffer,
                        consumerContinuation: nil,
                        producerContinuations: .init(),
                        cancelledAsyncProducers: .init(),
                        hasOutstandingDemand: shouldProduceMore
                    )
                )
                
                return .init(callbackToken: callbackToken)
                
            case .streaming(var streaming):
                self._state = .modify
                
                let bufferEndIndexBeforeAppend = streaming.buffer.endIndex
                streaming.buffer.append(contentsOf: sequence)
                
                streaming.hasOutstandingDemand = streaming.backPressureStrategy.didYield(
                    elements: streaming.buffer[bufferEndIndexBeforeAppend...]
                )
                
                if let consumerContinuation = streaming.consumerContinuation {
                    guard let element = streaming.buffer.popFirst() else {
                        
                        self._state = .streaming(streaming)
                        
                        return .init(callbackToken: streaming.hasOutstandingDemand ? nil : self.nextCallbackToken())
                    }
                    streaming.hasOutstandingDemand = streaming.backPressureStrategy.didConsume(element: element)
                    
                    streaming.consumerContinuation = nil
                    self._state = .streaming(streaming)
                    return .init(
                        callbackToken: streaming.hasOutstandingDemand ? nil : self.nextCallbackToken(),
                        continuationAndElement: (consumerContinuation, element)
                    )
                } else {
                    self._state = .streaming(streaming)
                    return .init(
                        callbackToken: streaming.hasOutstandingDemand ? nil : self.nextCallbackToken()
                    )
                }
                
            case .sourceFinished, .finished:
                return .throwFinishedError
                
            case .modify:
                fatalError("AsyncStream internal inconsistency")
            }
        }
        
        @usableFromInline
        enum EnqueueProducerAction {
            
            case resumeProducer((Result<Void, any Error>) -> Void)
            
            case resumeProducerWithError((Result<Void, any Error>) -> Void, any Error)
        }
        
        @inlinable
        mutating func enqueueProducer(
            callbackToken: Source.WriteResult.CallbackToken,
            onProduceMore: @Sendable @escaping (Result<Void, any Error>) -> Void
        ) -> EnqueueProducerAction? {
            switch self._state {
            case .initial:
                fatalError("AsyncStream internal inconsistency")
                
            case .streaming(var streaming):
                if let index = streaming.cancelledAsyncProducers.firstIndex(of: callbackToken.id) {
                    self._state = .modify
                    streaming.cancelledAsyncProducers.remove(at: index)
                    self._state = .streaming(streaming)
                    
                    return .resumeProducerWithError(onProduceMore, CancellationError())
                } else if streaming.hasOutstandingDemand {
                    return .resumeProducer(onProduceMore)
                } else {
                    self._state = .modify
                    streaming.producerContinuations.append((callbackToken.id, onProduceMore))
                    
                    self._state = .streaming(streaming)
                    return .none
                }
                
            case .sourceFinished, .finished:
                return .resumeProducerWithError(onProduceMore, AlreadyFinishedError())
                
            case .modify:
                fatalError("AsyncStream internal inconsistency")
            }
        }
        
        @usableFromInline
        enum CancelProducerAction {
            case resumeProducerWithCancellationError((Result<Void, any Error>) -> Void)
        }
        
        @inlinable
        mutating func cancelProducer(
            callbackToken: Source.WriteResult.CallbackToken
        ) -> CancelProducerAction? {
            switch self._state {
            case .initial:
                
                fatalError("AsyncStream internal inconsistency")
                
            case .streaming(var streaming):
                if let index = streaming.producerContinuations.firstIndex(where: {
                    $0.0 == callbackToken.id
                }) {
                    
                    self._state = .modify
                    let continuation = streaming.producerContinuations.remove(at: index).1
                    self._state = .streaming(streaming)
                    
                    return .resumeProducerWithCancellationError(continuation)
                } else {
                    
                    self._state = .modify
                    streaming.cancelledAsyncProducers.append(callbackToken.id)
                    self._state = .streaming(streaming)
                    
                    return .none
                }
                
            case .sourceFinished, .finished:
                return .none
                
            case .modify:
                fatalError("AsyncStream internal inconsistency")
            }
        }
        
        @usableFromInline
        enum FinishAction {
            case callOnTermination((() -> Void)?)
            case resumeConsumerAndCallOnTermination(
                consumerContinuation: CheckedContinuation<Element?, any Error>,
                failure: (any Error)?,
                onTermination: (() -> Void)?
            )
            case resumeProducers(
                producerContinuations: [(Result<Void, any Error>) -> Void]
            )
        }
        
        @inlinable
        mutating func finish(_ failure: (any Error)?) -> FinishAction? {
            switch self._state {
            case .initial(let initial):
                
                self._state = .sourceFinished(
                    .init(
                        iteratorInitialized: initial.iteratorInitialized,
                        buffer: .init(),
                        failure: failure,
                        onTermination: initial.onTermination
                    )
                )
                
                return .callOnTermination(initial.onTermination)
                
            case .streaming(let streaming):
                if let consumerContinuation = streaming.consumerContinuation {
                    
                    precondition(streaming.buffer.isEmpty, "Expected an empty buffer")
                    precondition(
                        streaming.producerContinuations.isEmpty,
                        "Expected no suspended producers"
                    )
                    
                    self._state = .finished(iteratorInitialized: streaming.iteratorInitialized)
                    
                    return .resumeConsumerAndCallOnTermination(
                        consumerContinuation: consumerContinuation,
                        failure: failure,
                        onTermination: streaming.onTermination
                    )
                } else {
                    self._state = .sourceFinished(
                        .init(
                            iteratorInitialized: streaming.iteratorInitialized,
                            buffer: streaming.buffer,
                            failure: failure,
                            onTermination: streaming.onTermination
                        )
                    )
                    
                    return .resumeProducers(
                        producerContinuations: Array(streaming.producerContinuations.map { $0.1 })
                    )
                }
                
            case .sourceFinished, .finished:
                
                return .none
                
            case .modify:
                fatalError("AsyncStream internal inconsistency")
            }
        }
        
        
        @usableFromInline
        enum NextAction {
            
            case returnElement(Element)
            
            case returnElementAndResumeProducers(Element, [(Result<Void, any Error>) -> Void])
            
            case returnErrorAndCallOnTermination((any Error)?, (() -> Void)?)
            
            case returnNil
            case suspendTask
        }
        
        @inlinable
        mutating func next() -> NextAction {
            switch self._state {
            case .initial(let initial):
                self._state = .streaming(
                    .init(
                        backPressureStrategy: initial.backPressureStrategy,
                        iteratorInitialized: initial.iteratorInitialized,
                        onTermination: initial.onTermination,
                        buffer: Deque<Element>(),
                        consumerContinuation: nil,
                        producerContinuations: .init(),
                        cancelledAsyncProducers: .init(),
                        hasOutstandingDemand: false
                    )
                )
                
                return .suspendTask
            case .streaming(var streaming):
                guard streaming.consumerContinuation == nil else {
                    fatalError("AsyncStream internal inconsistency")
                }
                
                self._state = .modify
                
                if let element = streaming.buffer.popFirst() {
                    streaming.hasOutstandingDemand = streaming.backPressureStrategy.didConsume(element: element)
                    
                    if streaming.hasOutstandingDemand {
                        let producers = Array(streaming.producerContinuations.map { $0.1 })
                        streaming.producerContinuations.removeAll()
                        self._state = .streaming(streaming)
                        return .returnElementAndResumeProducers(element, producers)
                    } else {
                        self._state = .streaming(streaming)
                        return .returnElement(element)
                    }
                } else {
                    self._state = .streaming(streaming)
                    
                    return .suspendTask
                }
                
            case .sourceFinished(var sourceFinished):
                self._state = .modify
                
                if let element = sourceFinished.buffer.popFirst() {
                    self._state = .sourceFinished(sourceFinished)
                    
                    return .returnElement(element)
                } else {
                    self._state = .finished(iteratorInitialized: sourceFinished.iteratorInitialized)
                    
                    return .returnErrorAndCallOnTermination(
                        sourceFinished.failure,
                        sourceFinished.onTermination
                    )
                }
                
            case .finished:
                return .returnNil
                
            case .modify:
                fatalError("AsyncStream internal inconsistency")
            }
        }
        
        @usableFromInline
        enum SuspendNextAction {
            case resumeConsumerWithElement(CheckedContinuation<Element?, any Error>, Element)
            case resumeConsumerWithElementAndProducers(
                CheckedContinuation<Element?, any Error>,
                Element,
                [(Result<Void, any Error>) -> Void]
            )
            case resumeConsumerWithErrorAndCallOnTermination(
                CheckedContinuation<Element?, any Error>,
                (any Error)?,
                (() -> Void)?
            )
            case resumeConsumerWithNil(CheckedContinuation<Element?, any Error>)
        }
        
        @inlinable
        mutating func suspendNext(
            continuation: CheckedContinuation<Element?, any Error>
        ) -> SuspendNextAction? {
            switch self._state {
            case .initial:
                preconditionFailure("AsyncStream internal inconsistency")
                
            case .streaming(var streaming):
                guard streaming.consumerContinuation == nil else {
                    fatalError(
                        "This should never happen since we only allow a single Iterator to be created"
                    )
                }
                
                self._state = .modify
                
                if let element = streaming.buffer.popFirst() {
                    
                    streaming.hasOutstandingDemand = streaming.backPressureStrategy.didConsume(element: element)
                    
                    if streaming.hasOutstandingDemand {
                        let producers = Array(streaming.producerContinuations.map { $0.1 })
                        streaming.producerContinuations.removeAll()
                        self._state = .streaming(streaming)
                        return .resumeConsumerWithElementAndProducers(
                            continuation,
                            element,
                            producers
                        )
                    } else {
                        self._state = .streaming(streaming)
                        return .resumeConsumerWithElement(continuation, element)
                    }
                } else {
                    streaming.consumerContinuation = continuation
                    self._state = .streaming(streaming)
                    
                    return .none
                }
                
            case .sourceFinished(var sourceFinished):
                self._state = .modify
                
                if let element = sourceFinished.buffer.popFirst() {
                    self._state = .sourceFinished(sourceFinished)
                    
                    return .resumeConsumerWithElement(continuation, element)
                } else {
                    self._state = .finished(iteratorInitialized: sourceFinished.iteratorInitialized)
                    
                    return .resumeConsumerWithErrorAndCallOnTermination(
                        continuation,
                        sourceFinished.failure,
                        sourceFinished.onTermination
                    )
                }
                
            case .finished:
                return .resumeConsumerWithNil(continuation)
                
            case .modify:
                fatalError("AsyncStream internal inconsistency")
            }
        }
        
        @usableFromInline
        enum CancelNextAction {
            case resumeConsumerWithCancellationErrorAndCallOnTermination(
                CheckedContinuation<Element?, any Error>,
                (() -> Void)?
            )
            case failProducersAndCallOnTermination([(Result<Void, any Error>) -> Void], (() -> Void)?)
        }
        
        @inlinable
        mutating func cancelNext() -> CancelNextAction? {
            switch self._state {
            case .initial:
                fatalError("AsyncStream internal inconsistency")
                
            case .streaming(let streaming):
                self._state = .finished(iteratorInitialized: streaming.iteratorInitialized)
                
                if let consumerContinuation = streaming.consumerContinuation {
                    precondition(
                        streaming.producerContinuations.isEmpty,
                        "Internal inconsistency. Unexpected producer continuations."
                    )
                    return .resumeConsumerWithCancellationErrorAndCallOnTermination(
                        consumerContinuation,
                        streaming.onTermination
                    )
                } else {
                    return .failProducersAndCallOnTermination(
                        Array(streaming.producerContinuations.map { $0.1 }),
                        streaming.onTermination
                    )
                }
                
            case .sourceFinished, .finished:
                return .none
                
            case .modify:
                fatalError("AsyncStream internal inconsistency")
            }
        }
    }
}
