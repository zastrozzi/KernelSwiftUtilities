//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/11/2023.
//

import Foundation

extension KernelSwiftCommon.Concurrency.Bytes {
    @usableFromInline
    internal struct CompatAsyncByteBuffer {
        struct Header {
            internal var readFunction: ((inout CompatAsyncByteBuffer) async throws -> Int)? = nil
            internal var finished = false
            
            init(_ readFunction: ((inout CompatAsyncByteBuffer) async throws -> Int)? = nil, finished: Bool = false) {
                self.readFunction = readFunction
                self.finished = finished
            }
        }
        
        class Storage : ManagedBuffer<Header, UInt8> {
            var finished: Bool {
                get { return header.finished }
                set { header.finished = newValue }
            }
        }
        
        var readFunction: (inout CompatAsyncByteBuffer) async throws -> Int {
            get { return (storage as! Storage).header.readFunction! }
            set { (storage as! Storage).header.readFunction = newValue }
        }
        
        var baseAddress: UnsafeMutableRawPointer {
            (storage as! Storage).withUnsafeMutablePointerToElements { UnsafeMutableRawPointer($0) }
        }
        
        var capacity: Int { (storage as! Storage).capacity }
        
        var storage: AnyObject? = nil
        
        @usableFromInline
        internal var nextPointer: UnsafeMutableRawPointer
        
        @usableFromInline
        internal var endPointer: UnsafeMutableRawPointer
        
        @usableFromInline 
        init(capacity: Int) {
            let s = Storage.create(minimumCapacity: capacity) { _ in .init(nil, finished: false) }
            storage = s
            nextPointer = s.withUnsafeMutablePointerToElements { UnsafeMutableRawPointer($0) }
            endPointer = nextPointer
        }
        
        @inline(never) @usableFromInline
        internal mutating func reloadBufferAndNext() async throws -> UInt8? {
            let storage = self.storage as! Storage
            if storage.finished { return nil }
            try Task.checkCancellation()
            nextPointer = storage.withUnsafeMutablePointerToElements { UnsafeMutableRawPointer($0) }
            do {
                let readSize = try await readFunction(&self)
                if readSize == 0 { storage.finished = true }
            } catch {
                storage.finished = true
                throw error
            }
            return try await next()
        }
        
        @inlinable @inline(__always)
        internal mutating func next() async throws -> UInt8? {
            if _fastPath(nextPointer != endPointer) {
                let byte = nextPointer.load(fromByteOffset: 0, as: UInt8.self)
                nextPointer = nextPointer + 1
                return byte
            }
            return try await reloadBufferAndNext()
        }
    }
}
