//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelSwiftCommon.Concurrency {
    public struct AnyIterator<Element: Sendable>: AsyncIteratorProtocol {
        private let produceNext: () async throws -> Element?
        
        public init<Iterator: AsyncIteratorProtocol>(_ iterator: Iterator) where Iterator.Element == Element {
            var iterator = iterator
            self.produceNext = { try await iterator.next() }
        }
        
        public mutating func next() async throws -> Element? { try await produceNext() }
    }
}
