//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

#if canImport(Darwin) && compiler(>=5.10)
private import Darwin
#elseif canImport(Darwin)
@_implementationOnly import Darwin
#elseif canImport(Glibc) && compiler(>=5.10)
private import Glibc
#elseif canImport(Glibc)
@_implementationOnly import Glibc
#endif

extension KernelSwiftCommon.Concurrency.Core {
    public struct StreamLock {
        public typealias Primitive = pthread_mutex_t
        
        @usableFromInline
        enum Operations {}
        
        @usableFromInline
        internal let _storage: Storage<Void>
        
        
        public init() {
            self._storage = .create(value: ())
        }
        
        @inlinable
        func lock() {
            self._storage.lock()
        }
        
        @inlinable
        func unlock() {
            self._storage.unlock()
        }
        
        @inlinable
        internal func withLockPrimitive<T>(
            _ body: (UnsafeMutablePointer<Primitive>) throws -> T
        ) rethrows -> T {
            return try self._storage.withLockPrimitive(body)
        }
    }
    
}
    
    
extension KernelSwiftCommon.Concurrency.Core.StreamLock.Operations {
    @inlinable
    static func create(_ mutex: UnsafeMutablePointer<KernelSwiftCommon.Concurrency.Core.StreamLock.Primitive>) {
        mutex.assertValidAlignment()
        
        var attr = pthread_mutexattr_t()
        pthread_mutexattr_init(&attr)
        
        let err = pthread_mutex_init(mutex, &attr)
        precondition(err == 0, "\(#function) failed in pthread_mutex with error \(err)")
    }
    
    @inlinable
    static func destroy(_ mutex: UnsafeMutablePointer<KernelSwiftCommon.Concurrency.Core.StreamLock.Primitive>) {
        mutex.assertValidAlignment()
        
        let err = pthread_mutex_destroy(mutex)
        precondition(err == 0, "\(#function) failed in pthread_mutex with error \(err)")
    }
    
    @inlinable
    static func lock(_ mutex: UnsafeMutablePointer<KernelSwiftCommon.Concurrency.Core.StreamLock.Primitive>) {
        mutex.assertValidAlignment()
        
        let err = pthread_mutex_lock(mutex)
        precondition(err == 0, "\(#function) failed in pthread_mutex with error \(err)")
    }
    
    @inlinable
    static func unlock(_ mutex: UnsafeMutablePointer<KernelSwiftCommon.Concurrency.Core.StreamLock.Primitive>) {
        mutex.assertValidAlignment()
        
        let err = pthread_mutex_unlock(mutex)
        precondition(err == 0, "\(#function) failed in pthread_mutex with error \(err)")
    }
}


extension KernelSwiftCommon.Concurrency.Core.StreamLock {
    
    public final class Storage<Value>: ManagedBuffer<Value, Primitive> {
        
        @inlinable
        public static func create(value: Value) -> Self {
            let buffer = Self.create(minimumCapacity: 1) { _ in
                return value
            }
            
            let storage = buffer as! Self
            
            storage.withUnsafeMutablePointers { _, lockPtr in
                Operations.create(lockPtr)
            }
            
            return storage
        }
        
        @inlinable
        public func lock() {
            self.withUnsafeMutablePointerToElements { lockPtr in
                Operations.lock(lockPtr)
            }
        }
        
        @inlinable
        public func unlock() {
            self.withUnsafeMutablePointerToElements { lockPtr in
                Operations.unlock(lockPtr)
            }
        }
        
        deinit {
            self.withUnsafeMutablePointerToElements { lockPtr in
                Operations.destroy(lockPtr)
            }
        }
        
        @inlinable
        public func withLockPrimitive<T>(
            _ body: (UnsafeMutablePointer<Primitive>) throws -> T
        ) rethrows -> T {
            try self.withUnsafeMutablePointerToElements { lockPtr in
                return try body(lockPtr)
            }
        }
        
        @inlinable
        public func withLockedValue<T>(_ mutate: (inout Value) throws -> T) rethrows -> T {
            try self.withUnsafeMutablePointers { valuePtr, lockPtr in
                Operations.lock(lockPtr)
                defer { Operations.unlock(lockPtr) }
                return try mutate(&valuePtr.pointee)
            }
        }
    }
}

extension KernelSwiftCommon.Concurrency.Core.StreamLock.Storage: @unchecked Sendable {}

extension KernelSwiftCommon.Concurrency.Core.StreamLock {
    public func withLock<T>(_ body: () throws -> T) rethrows -> T {
        self.lock()
        defer {
            self.unlock()
        }
        return try body()
    }
}

extension KernelSwiftCommon.Concurrency.Core.StreamLock: Sendable {}

extension UnsafeMutablePointer {
    @inlinable
    func assertValidAlignment() {
        assert(UInt(bitPattern: self) % UInt(MemoryLayout<Pointee>.alignment) == 0)
    }
}

extension KernelSwiftCommon.Concurrency.Core.StreamLock {
    public struct LockedValueBox<Value> {
        @usableFromInline
        let storage: Storage<Value>
        
        public init(_ value: Value) {
            self.storage = .create(value: value)
        }
        
        @inlinable
        public func withLockedValue<T>(_ mutate: (inout Value) throws -> T) rethrows -> T {
            return try self.storage.withLockedValue(mutate)
        }
    }
}

extension KernelSwiftCommon.Concurrency.Core.StreamLock.LockedValueBox: Sendable where Value: Sendable {}
