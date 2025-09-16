//
//  File.swift
//
//
//  Created by Jonathan Forbes on 31/05/2023.
//

import Foundation
import Vapor
import NIOCore
import Collections
import KernelSwiftCommon

public typealias OrderedByteDictionary = Collections.OrderedDictionary<Int, Deque<UInt8>>
public typealias OrderedStringDictionary = Collections.OrderedDictionary<KernelCSV.CSVColumnCodingKey, String>

public struct RequestBodyDecodableCSVByteLineAsyncSequence<DecodedCSVRow: KernelCSV.CSVCodable & Sendable>: AsyncSequence, Sendable {
    public typealias Element = DecodedCSVRow
    
    @usableFromInline
    let request: Request
    
    @usableFromInline
    let lowWatermark: Int
    
    @usableFromInline
    let highWatermark: Int
    
    @usableFromInline
    let lineSeparator: UInt8.UTF8Grapheme
    
    @usableFromInline
    let columnDelimiter: UInt8
    
    @usableFromInline
    let cellQualifier: UInt8
    
    @usableFromInline
    let resolvedCodingConfiguration: KernelCSV.CSVCodingConfiguration.ResolvedConfiguration<Element>
    
    public init(
        request: Request,
        lowWatermark: Int = 5,
        highWatermark: Int = 20,
        lineSeparator: UInt8.UTF8Grapheme = .twoByte(.carriageReturnLineFeed),
        columnDelimiter: UInt8.UTF8Grapheme = .oneByte(.ascii.comma),
        cellQualifier: UInt8.UTF8Grapheme = .oneByte(.ascii.doubleQuote),
        resolvedCodingConfiguration: KernelCSV.CSVCodingConfiguration.ResolvedConfiguration<Element>
    ) {
        self.request = request
        self.lowWatermark = lowWatermark
        self.highWatermark = highWatermark
        self.lineSeparator = lineSeparator
        
        guard case .oneByte(let columnDelimiterByte) = columnDelimiter, case .oneByte(let cellQualifierByte) = cellQualifier else {
            fatalError("Multi-byte graphemes currently not supported for columnDelimiters and cellQualifiers")
        }

        
        self.columnDelimiter = columnDelimiterByte
        self.cellQualifier = cellQualifierByte
        self.resolvedCodingConfiguration = resolvedCodingConfiguration
    }
    
    @inlinable
    public func makeAsyncIterator() -> RequestBodyDecodableCSVByteLineAsyncIterator<Element> {
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
        
        return RequestBodyDecodableCSVByteLineAsyncIterator(
            underlying: producer.sequence.makeAsyncIterator(),
            lineSeparator: lineSeparator,
            columnDelimiter: columnDelimiter,
            cellQualifier: cellQualifier,
            resolvedCodingConfiguration: resolvedCodingConfiguration
        )
    }
    
    
}

public struct RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow: KernelCSV.CSVCodable>: AsyncIteratorProtocol {
    public typealias Element = DecodedCSVRow
    public typealias Underlying = NIOThrowingAsyncSequenceProducer<ByteBuffer, any Error, NIOAsyncSequenceProducerBackPressureStrategies.HighLowWatermark, RequestBodyByteAsyncSequenceDelegate>.AsyncIterator
    
    @usableFromInline
    struct State: Sendable {
        @usableFromInline
        var workingLineBuffer: OrderedByteDictionary = [:]
        
        @usableFromInline
        var queuedLineBuffer: Deque<DecodedCSVRow> = []
        
        @usableFromInline
        var unpackedByteBuffer: Deque<UInt8> = []
        
        @usableFromInline
        var awaitingLastBufferCheck: Bool = true
        
        @usableFromInline
        var inferringColumnCountDone: Bool = false
        
        @usableFromInline
        var columnPosition: Int = 0
        
        @usableFromInline
        var minColumnCount: Int? = nil
        
        @usableFromInline
        var maxColumnCount: Int? = nil
        
        @usableFromInline
        var documentPosition: DocumentPosition = .header
        
        @usableFromInline
        var columnHeaders: Array<KernelCSV.CSVColumnCodingKey> = []
        
        @usableFromInline
        var inCellQualifier: Bool = false
        
        @usableFromInline
        var isFinalColumn: Bool {
            guard let maxColumnCount else { return false }
            guard (columnPosition + 1) == maxColumnCount else { return false }
            return true
        }
    }
    
    @usableFromInline
    var underlying: Underlying
    
