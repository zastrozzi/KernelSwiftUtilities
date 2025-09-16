//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/11/2023.
//

import Foundation

extension KernelSwiftCommon.Concurrency.Core {
    public struct ManagedCriticalState<State: Sendable>: Sendable {
        
        @usableFromInline
        internal final class LockedBuffer: ManagedBuffer<State, CriticalLock.Primitive>, @unchecked Sendable {
            deinit {
                withUnsafeMutablePointerToElements { CriticalLock.deinitialize($0) }
            }
        }
        
        @usableFromInline
        internal let buffer: ManagedBuffer<State, CriticalLock.Primitive>
        
        public init(_ initial: State) {
            buffer = LockedBuffer.create(minimumCapacity: 1, makingHeaderWith: { buffer in
                buffer.withUnsafeMutablePointerToElements { CriticalLock.initialize($0) }
                return initial
            })
        }
        
        @inlinable
        public func withCriticalRegion<R>(_ critical: (inout State) throws -> R) rethrows -> R {
            try buffer.withUnsafeMutablePointers({ header, lock in
                CriticalLock.lock(lock)
                defer { CriticalLock.unlock(lock) }
                return try critical(&header.pointee)
            })
        }
    }
}

extension ManagedBuffer: @unchecked @retroactive Sendable {}
