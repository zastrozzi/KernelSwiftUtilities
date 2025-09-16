//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/05/2023.
//

//import Foundation
import Vapor
import AsyncAlgorithms
import KernelSwiftCommon

public struct AsyncRequestBodyBytes: AsyncSequence {
    public typealias Element = UInt8
    let request: Request
//    var iterator: Request.Body.AsyncIterator
    var readRounds: Int = 0
    
    public struct AsyncIterator: AsyncIteratorProtocol {
//        let request: AsyncBufferSequence<Request.Body>
    //    var bufferSeq: AsyncBufferSequence<Request.Body>
        var iterator: Request.Body.AsyncIterator
        var bufferIterator: AsyncBufferedByteIterator
        
        var currentBuffer: ByteBuffer? = nil
        
        public init(request: Request.Body) {
//            self.request = request.buffer(policy: .unbounded)
            self.iterator = request.makeAsyncIterator()
            @Sendable func unwrapBytesFromBuffer(_ buff: inout ByteBuffer) throws -> [UInt8]? {
                return buff.readBytes(length: buff.readableBytes)
            }
            
            
            
            
            self.bufferIterator = AsyncBufferedByteIterator(capacity: 16384) { buffer in
                
//                guard var accbuffer = try await self.iterator.next() else { return nil }
//                guard var accBuffer = try await iterator.next() else { return 0 }
//                guard let bytes = try unwrapBytesFromBuffer(&accBuffer) else { return 0 }
//                buffer.copyBytes(from: bytes)
//                return bytes.count
                return 0
 //               return try! await iter.next()?.readableBytesView.copyBytes(to: buffer) ?? 0
            }
    //        bufferSeq = request.buffer(policy: .unbounded)
        }
        
        public mutating func next() async throws -> Element? {
            guard currentBuffer != nil || currentBuffer!.readableBytes > 0 else {
                currentBuffer = try await iterator.next()
                return currentBuffer?.readableBytesView.first
            }
//            currentBuffer?.discardReadBytes()
            currentBuffer?.moveReaderIndex(forwardBy: 1)
            return currentBuffer?.readableBytesView.first
            
//            return 0
        }
    }

    public init(_ request: Request) {
        self.request = request
//        self.iterator = request.body.makeAsyncIterator()
    }

    public func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(request: self.request.body)
    
//           var requestBufferIterator =

    }
}

public struct AsyncByteLineSequence<Base: AsyncSequence>: AsyncSequence where Base.Element == UInt8 {
    public typealias Element = [UInt8]

    var base: Base
    let lineSeparator: UInt8.UTF8Grapheme

    public init(underlyingSequence: Base, lineSeparator: UInt8.UTF8Grapheme) {
        self.base = underlyingSequence
        self.lineSeparator = lineSeparator
    }
    
    public func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(underlyingIterator: base.makeAsyncIterator(), lineSeparator: lineSeparator)
    }
    
    public struct AsyncIterator: AsyncIteratorProtocol {
        public typealias Element = [UInt8]
        
        var byteSource: Base.AsyncIterator
        let lineSeparator: UInt8.UTF8Grapheme
        var buffer: Array<UInt8> = []
        var leftover: UInt8? = nil
        
        public init(underlyingIterator: Base.AsyncIterator, lineSeparator: UInt8.UTF8Grapheme) {
            self.byteSource = underlyingIterator
            self.lineSeparator = lineSeparator
        }
        
        public mutating func next() async rethrows -> [UInt8]? {
            func yield() -> [UInt8]? {
                defer { buffer.removeAll(keepingCapacity: true) }
                if buffer.isEmpty { return nil }
                return buffer
            }
            
            func nextByte() async throws -> UInt8? {
                defer { leftover = nil }
                if let leftover { return leftover }
                return try await byteSource.next()
            }
            
            while let first = try await nextByte() {
                switch lineSeparator {
                case .oneByte(let grapheme):
                    guard first == grapheme else {
                        buffer.append(first)
                        continue
                    }
                    if let result = yield() { return result }
                    continue
                    
                case .twoByte(let grapheme):
                    guard first == grapheme.prefix else {
                        buffer.append(first)
                        continue
                    }
                    guard let suffix = try await byteSource.next() else {
                        buffer.append(first)
                        return yield()
                    }
                    guard suffix == grapheme.suffix else {
                        buffer.append(first)
                        buffer.append(suffix)
                        continue
                    }
                    if let result = yield() { return result }
                    continue

                case .threeByte(let grapheme):
                    guard first == grapheme.prefix else {
                        buffer.append(first)
                        continue
                    }
                    guard let continuation = try await byteSource.next() else {
                        buffer.append(first)
                        return yield()
                    }
                    guard continuation == grapheme.continuation else {
                        buffer.append(first)
                        buffer.append(continuation)
                        continue
                    }
                    guard let suffix = try await byteSource.next() else {
                        buffer.append(first)
                        buffer.append(continuation)
                        return yield()
                    }
                    guard suffix == grapheme.suffix else {
                        buffer.append(first)
                        buffer.append(continuation)
                        buffer.append(suffix)
                        continue
                    }
                    if let result = yield() { return result }
                    continue
                    
                case .fourByte(let grapheme):
                    guard first == grapheme.prefix else {
                        buffer.append(first)
                        continue
                    }
                    guard let continuation1 = try await byteSource.next() else {
                        buffer.append(first)
                        return yield()
                    }
                    guard continuation1 == grapheme.continuation1 else {
                        buffer.append(first)
                        buffer.append(continuation1)
                        continue
                    }
                    
                    guard let continuation2 = try await byteSource.next() else {
                        buffer.append(first)
                        buffer.append(continuation1)
                        return yield()
                    }
                    guard continuation2 == grapheme.continuation2 else {
                        buffer.append(first)
                        buffer.append(continuation1)
                        buffer.append(continuation2)
                        continue
                    }
                    guard let suffix = try await byteSource.next() else {
                        buffer.append(first)
                        buffer.append(continuation1)
                        buffer.append(continuation2)
                        return yield()
                    }
                    guard suffix == grapheme.suffix else {
                        buffer.append(first)
                        buffer.append(continuation1)
                        buffer.append(continuation2)
                        buffer.append(suffix)
                        continue
                    }
                    if let result = yield() { return result }
                    continue
                }
            }
            
            if !buffer.isEmpty { return yield() }
            return nil
        }
    }
}
