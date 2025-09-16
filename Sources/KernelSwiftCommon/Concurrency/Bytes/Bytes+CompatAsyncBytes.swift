//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/11/2023.
//

import Foundation
import AsyncAlgorithms

extension KernelSwiftCommon.Concurrency.Bytes {
    public struct CompatAsyncBytes: AsyncSequence, Sendable {
        public typealias Element = UInt8
        public typealias AsyncIterator = Iterator
        var handle: FileHandle
        
        internal init(file: FileHandle) {
            handle = file
        }
        
        public func makeAsyncIterator() -> Iterator { .init(file: handle) }
        
        public struct Iterator: AsyncIteratorProtocol {
            public typealias Element = UInt8
            
            @inline(__always) 
            static var bufferSize: Int { 16384 }
            
//            @usableFromInline 
            var buffer: CompatAsyncByteBuffer
            
            internal var byteBuffer: CompatAsyncByteBuffer { buffer }
            
            internal init(file: FileHandle) {
                buffer = CompatAsyncByteBuffer(capacity: Iterator.bufferSize)
                let fd = file.fileDescriptor
                buffer.readFunction = { (buf) in
                    buf.nextPointer = buf.baseAddress
                    let capacity = buf.capacity
                    let bufPtr = UnsafeMutableRawBufferPointer(start: buf.nextPointer, count: capacity)
                    let readSize: Int
                    if fd >= 0 { readSize = try await CompatIOActor.default.read(from: fd, into: bufPtr) }
                    else { readSize = try await CompatIOActor.default.read(from: file, into: bufPtr) }
                    buf.endPointer = buf.nextPointer + readSize
                    return readSize
                }
            }
            
            
            public mutating func next() async throws -> UInt8? { try await buffer.next() }
        }
    }
}

extension FileHandle {
    public var compatBytes: KernelSwiftCommon.Concurrency.Bytes.CompatAsyncBytes { .init(file: self) }
}
