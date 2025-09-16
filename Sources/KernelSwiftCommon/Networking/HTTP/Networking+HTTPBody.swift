//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelNetworking {
    public final class HTTPBody: @unchecked Sendable {
        public typealias ByteChunk = ArraySlice<UInt8>
        
        public let iterationBehaviour: KernelSwiftCommon.Concurrency.IterationBehaviour
        
        public enum Length: Sendable, Equatable {
            case unknown
            case known(Int64)
        }
        
        public let length: Length
        
        private let sequence: KernelSwiftCommon.Concurrency.AnySequence<ByteChunk>
        
        private let lock: NSLock = {
            let lock = NSLock()
            lock.name = "com.apple.swift-openapi-generator.runtime.body"
            return lock
        }()
        
        private var locked_iteratorCreated: Bool = false
        
        internal var testing_iteratorCreated: Bool {
            lock.lock()
            defer { lock.unlock() }
            return locked_iteratorCreated
        }
        
        private func tryToMarkIteratorCreated() throws {
            lock.lock()
            defer {
                locked_iteratorCreated = true
                lock.unlock()
            }
            guard iterationBehaviour == .single else { return }
            if locked_iteratorCreated { throw TooManyIterationsError() }
        }
        
        public init(
            _ sequence: KernelSwiftCommon.Concurrency.AnySequence<ByteChunk>,
            length: Length,
            iterationBehaviour: KernelSwiftCommon.Concurrency.IterationBehaviour
        ) {
            self.sequence = sequence
            self.length = length
            self.iterationBehaviour = iterationBehaviour
        }
        
        @usableFromInline convenience init(
            _ byteChunks: some Sequence<ByteChunk> & Sendable,
            length: Length,
            iterationBehaviour: KernelSwiftCommon.Concurrency.IterationBehaviour
        ) {
            self.init(
                .init(KernelSwiftCommon.Concurrency.WrappedSyncSequence(sequence: byteChunks)),
                length: length,
                iterationBehaviour: iterationBehaviour
            )
        }
    }
}
    
extension KernelNetworking.HTTPBody: Equatable {
    public static func == (lhs: KernelNetworking.HTTPBody, rhs: KernelNetworking.HTTPBody) -> Bool { ObjectIdentifier(lhs) == ObjectIdentifier(rhs) }
}
    
extension KernelNetworking.HTTPBody: Hashable {
    public func hash(into hasher: inout Hasher) { hasher.combine(ObjectIdentifier(self)) }
}
    
extension KernelNetworking.HTTPBody {
    
    @inlinable public convenience init() {
        self.init(.init(KernelSwiftCommon.Concurrency.EmptySequence()), length: .known(0), iterationBehaviour: .multiple)
    }
    
    @inlinable public convenience init(_ bytes: ByteChunk, length: Length) {
        self.init([bytes], length: length, iterationBehaviour: .multiple)
    }
    
    @inlinable public convenience init(_ bytes: ByteChunk) {
        self.init([bytes], length: .known(Int64(bytes.count)), iterationBehaviour: .multiple)
    }
    
    @inlinable public convenience init(
        _ bytes: some Sequence<UInt8> & Sendable,
        length: Length,
        iterationBehaviour: KernelSwiftCommon.Concurrency.IterationBehaviour
    ) { self.init([ArraySlice(bytes)], length: length, iterationBehaviour: iterationBehaviour) }
    
    @inlinable public convenience init(_ bytes: some Collection<UInt8> & Sendable, length: Length) {
        self.init(ArraySlice(bytes), length: length, iterationBehaviour: .multiple)
    }
    
    @inlinable public convenience init(_ bytes: some Collection<UInt8> & Sendable) {
        self.init(bytes, length: .known(Int64(bytes.count)))
    }
    
    @inlinable public convenience init(_ stream: AsyncThrowingStream<ByteChunk, any Error>, length: Length) {
        self.init(.init(stream), length: length, iterationBehaviour: .single)
    }
    
    @inlinable public convenience init(_ stream: AsyncStream<ByteChunk>, length: Length) {
        self.init(.init(stream), length: length, iterationBehaviour: .single)
    }
    
    @inlinable public convenience init<Bytes: AsyncSequence>(
        _ sequence: Bytes,
        length: Length,
        iterationBehaviour: KernelSwiftCommon.Concurrency.IterationBehaviour
    ) where Bytes.Element == ByteChunk, Bytes: Sendable {
        self.init(.init(sequence), length: length, iterationBehaviour: iterationBehaviour)
    }
    
    @inlinable public convenience init<Bytes: AsyncSequence>(
        _ sequence: Bytes,
        length: Length,
        iterationBehaviour: KernelSwiftCommon.Concurrency.IterationBehaviour
    ) where Bytes: Sendable, Bytes.Element: Sequence & Sendable, Bytes.Element.Element == UInt8 {
        self.init(sequence.map { ArraySlice($0) }, length: length, iterationBehaviour: iterationBehaviour)
    }
}

extension KernelNetworking.HTTPBody: AsyncSequence {
    
