//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/11/2023.
//

import Foundation

extension KernelSwiftCommon.Concurrency.Broadcast {
    public struct AsyncBroadcastSequence<Base: AsyncSequence>: AsyncSequence where Base: Sendable, Base.Element: Sendable {
        public typealias Element = Base.Element
        public typealias AsyncIterator = Iterator
        
        private let storage: BroadcastStorage<Base>
        
        public init(base: Base) {
            self.storage = BroadcastStorage(base: base)
        }
        
        public func makeAsyncIterator() -> Iterator { Iterator(storage: storage) }
        
        public struct Iterator: AsyncIteratorProtocol {
            private var id: Int
            private let storage: BroadcastStorage<Base>
            
            init(storage: BroadcastStorage<Base>) {
                self.storage = storage
                self.id = storage.generateId()
            }
            
            public mutating func next() async rethrows -> Element? {
                let element = await storage.next(id: id)
                return try element?._rethrowGet()
            }
        }
    }
}

public typealias AsyncBroadcastSequence = KernelSwiftCommon.Concurrency.Broadcast.AsyncBroadcastSequence

extension AsyncSequence where Self: Sendable, Self.Element: Sendable {
    public func broadcast() -> KernelSwiftCommon.Concurrency.Broadcast.AsyncBroadcastSequence<Self> { .init(base: self) }
}
