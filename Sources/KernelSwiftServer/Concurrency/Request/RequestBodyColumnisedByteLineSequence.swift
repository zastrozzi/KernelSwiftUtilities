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

public struct RequestBodyColumnisedByteLineAsyncSequence: AsyncSequence, Sendable {
    public typealias Element = [Int:[UInt8]]
    
    let request: Request
    let lowWatermark: Int
    let highWatermark: Int
    let lineSeparator: UInt8.UTF8Grapheme
    let columnDelimiter: UInt8.UTF8Grapheme
    
    public init(
        request: Request,
        lowWatermark: Int = 5,
        highWatermark: Int = 20,
        lineSeparator: UInt8.UTF8Grapheme = .twoByte(.carriageReturnLineFeed),
        columnDelimiter: UInt8.UTF8Grapheme = .oneByte(.ascii.comma)
    ) {
        self.request = request
        self.lowWatermark = lowWatermark
        self.highWatermark = highWatermark
        self.lineSeparator = lineSeparator
        self.columnDelimiter = columnDelimiter
    }
    
    public func makeAsyncIterator() -> RequestBodyColumnisedByteLineAsyncIterator {
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
        
        return RequestBodyColumnisedByteLineAsyncIterator(
            underlying: producer.sequence.makeAsyncIterator(),
            lineSeparator: lineSeparator,
            columnDelimiter: columnDelimiter
        )
    }
    
    
}

public struct RequestBodyColumnisedByteLineAsyncIterator: AsyncIteratorProtocol {
    public typealias Element = [Int:[UInt8]]
    public typealias Underlying = NIOThrowingAsyncSequenceProducer<ByteBuffer, any Error, NIOAsyncSequenceProducerBackPressureStrategies.HighLowWatermark, RequestBodyByteAsyncSequenceDelegate>.AsyncIterator
    
    private var underlying: Underlying
    let lineSeparator: UInt8.UTF8Grapheme
    let columnDelimiter: UInt8.UTF8Grapheme
    var workingLineBuffer: Dictionary<Int, Array<UInt8>> = [:]
    var queuedLineBuffer: Array<Dictionary<Int, Array<UInt8>>> = []
    var unpackedByteBuffer: Array<UInt8> = []
    var awaitingLastBufferCheck: Bool = true
    var inferringColumnCountDone: Bool
    var columnPosition: Int = 0
    var minColumnCount: Int? = nil
    var maxColumnCount: Int? = nil
    
    var isFinalColumn: Bool {
        guard let maxColumnCount else { return false }
        guard (columnPosition + 1) == maxColumnCount else { return false }
        return true
    }
    
    public init(
        underlying: Underlying,
        lineSeparator: UInt8.UTF8Grapheme,
        columnDelimiter: UInt8.UTF8Grapheme,
        exactColumnCount: Int? = nil
    ) {
        self.underlying = underlying
        self.lineSeparator = lineSeparator
        self.columnDelimiter = columnDelimiter
        if let exactColumnCount {
            self.minColumnCount = exactColumnCount
            self.maxColumnCount = exactColumnCount
            self.inferringColumnCountDone = true
        } else {
            self.inferringColumnCountDone = false
        }
    }
    
    mutating func yieldNextWorkingLine() -> Dictionary<Int, Array<UInt8>>? {
        
        if workingLineBuffer.isEmpty { return nil } else {
            let workingLine = workingLineBuffer
            workingLineBuffer = [:]
            return workingLine
        }
        
    }
    