    public typealias Element = ByteChunk
    
    public typealias AsyncIterator = Iterator
    
    public func makeAsyncIterator() -> AsyncIterator {
        do {
            try tryToMarkIteratorCreated()
            return .init(sequence.makeAsyncIterator())
        } catch { return .init(throwing: error) }
    }
}

extension KernelNetworking.HTTPBody {
    private struct TooManyBytesError: Error, CustomStringConvertible, LocalizedError {
        let maxBytes: Int
        
        var description: String { "HTTPBody contains more than the maximum allowed \(maxBytes) bytes." }
        
        var errorDescription: String? { description }
    }
    
    private struct TooManyIterationsError: Error, CustomStringConvertible, LocalizedError {
        
        var description: String {
            "HTTPBody attempted to create a second iterator, but the underlying sequence is only safe to be iterated once."
        }
        
        var errorDescription: String? { description }
    }
    
    fileprivate func collect(upTo maxBytes: Int) async throws -> ByteChunk {
        if case .known(let knownBytes) = length {
            guard knownBytes <= maxBytes else { throw TooManyBytesError(maxBytes: maxBytes) }
        }
        var buffer = ByteChunk()
        for try await chunk in self {
            guard buffer.count + chunk.count <= maxBytes else { throw TooManyBytesError(maxBytes: maxBytes) }
            buffer.append(contentsOf: chunk)
        }
        return buffer
    }
}

extension KernelNetworking.HTTPBody.ByteChunk {
    public init(collecting body: KernelNetworking.HTTPBody, upTo maxBytes: Int) async throws {
        self = try await body.collect(upTo: maxBytes)
    }
}

extension Array where Element == UInt8 {
    public init(collecting body: KernelNetworking.HTTPBody, upTo maxBytes: Int) async throws {
        self = try await Array(body.collect(upTo: maxBytes))
    }
}

extension KernelNetworking.HTTPBody {
    
    @inlinable public convenience init(_ string: some StringProtocol & Sendable, length: Length) {
        self.init(ByteChunk(string), length: length)
    }
    
    @inlinable public convenience init(_ string: some StringProtocol & Sendable) { self.init(ByteChunk(string)) }
    
    @inlinable public convenience init(
        _ stream: AsyncThrowingStream<some StringProtocol & Sendable, any Error & Sendable>,
        length: Length
    ) { self.init(.init(stream.map { ByteChunk.init($0) }), length: length, iterationBehaviour: .single) }
    
    @inlinable public convenience init(_ stream: AsyncStream<some StringProtocol & Sendable>, length: Length) {
        self.init(.init(stream.map { ByteChunk.init($0) }), length: length, iterationBehaviour: .single)
    }
    
    @inlinable public convenience init<Strings: AsyncSequence>(
        _ sequence: Strings,
        length: Length,
        iterationBehaviour: KernelSwiftCommon.Concurrency.IterationBehaviour
    ) where Strings.Element: StringProtocol & Sendable, Strings: Sendable {
        self.init(.init(sequence.map { ByteChunk.init($0) }), length: length, iterationBehaviour: iterationBehaviour)
    }
}

extension KernelNetworking.HTTPBody.ByteChunk {
    
    @inlinable init(_ string: some StringProtocol & Sendable) { self = Array(string.utf8)[...] }
}

extension String {
    
    public init(collecting body: KernelNetworking.HTTPBody, upTo maxBytes: Int) async throws {
        self = try await String(decoding: body.collect(upTo: maxBytes), as: UTF8.self)
    }
}

extension KernelNetworking.HTTPBody: ExpressibleByStringLiteral {
    
    public convenience init(stringLiteral value: String) { self.init(value) }
}

extension KernelNetworking.HTTPBody {
    
    @inlinable public convenience init(_ bytes: [UInt8]) { self.init(bytes[...]) }
}

extension KernelNetworking.HTTPBody: ExpressibleByArrayLiteral {
    
    public typealias ArrayLiteralElement = UInt8
    
    public convenience init(arrayLiteral elements: UInt8...) { self.init(elements) }
}

extension KernelNetworking.HTTPBody {
    public convenience init(_ data: Data) { self.init(ArraySlice(data)) }
}

extension Data {
    public init(collecting body: KernelNetworking.HTTPBody, upTo maxBytes: Int) async throws {
        self = try await Data(body.collect(upTo: maxBytes))
    }
}

extension KernelNetworking.HTTPBody {
    public struct Iterator: AsyncIteratorProtocol {
        
        public typealias Element = KernelNetworking.HTTPBody.ByteChunk
        
        private let produceNext: () async throws -> Element?
        
        
        @usableFromInline init<Iterator: AsyncIteratorProtocol>(_ iterator: Iterator)
        where Iterator.Element == Element {
            var iterator = iterator
            self.produceNext = { try await iterator.next() }
        }
        
        fileprivate init(throwing error: any Error) { self.produceNext = { throw error } }
        
        public mutating func next() async throws -> Element? { try await produceNext() }
    }
}

