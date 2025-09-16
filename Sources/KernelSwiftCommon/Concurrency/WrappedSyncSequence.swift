//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelSwiftCommon.Concurrency {
    
    public struct WrappedSyncSequence<Upstream: Sequence & Sendable>: AsyncSequence, Sendable
    where Upstream.Element: Sendable {
        public typealias AsyncIterator = Iterator<Element>
        public typealias Element = Upstream.Element
        
        public struct Iterator<IteratorElement: Sendable>: AsyncIteratorProtocol {
            public typealias Element = IteratorElement
            
            var iterator: any IteratorProtocol<Element>
            
            public mutating func next() async throws -> IteratorElement? { iterator.next() }
        }
        
        let sequence: Upstream
        
        public init(sequence: Upstream) { self.sequence = sequence }
        
        public func makeAsyncIterator() -> AsyncIterator { Iterator(iterator: sequence.makeIterator()) }
    }
}
