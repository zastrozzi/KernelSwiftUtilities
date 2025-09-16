//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelSwiftCommon.Concurrency {
    @usableFromInline struct EmptySequence<Element: Sendable>: AsyncSequence, Sendable {
        
        @usableFromInline typealias AsyncIterator = EmptyIterator<Element>
        
        @usableFromInline struct EmptyIterator<IteratorElement: Sendable>: AsyncIteratorProtocol {
            
            @usableFromInline mutating func next() async throws -> IteratorElement? { nil }
        }
        
        @usableFromInline init() {}
        
        @usableFromInline func makeAsyncIterator() -> AsyncIterator { EmptyIterator() }
    }
}