    @usableFromInline
    let lineSeparator: UInt8.UTF8Grapheme
    
    @usableFromInline
    let columnDelimiter: UInt8
    
    @usableFromInline
    let cellQualifier: UInt8
    
    @usableFromInline
    var resolvedCodingConfiguration: KernelCSV.CSVCodingConfiguration.ResolvedConfiguration<DecodedCSVRow>
    
    @usableFromInline
    internal let state = KernelSwiftCommon.Concurrency.Core.ManagedCriticalState(State())
    
    @usableFromInline
    enum DocumentPosition: Sendable {
        case header
        case body
    }

    public init(
        underlying: Underlying,
        lineSeparator: UInt8.UTF8Grapheme,
        columnDelimiter: UInt8,
        cellQualifier: UInt8,
        resolvedCodingConfiguration: KernelCSV.CSVCodingConfiguration.ResolvedConfiguration<DecodedCSVRow>
    ) {
        self.underlying = underlying
        self.lineSeparator = lineSeparator
        self.columnDelimiter = columnDelimiter
        self.cellQualifier = cellQualifier
        self.resolvedCodingConfiguration = resolvedCodingConfiguration
    }

    @inlinable
    func unpackNextByteBuffer() async throws -> [UInt8]? {
        if var nextBuffer = try await self.underlying.next(), let nextBytes = nextBuffer.readBytes(length: nextBuffer.readableBytes), !nextBytes.isEmpty {
            return nextBytes
        }
        return nil
    }

    @inlinable
    mutating func decodeRow() {
        let workingLine = state.yieldNextWorkingLine()
        guard !state.documentPositionInHeader() else {
            state.setColumnHeaders(workingLine)
            return
        }
        if let decoded = try? resolvedCodingConfiguration.decodeRow(fromByteDict: workingLine) {
            state.appendDecodedQueue(decoded)
        }
        return
    }
        
    @inlinable
    mutating func handleUnpackedByteBuffer() {
        while let firstByte = state.nextByte() {
            if state.performCellQualifierOperation(byte: firstByte, cellQualifier: cellQualifier) { continue }
            if state.performColumnDelimiterOperation(byte: firstByte, columnDelimiter: columnDelimiter) { continue }
            switch lineSeparator {
            case .oneByte(let lineGrapheme):
                guard firstByte == lineGrapheme else {
                    state.appendWorkingLine([firstByte])
                    continue
                }
                
                decodeRow()
                state.performColumnEndOperation()
                continue
                
            case .twoByte(let lineGrapheme):
                guard firstByte == lineGrapheme.prefix else {
                    state.appendWorkingLine([firstByte])
                    continue
                }
                guard let suffix = state.nextByte() else {
                    state.prependByteBuffer([firstByte])
                    return
                }
                guard suffix == lineGrapheme.suffix else {
                    state.appendWorkingLine([firstByte, suffix])
                    continue
                }
                decodeRow()
                state.performColumnEndOperation()
                continue
                
            case .threeByte(let lineGrapheme):
                guard firstByte == lineGrapheme.prefix else {
                    state.appendWorkingLine([firstByte])
                    continue
                }
                guard let continuation = state.nextByte() else {
                    state.prependByteBuffer([firstByte])
                    return
                }
                guard continuation == lineGrapheme.continuation else {
                    state.appendWorkingLine([firstByte, continuation])
                    continue
                }
                guard let suffix = state.nextByte() else {
                    state.prependByteBuffer([firstByte, continuation])
                    return
                }
                guard suffix == lineGrapheme.suffix else {
                    state.appendWorkingLine([firstByte, continuation, suffix])
                    continue
                }
                decodeRow()
                state.performColumnEndOperation()
                continue
            case .fourByte(let lineGrapheme):
                guard firstByte == lineGrapheme.prefix else {
                    state.appendWorkingLine([firstByte])
                    continue
                }
                guard let continuation1 = state.nextByte() else {
                    state.prependByteBuffer([firstByte])
                    break
                }
                guard continuation1 == lineGrapheme.continuation1 else {
                    state.appendWorkingLine([firstByte, continuation1])
                    continue
                }
                
                guard let continuation2 = state.nextByte() else {
                    state.prependByteBuffer([firstByte, continuation1])
                    break
                }
                guard continuation2 == lineGrapheme.continuation2 else {
                    state.appendWorkingLine([firstByte, continuation1, continuation2])
                    continue
                }
                guard let suffix = state.nextByte() else {
                    state.prependByteBuffer([firstByte, continuation1, continuation2])
                    break
                }
                guard suffix == lineGrapheme.suffix else {
                    state.appendWorkingLine([firstByte, continuation1, continuation2, suffix])
                    continue
                }
                decodeRow()
                state.performColumnEndOperation()
                continue
            }
        }
    }
    
