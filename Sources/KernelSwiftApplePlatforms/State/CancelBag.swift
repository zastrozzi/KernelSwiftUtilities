//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/01/2022.
//


import Combine

public final class CancelBag: @unchecked Sendable {
    public init() {}
    
    fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    public func cancel() {
        subscriptions.removeAll()
    }
    
    public func collect(@CancelBagBuilder _ cancellables: () -> [AnyCancellable]) {
        subscriptions.formUnion(cancellables())
    }
    
    @resultBuilder
    public struct CancelBagBuilder {
        public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }
}

public extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
