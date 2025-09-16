//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/11/2023.
//

import Foundation
import Collections

public struct AsyncStandardInputKeySequence: AsyncSequence {
    public typealias Element = UInt8.StandardIn

    public struct AsyncIterator: AsyncIteratorProtocol {
        var inputIterator = FileHandle.standardInput.compatBytes.makeAsyncIterator()
        var currentBuffer: [UInt8] = []
        var awaiting: Int = 1
        var escaped = false
        
        public mutating func next() async throws -> Element? {
            guard awaiting > 0 else { return fromBuffer() }
            while awaiting > 0 { try await loadNextByte() }
            return try await next()
        }
        
        public mutating func loadNextByte() async throws {
            defer { awaiting -= 1 }
            if let nextByte = try await self.inputIterator.next() {
                currentBuffer.append(nextByte)
                guard !escaped else {
                    guard nextByte != .standardInPrefixByte.escaped.rawValue else { return }
                    guard currentBuffer.count < 7 else {
                        clearBuffer(newAwaitingVal: 2)
                        return
                    }
                    if !UInt8.StandardIn.isKnownEscapedSeq(currentBuffer) { awaiting += 1 }
                    return
                }
                guard awaiting == 1 else { return }
                escaped = false
                switch nextByte {
                case .standardInPrefixByte.escaped.rawValue:
                    escaped = true
                    awaiting += 1
                    return
                case _ where UInt8.standardInPrefixByte.isTwoBytePrefix(nextByte):
                    awaiting += 1
                    return
                case _ where UInt8.standardInPrefixByte.isThreeBytePrefix(nextByte):
                    awaiting += 2
                    return
                case _ where UInt8.standardInPrefixByte.isFourBytePrefix(nextByte):
                    awaiting += 3
                    return
                default: return
                }
            }
        }
        
        public mutating func clearBuffer(newAwaitingVal: Int = 1) {
            currentBuffer = []
            awaiting = newAwaitingVal
            escaped = false
        }
        
        public mutating func fromBuffer() -> Element? {
            defer { clearBuffer() }
            return .init(bytes: currentBuffer)
        }
    }
    
    public init() {}
    
    public func makeAsyncIterator() -> AsyncIterator { return AsyncIterator() }
}
