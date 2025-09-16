//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/04/2023.
//

import Foundation

extension PartialBuilder {
    
    internal final class Weak<WeakWrapped: AnyObject> {
        private(set) weak var wrapped: WeakWrapped?
        
        init(_ wrapped: WeakWrapped) {
            self.wrapped = wrapped
        }
    }
}

extension PartialBuilder.Weak: Equatable where WeakWrapped: Equatable {
//    static func == (lhs: PartialBuilder<Wrapped>.Weak<Wrapped>, rhs: PartialBuilder<Wrapped>.Weak<Wrapped>) -> Bool {
//        return lhs.wrapped == rhs.wrapped
//    }
//
    static func == (lhs: PartialBuilder.Weak<WeakWrapped>, rhs: PartialBuilder.Weak<WeakWrapped>) -> Bool {
        return lhs.wrapped == rhs.wrapped
    }
}

extension PartialBuilder.Weak: Hashable where WeakWrapped: Hashable {
    func hash(into hasher: inout Hasher) {
        wrapped?.hash(into: &hasher)
    }
}
