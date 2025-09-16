//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/05/2023.
//

import Foundation
import Vapor
import NIOCore
import KernelSwiftCommon


public struct RequestBodyByteLineAsyncSequence: AsyncSequence, Sendable {
    public typealias Element = [UInt8]
    
    let request: Request
    let lowWatermark: Int
    let highWatermark: Int
    let lineSeparator: UInt8.UTF8Grapheme
    
    public init(
        request: Request,
        lowWatermark: Int = 5,
        highWatermark: Int = 20,
        lineSeparator: UInt8.UTF8Grapheme = .twoByte(.carriageReturnLineFeed)
    ) {
        self.request = request
        self.lowWatermark = lowWatermark
        self.highWatermark = highWatermark
        self.lineSeparator = lineSeparator
    }
    
    public func makeAsyncIterator() -> RequestBodyByteLineAsyncIterator {
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
            case .buffer(let byteBuffer):
                let result = source.yield(byteBuffer)
                switch result {
                
                case .stopProducing:
                    let asyncPromise = AsyncPromise(Bool.self)
                    delegate.registerBackpressurePromise(asyncPromise)
                    return asyncPromise.voidFuture(for: request.eventLoop)
                case .dropped:
                    return request.eventLoop.makeSucceededVoidFuture()
                case .produceMore: return request.eventLoop.makeSucceededVoidFuture()
                }
            case .error(let error):
                source.finish(error)
                return request.eventLoop.makeSucceededVoidFuture()
            case .end:
                source.finish()
                return request.eventLoop.makeSucceededVoidFuture()
            
            }
        }
        
        return RequestBodyByteLineAsyncIterator(
            underlying: producer.sequence.makeAsyncIterator(),
            lineSeparator: lineSeparator
        )
    }
    
    
}

public struct RequestBodyByteLineAsyncIterator: AsyncIteratorProtocol {
    public typealias Element = [UInt8]
    public typealias Underlying = NIOThrowingAsyncSequenceProducer<ByteBuffer, any Error, NIOAsyncSequenceProducerBackPressureStrategies.HighLowWatermark, RequestBodyByteAsyncSequenceDelegate>.AsyncIterator
    
    private var underlying: Underlying
    let lineSeparator: UInt8.UTF8Grapheme
    var workingLineBuffer: Array<UInt8> = []
    var queuedLineBuffer: Array<Array<UInt8>> = []
    var unpackedByteBuffer: Array<UInt8> = []
    var leftover: UInt8? = nil
    var awaitingLastBufferCheck: Bool = true
    
    public init(
        underlying: Underlying,
        lineSeparator: UInt8.UTF8Grapheme
    ) {
        self.underlying = underlying
        self.lineSeparator = lineSeparator
    }
    
    mutating func yieldNextWorkingLine() -> [UInt8]? {
        
        if workingLineBuffer.isEmpty { return nil } else {
            let workingLine = workingLineBuffer
            workingLineBuffer = []
            return workingLine
        }
        
    }
    
    mutating func yieldNextQueuedLine() -> [UInt8]? {
        return queuedLineBuffer.isEmpty ? nil : queuedLineBuffer.removeFirst()
    }
    
    func unpackNextByteBuffer() async throws -> [UInt8]? {
        if var nextBuffer = try await self.underlying.next(), let nextBytes = nextBuffer.readBytes(length: nextBuffer.readableBytes), !nextBytes.isEmpty {
            return nextBytes
        }
        return nil
    }
    
    mutating func nextByte() -> UInt8? {
        guard unpackedByteBuffer.isEmpty else { return unpackedByteBuffer.removeFirst() }
        return nil
    }
    