    @inlinable
    public mutating func next() async throws -> Element? {
        
        handleUnpackedByteBuffer()
        if let queuedLine = state.yieldNextQueuedLine() { return queuedLine }
        guard let nextBuffer = try await unpackNextByteBuffer() else {
            guard state.performLastBufferCheck(lineSeparator: lineSeparator) == true else { return nil }
            return try await self.next()
        }
        state.appendByteBuffer(nextBuffer)
        return try await self.next()
    }
}

extension KernelSwiftCommon.Concurrency.Core.ManagedCriticalState {
    @inlinable
    func yieldNextWorkingLine<DecodedCSVRow: KernelCSV.CSVCodable>() -> OrderedByteDictionary where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            defer { managedState.workingLineBuffer.removeAll(keepingCapacity: true) }
            return managedState.workingLineBuffer
        }
    }
    
    @inlinable
    func yieldNextQueuedLine<DecodedCSVRow: KernelCSV.CSVCodable>() -> DecodedCSVRow? where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            if managedState.queuedLineBuffer.isEmpty { return nil } else {
                return managedState.queuedLineBuffer.popFirst()
            }
        }
        
    }
    
    @inlinable
    func nextByte<DecodedCSVRow: KernelCSV.CSVCodable>() -> UInt8? where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            if managedState.unpackedByteBuffer.isEmpty { return nil } else {
                return managedState.unpackedByteBuffer.popFirst()
            }
        }
    }
    
    @inlinable
    func iterateColumn<DecodedCSVRow: KernelCSV.CSVCodable>() where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            guard (managedState.maxColumnCount ?? .max) > managedState.columnPosition + 1 else {
                managedState.columnPosition = 0
                return
            }
            managedState.columnPosition += 1
        }
    }
    
    @inlinable
    func inferColumnCount<DecodedCSVRow: KernelCSV.CSVCodable>(min: Int? = nil, max: Int? = nil) where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            if let min { managedState.minColumnCount = min }
            if let max { managedState.maxColumnCount = max }
            if let minColumnCount = managedState.minColumnCount, let maxColumnCount = managedState.maxColumnCount {
                managedState.inferringColumnCountDone = minColumnCount == maxColumnCount
            }
        }
    }
    
    @inlinable
    func setColumnHeaders<DecodedCSVRow: KernelCSV.CSVCodable>(_ workingLine: OrderedByteDictionary) where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            managedState.columnHeaders = workingLine
                .map {
                    .init(name: String(utf8EncodedBytes: $0.value).trimmingCharacters(in: .whitespacesAndNewlines), position: $0.key)
                }
            managedState.documentPosition = .body
        }
        
    }
    
    @inlinable
    func performCellQualifierOperation<DecodedCSVRow: KernelCSV.CSVCodable>(byte: UInt8, cellQualifier: UInt8) -> Bool where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            if byte == cellQualifier {
                guard !managedState.inCellQualifier else {
                    managedState.inCellQualifier.toggle()
                    return true
                }
                guard !managedState.workingLineBuffer[managedState.columnPosition, default: []].isEmpty else {
                    managedState.inCellQualifier.toggle()
                    return true
                }
            }
            
            guard !managedState.inCellQualifier else {
                managedState.workingLineBuffer[managedState.columnPosition, default: []].append(contentsOf: [byte])
                return true
            }
            return false
        }
    }
    
    @inlinable
    func performColumnDelimiterOperation<DecodedCSVRow: KernelCSV.CSVCodable>(byte: UInt8, columnDelimiter: UInt8) -> Bool where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        let result = self.withCriticalRegion { managedState in
            if !managedState.isFinalColumn && byte == columnDelimiter {
                
                return true
            }
            return false
        }
        if result == true { iterateColumn() }
        return result
    }
    
    @inlinable
    func performColumnEndOperation<DecodedCSVRow: KernelCSV.CSVCodable>() where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            if !managedState.inferringColumnCountDone {
                managedState.minColumnCount = managedState.columnPosition + 1
                managedState.maxColumnCount = managedState.columnPosition + 1
                managedState.inferringColumnCountDone = true
            }
            guard (managedState.maxColumnCount ?? .max) > managedState.columnPosition + 1 else {
                managedState.columnPosition = 0
                return
            }
            managedState.columnPosition += 1
        }
    }
    
    @inlinable
    func appendWorkingLine<DecodedCSVRow: KernelCSV.CSVCodable>(_ bytes: [UInt8]) where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            managedState.workingLineBuffer[managedState.columnPosition, default: []].append(contentsOf: bytes)
        }
    }
    
    @inlinable
    func prependByteBuffer<DecodedCSVRow: KernelCSV.CSVCodable>(_ bytes: [UInt8]) where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            managedState.unpackedByteBuffer.prepend(contentsOf: bytes)
        }
    }
    
    @inlinable
    func appendByteBuffer<DecodedCSVRow: KernelCSV.CSVCodable>(_ bytes: [UInt8]) where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            managedState.unpackedByteBuffer.append(contentsOf: bytes)
        }
    }
    
    @inlinable
    func appendDecodedQueue<DecodedCSVRow: KernelCSV.CSVCodable>(_ decoded: DecodedCSVRow) where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            managedState.queuedLineBuffer.append(decoded)
        }
    }
    
    @inlinable
    func performLastBufferCheck<DecodedCSVRow: KernelCSV.CSVCodable>(lineSeparator: UInt8.UTF8Grapheme) -> Bool where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        return self.withCriticalRegion { managedState in
            guard managedState.awaitingLastBufferCheck == true else { return false }
            managedState.awaitingLastBufferCheck = false
            let lastBufferSuffix = managedState.unpackedByteBuffer.suffix(lineSeparator.byteLength)
            switch lineSeparator {
            case .oneByte(let grapheme):
                guard let finalGrapheme = lastBufferSuffix.first, finalGrapheme == grapheme else {
                    managedState.unpackedByteBuffer.append(grapheme)
                    break
                }
            case .twoByte(let grapheme):
                guard let finalGraphemePrefix = lastBufferSuffix.first, finalGraphemePrefix == grapheme.prefix else {
                    managedState.unpackedByteBuffer.append(grapheme.prefix)
                    guard lastBufferSuffix.count >= lineSeparator.byteLength, lastBufferSuffix[1] == grapheme.suffix else {
                        managedState.unpackedByteBuffer.append(grapheme.suffix)
                        break
                    }
                    break
                }
                
            case .threeByte(let grapheme):
                guard let finalGraphemePrefix = lastBufferSuffix.first, finalGraphemePrefix == grapheme.prefix else {
                    managedState.unpackedByteBuffer.append(grapheme.prefix)
                    guard lastBufferSuffix.count >= lineSeparator.byteLength - 1, lastBufferSuffix[1] == grapheme.continuation else {
                        managedState.unpackedByteBuffer.append(grapheme.continuation)
                        guard lastBufferSuffix.count >= lineSeparator.byteLength, lastBufferSuffix[2] == grapheme.suffix else {
                            managedState.unpackedByteBuffer.append(grapheme.suffix)
                            break
                        }
                        break
                    }
                    break
                }
                
            case .fourByte(let grapheme):
                guard let finalGraphemePrefix = lastBufferSuffix.first, finalGraphemePrefix == grapheme.prefix else {
                    managedState.unpackedByteBuffer.append(grapheme.prefix)
                    guard lastBufferSuffix.count >= lineSeparator.byteLength - 2, lastBufferSuffix[1] == grapheme.continuation1 else {
                        managedState.unpackedByteBuffer.append(grapheme.continuation1)
                        guard lastBufferSuffix.count >= lineSeparator.byteLength - 1, lastBufferSuffix[2] == grapheme.continuation2 else {
                            managedState.unpackedByteBuffer.append(grapheme.continuation2)
                            guard lastBufferSuffix.count >= lineSeparator.byteLength, lastBufferSuffix[3] == grapheme.suffix else {
                                managedState.unpackedByteBuffer.append(grapheme.suffix)
                                break
                            }
                            break
                        }
                        break
                    }
                    break
                }
            }
            return true
        }
    }
    
    @inlinable
    func documentPositionInHeader<DecodedCSVRow: KernelCSV.CSVCodable>() -> Bool where State == RequestBodyDecodableCSVByteLineAsyncIterator<DecodedCSVRow>.State {
        self.withCriticalRegion { managedState in
            return managedState.documentPosition == .header
        }
    }
}
