//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelSwiftCommon.Concurrency {
    public struct AnySequence<Element: Sendable>: AsyncSequence, Sendable {
        
        public typealias AsyncIterator = AnyIterator<Element>
        
        @usableFromInline let produceIterator: @Sendable () -> AsyncIterator
        
        @usableFromInline init<Upstream: AsyncSequence>(_ sequence: Upstream)
        where Upstream.Element == Element, Upstream: Sendable {
            self.produceIterator = { .init(sequence.makeAsyncIterator()) }
        }
        
        public func makeAsyncIterator() -> AsyncIterator { produceIterator() }
    }
}