    mutating func handleUnpackedByteBuffer() {
        while let firstByte = nextByte() {
            switch lineSeparator {
            case .oneByte(let grapheme):
                guard firstByte == grapheme else {
                    workingLineBuffer.append(firstByte)
                    continue
                }
                if let completedWorkingLine = yieldNextWorkingLine() { queuedLineBuffer.append(completedWorkingLine) }
                continue
                
            case .twoByte(let grapheme):
                guard firstByte == grapheme.prefix else {
                    workingLineBuffer.append(firstByte)
                    continue
                }
                guard let suffix = nextByte() else {
                    unpackedByteBuffer.insert(firstByte, at: 0)
                    return
                }
                guard suffix == grapheme.suffix else {
                    workingLineBuffer.append(firstByte)
                    workingLineBuffer.append(suffix)
                    continue
                }
                if let completedWorkingLine = yieldNextWorkingLine() { queuedLineBuffer.append(completedWorkingLine) }
                continue

            case .threeByte(let grapheme):
                guard firstByte == grapheme.prefix else {
                    workingLineBuffer.append(firstByte)
                    continue
                }
                guard let continuation = nextByte() else {
                    unpackedByteBuffer.insert(firstByte, at: 0)
                    return
                }
                guard continuation == grapheme.continuation else {
                    workingLineBuffer.append(firstByte)
                    workingLineBuffer.append(continuation)
                    continue
                }
                guard let suffix = nextByte() else {
                    unpackedByteBuffer.insert(firstByte, at: 0)
                    unpackedByteBuffer.insert(continuation, at: 1)
                    return
                }
                guard suffix == grapheme.suffix else {
                    workingLineBuffer.append(firstByte)
                    workingLineBuffer.append(continuation)
                    workingLineBuffer.append(suffix)
                    continue
                }
                if let completedWorkingLine = yieldNextWorkingLine() { queuedLineBuffer.append(completedWorkingLine) }
                continue
                
            case .fourByte(let grapheme):
                guard firstByte == grapheme.prefix else {
                    workingLineBuffer.append(firstByte)
                    continue
                }
                guard let continuation1 = nextByte() else {
                    unpackedByteBuffer.insert(firstByte, at: 0)
                    return
                }
                guard continuation1 == grapheme.continuation1 else {
                    workingLineBuffer.append(firstByte)
                    workingLineBuffer.append(continuation1)
                    continue
                }
                
                guard let continuation2 = nextByte() else {
                    unpackedByteBuffer.insert(firstByte, at: 0)
                    unpackedByteBuffer.insert(continuation1, at: 1)
                    return
                }
                guard continuation2 == grapheme.continuation2 else {
                    workingLineBuffer.append(firstByte)
                    workingLineBuffer.append(continuation1)
                    workingLineBuffer.append(continuation2)
                    continue
                }
                guard let suffix = nextByte() else {
                    unpackedByteBuffer.insert(firstByte, at: 0)
                    unpackedByteBuffer.insert(continuation1, at: 1)
                    unpackedByteBuffer.insert(continuation2, at: 2)
                    return
                }
                guard suffix == grapheme.suffix else {
                    workingLineBuffer.append(firstByte)
                    workingLineBuffer.append(continuation1)
                    workingLineBuffer.append(continuation2)
                    workingLineBuffer.append(suffix)
                    continue
                }
                if let completedWorkingLine = yieldNextWorkingLine() { queuedLineBuffer.append(completedWorkingLine) }
                continue
            }
        }
    }
    
    mutating func performLastBufferCheck() {
        awaitingLastBufferCheck = false
        let lastBufferSuffix = unpackedByteBuffer.suffix(lineSeparator.byteLength)
        switch lineSeparator {
        case .oneByte(let grapheme):
            guard let finalGrapheme = lastBufferSuffix.first, finalGrapheme == grapheme else {
                unpackedByteBuffer.append(grapheme)
                break
            }
        case .twoByte(let grapheme):
            guard let finalGraphemePrefix = lastBufferSuffix.first, finalGraphemePrefix == grapheme.prefix else {
                unpackedByteBuffer.append(grapheme.prefix)
                guard lastBufferSuffix.count >= lineSeparator.byteLength, lastBufferSuffix[1] == grapheme.suffix else {
                    unpackedByteBuffer.append(grapheme.suffix)
                    break
                }
                break
            }
            
        case .threeByte(let grapheme):
            guard let finalGraphemePrefix = lastBufferSuffix.first, finalGraphemePrefix == grapheme.prefix else {
                unpackedByteBuffer.append(grapheme.prefix)
                guard lastBufferSuffix.count >= lineSeparator.byteLength - 1, lastBufferSuffix[1] == grapheme.continuation else {
                    unpackedByteBuffer.append(grapheme.continuation)
                    guard lastBufferSuffix.count >= lineSeparator.byteLength, lastBufferSuffix[2] == grapheme.suffix else {
                        unpackedByteBuffer.append(grapheme.suffix)
                        break
                    }
                    break
                }
                break
            }
            
        case .fourByte(let grapheme):
            guard let finalGraphemePrefix = lastBufferSuffix.first, finalGraphemePrefix == grapheme.prefix else {
                unpackedByteBuffer.append(grapheme.prefix)
                guard lastBufferSuffix.count >= lineSeparator.byteLength - 2, lastBufferSuffix[1] == grapheme.continuation1 else {
                    unpackedByteBuffer.append(grapheme.continuation1)
                    guard lastBufferSuffix.count >= lineSeparator.byteLength - 1, lastBufferSuffix[2] == grapheme.continuation2 else {
                        unpackedByteBuffer.append(grapheme.continuation2)
                        guard lastBufferSuffix.count >= lineSeparator.byteLength, lastBufferSuffix[3] == grapheme.suffix else {
                            unpackedByteBuffer.append(grapheme.suffix)
                            break
                        }
                        break
                    }
                    break
                }
                break
            }
        }
    }
    
    public mutating func next() async throws -> [UInt8]? {
        
        handleUnpackedByteBuffer()
        if let queuedLine = yieldNextQueuedLine() { return queuedLine }
        guard let nextBuffer = try await unpackNextByteBuffer() else {
            guard awaitingLastBufferCheck == true else { return nil }
            performLastBufferCheck()
            return try await self.next()
        }
        unpackedByteBuffer.append(contentsOf: nextBuffer)
        return try await self.next()
    }
}
