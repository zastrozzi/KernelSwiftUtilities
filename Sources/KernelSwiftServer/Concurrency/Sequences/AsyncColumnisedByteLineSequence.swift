//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/05/2023.
//

import Foundation
import AsyncAlgorithms
import KernelSwiftCommon

public struct AsyncColumnisedByteLineSequence<Base: AsyncSequence>: AsyncSequence where Base.Element == UInt8 {
    public typealias Element = [Int: [UInt8]]

    var base: Base
    let lineSeparator: UInt8.UTF8Grapheme
    let columnSeparator: UInt8.UTF8Grapheme
    let columnCount: Int

    public init(
        underlyingSequence: Base,
        lineSeparator: UInt8.UTF8Grapheme,
        columnSeparator: UInt8.UTF8Grapheme,
        columnCount: Int
    ) {
        self.base = underlyingSequence
        self.lineSeparator = lineSeparator
        self.columnSeparator = columnSeparator
        self.columnCount = columnCount
    }
    
    public func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(underlyingIterator: base.makeAsyncIterator(), lineSeparator: lineSeparator, columnSeparator: columnSeparator, columnCount: columnCount)
    }
    
    public struct AsyncIterator: AsyncIteratorProtocol {
        public typealias Element = [Int: [UInt8]]
        
        var byteSource: Base.AsyncIterator
        let lineSeparator: UInt8.UTF8Grapheme
        let columnSeparator: UInt8.UTF8Grapheme
        let columnCount: Int
        var buffer: [Int: [UInt8]] = [:]
        var columnPosition: Int = 0
//        var leftover: UInt8? = nil
        
        public init(
            underlyingIterator: Base.AsyncIterator,
            lineSeparator: UInt8.UTF8Grapheme,
            columnSeparator: UInt8.UTF8Grapheme,
            columnCount: Int
        ) {
            self.byteSource = underlyingIterator
            self.lineSeparator = lineSeparator
            self.columnSeparator = columnSeparator
            self.columnCount = columnCount
            self.resetBuffer()
        }
        
        private mutating func resetBuffer() {
            for i in 0..<columnCount {
                buffer[i, default: []].removeAll(keepingCapacity: true)
            }
        }
        
        public mutating func next() async rethrows -> [Int: [UInt8]]? {
            func yield() -> [Int: [UInt8]]? {
                defer { resetBuffer() }
                if buffer.values.allSatisfy({ bufferValue in
                    bufferValue.isEmpty
                }) { return nil }
                return buffer
            }
            
            func nextByte() async throws -> UInt8? {
                return try await byteSource.next()
            }
            
            func iterateColumn() {
                guard columnCount > columnPosition + 1 else {
                    columnPosition = 0
                    return
                }
                columnPosition += 1
            }
            
            while let first = try await nextByte() {
                let isFinalColumn = columnCount == columnPosition + 1
                let relevantSeparator = isFinalColumn ? lineSeparator : columnSeparator
                
                switch relevantSeparator {
                case .oneByte(let grapheme):
                    guard first == grapheme else {
                        buffer[columnPosition, default: []].append(first)
                        continue
                    }
                    if let result = yield() {
                        guard isFinalColumn else { iterateColumn(); continue }
                        return result
                    }
                    continue
                    
                case .twoByte(let grapheme):
                    guard first == grapheme.prefix else {
                        buffer[columnPosition, default: []].append(first)
                        continue
                    }
                    guard let suffix = try await byteSource.next() else {
                        buffer[columnPosition, default: []].append(first)
                        guard isFinalColumn else { iterateColumn(); continue }
                        return yield()
                    }
                    guard suffix == grapheme.suffix else {
                        buffer[columnPosition, default: []].append(first)
                        buffer[columnPosition, default: []].append(suffix)
                        continue
                    }
                    if let result = yield(), isFinalColumn { return result }
                    continue

                case .threeByte(let grapheme):
                    guard first == grapheme.prefix else {
                        buffer[columnPosition, default: []].append(first)
                        continue
                    }
                    guard let continuation = try await byteSource.next() else {
                        buffer[columnPosition, default: []].append(first)
                        guard isFinalColumn else { iterateColumn(); continue }
                        return yield()
                    }
                    guard continuation == grapheme.continuation else {
                        buffer[columnPosition, default: []].append(first)
                        buffer[columnPosition, default: []].append(continuation)
                        continue
                    }
                    guard let suffix = try await byteSource.next() else {
                        buffer[columnPosition, default: []].append(first)
                        buffer[columnPosition, default: []].append(continuation)
                        guard isFinalColumn else { iterateColumn(); continue }
                        return yield()
                    }
                    guard suffix == grapheme.suffix else {
                        buffer[columnPosition, default: []].append(first)
                        buffer[columnPosition, default: []].append(continuation)
                        buffer[columnPosition, default: []].append(suffix)
                        continue
                    }
                    if let result = yield(), isFinalColumn { return result }
                    continue
                    
                case .fourByte(let grapheme):
                    guard first == grapheme.prefix else {
                        buffer[columnPosition, default: []].append(first)
                        continue
                    }
                    guard let continuation1 = try await byteSource.next() else {
                        buffer[columnPosition, default: []].append(first)
                        guard isFinalColumn else { iterateColumn(); continue }
                        return yield()
                    }
                    guard continuation1 == grapheme.continuation1 else {
                        buffer[columnPosition, default: []].append(first)
                        buffer[columnPosition, default: []].append(continuation1)
                        continue
                    }
                    
                    guard let continuation2 = try await byteSource.next() else {
                        buffer[columnPosition, default: []].append(first)
                        buffer[columnPosition, default: []].append(continuation1)
                        guard isFinalColumn else { iterateColumn(); continue }
                        return yield()
                    }
                    guard continuation2 == grapheme.continuation2 else {
                        buffer[columnPosition, default: []].append(first)
                        buffer[columnPosition, default: []].append(continuation1)
                        buffer[columnPosition, default: []].append(continuation2)
                        continue
                    }
                    guard let suffix = try await byteSource.next() else {
                        buffer[columnPosition, default: []].append(first)
                        buffer[columnPosition, default: []].append(continuation1)
                        buffer[columnPosition, default: []].append(continuation2)
                        guard isFinalColumn else { iterateColumn(); continue }
                        return yield()
                    }
                    guard suffix == grapheme.suffix else {
                        buffer[columnPosition, default: []].append(first)
                        buffer[columnPosition, default: []].append(continuation1)
                        buffer[columnPosition, default: []].append(continuation2)
                        buffer[columnPosition, default: []].append(suffix)
                        continue
                    }
                    if let result = yield(), isFinalColumn { return result }
                    continue
                }
            }
            
            if !buffer.isEmpty && columnCount == columnPosition - 1 { return yield() }
            return nil
        }
    }
}