    mutating func yieldNextQueuedLine() -> Dictionary<Int, Array<UInt8>>? {
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
    
    mutating func iterateColumn() {
        guard (maxColumnCount ?? .max) > columnPosition + 1 else {
            columnPosition = 0
            return
        }
        columnPosition += 1
    }
    
    mutating func inferColumnCount(min: Int? = nil, max: Int? = nil) {
        if let min { minColumnCount = min }
        if let max { maxColumnCount = max }
        if let minColumnCount, let maxColumnCount {
            inferringColumnCountDone = minColumnCount == maxColumnCount
        }
    }
    
    mutating func handleUnpackedByteBuffer() {
        while let firstByte = nextByte() {
            if !isFinalColumn && firstByte == .ascii.comma {
                iterateColumn()
                continue
            }
            switch lineSeparator {
            case .oneByte(let lineGrapheme):
                
                guard firstByte == lineGrapheme else {
                    workingLineBuffer[columnPosition, default: []].append(contentsOf: [firstByte])
                    continue
                }
                if let completedWorkingLine = yieldNextWorkingLine() {
                    queuedLineBuffer.append(completedWorkingLine)
                    if !inferringColumnCountDone { inferColumnCount(min: columnPosition + 1, max: columnPosition + 1) }
                    iterateColumn()
                }
                continue
                
            case .twoByte(let lineGrapheme):
                guard firstByte == lineGrapheme.prefix else {
                    workingLineBuffer[columnPosition, default: []].append(contentsOf: [firstByte])
                    continue
                }
                guard let suffix = nextByte() else {
                    unpackedByteBuffer.insert(contentsOf: [firstByte], at: 0)
                    return
                }
                guard suffix == lineGrapheme.suffix else {
                    workingLineBuffer[columnPosition, default: []].append(contentsOf: [firstByte, suffix])
                    continue
                }
                if let completedWorkingLine = yieldNextWorkingLine() {
                    queuedLineBuffer.append(completedWorkingLine)
                    if !inferringColumnCountDone { inferColumnCount(min: columnPosition + 1, max: columnPosition + 1) }
                    iterateColumn()
                }
                continue

            case .threeByte(let lineGrapheme):
                guard firstByte == lineGrapheme.prefix else {
                    workingLineBuffer[columnPosition, default: []].append(contentsOf: [firstByte])
                    continue
                }
                guard let continuation = nextByte() else {
                    unpackedByteBuffer.insert(firstByte, at: 0)
                    return
                }
                guard continuation == lineGrapheme.continuation else {
                    workingLineBuffer[columnPosition, default: []].append(contentsOf: [firstByte, continuation])
                    continue
                }
                guard let suffix = nextByte() else {
                    unpackedByteBuffer.insert(contentsOf: [firstByte, continuation], at: 0)
                    return
                }
                guard suffix == lineGrapheme.suffix else {
                    workingLineBuffer[columnPosition, default: []].append(contentsOf: [firstByte, continuation, suffix])
                    continue
                }
                if let completedWorkingLine = yieldNextWorkingLine() {
                    queuedLineBuffer.append(completedWorkingLine)
                    if !inferringColumnCountDone { inferColumnCount(min: columnPosition + 1, max: columnPosition + 1) }
                    iterateColumn()
                }
                continue
                
            case .fourByte(let lineGrapheme):
                guard firstByte == lineGrapheme.prefix else {
                    workingLineBuffer[columnPosition, default: []].append(contentsOf: [firstByte])
                    continue
                }
                guard let continuation1 = nextByte() else {
                    unpackedByteBuffer.insert(contentsOf: [firstByte], at: 0)
                    return
                }
                guard continuation1 == lineGrapheme.continuation1 else {
                    workingLineBuffer[columnPosition, default: []].append(contentsOf: [firstByte, continuation1])
                    continue
                }
                
                guard let continuation2 = nextByte() else {
                    unpackedByteBuffer.insert(contentsOf: [firstByte, continuation1], at: 0)
                    return
                }
                guard continuation2 == lineGrapheme.continuation2 else {
                    workingLineBuffer[columnPosition, default: []].append(contentsOf: [firstByte, continuation1, continuation2])
                    continue
                }
                guard let suffix = nextByte() else {
                    unpackedByteBuffer.insert(contentsOf: [firstByte, continuation1, continuation2], at: 0)
                    return
                }
                guard suffix == lineGrapheme.suffix else {
                    workingLineBuffer[columnPosition, default: []].append(contentsOf: [firstByte, continuation1, continuation2, suffix])
                    continue
                }
                if let completedWorkingLine = yieldNextWorkingLine() {
                    queuedLineBuffer.append(completedWorkingLine)
                    if !inferringColumnCountDone { inferColumnCount(min: columnPosition + 1, max: columnPosition + 1) }
                    iterateColumn()
                }
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
    
    public mutating func next() async throws -> Dictionary<Int, Array<UInt8>>? {
        
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
