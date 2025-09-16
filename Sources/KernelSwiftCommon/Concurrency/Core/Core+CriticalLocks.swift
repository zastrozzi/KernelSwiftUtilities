//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/11/2023.
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
#elseif canImport(WinSDK) && compiler(>=5.10)
private import WinSDK
#elseif canImport(WinSDK)
@_implementationOnly import WinSDK
#endif

extension KernelSwiftCommon.Concurrency.Core {
    
    public struct CriticalLock: Sendable {
#if canImport(Darwin)
        @usableFromInline
        typealias Primitive = os_unfair_lock
#elseif canImport(Glibc)
        @usableFromInline
        typealias Primitive = pthread_mutex_t
#elseif canImport(WinSDK)
        @usableFromInline
        typealias Primitive = SRWLOCK
#endif
        @usableFromInline
        typealias PlatformLock = UnsafeMutablePointer<Primitive>
        
        @usableFromInline nonisolated(unsafe)
        let platformLock: PlatformLock
        
        @usableFromInline
        init(_ platformLock: PlatformLock) {
            self.platformLock = platformLock
        }
        
        @inlinable
        static func initialize(_ platformLock: PlatformLock) {
#if canImport(Darwin)
            platformLock.initialize(to: os_unfair_lock())
#elseif canImport(Glibc)
            pthread_mutex_init(platformLock, nil)
#elseif canImport(WinSDK)
            InitializeSRWLock(platformLock)
#endif
        }
        
        @inlinable
        static func deinitialize(_ platformLock: PlatformLock) {
#if canImport(Glibc)
            pthread_mutex_destroy(platformLock)
#endif
            platformLock.deinitialize(count: 1)
        }
        
        @inlinable
        static func lock(_ platformLock: PlatformLock) {
#if canImport(Darwin)
            os_unfair_lock_lock(platformLock)
#elseif canImport(Glibc)
            pthread_mutex_lock(platformLock)
#elseif canImport(WinSDK)
            AcquireSRWLockExclusive(platformLock)
#endif
        }
        
        @inlinable
        static func unlock(_ platformLock: PlatformLock) {
#if canImport(Darwin)
            os_unfair_lock_unlock(platformLock)
#elseif canImport(Glibc)
            pthread_mutex_unlock(platformLock)
#elseif canImport(WinSDK)
            ReleaseSRWLockExclusive(platformLock)
#endif
        }
        
        @inlinable
        static func allocate() -> CriticalLock {
            let platformLock = PlatformLock.allocate(capacity: 1)
            initialize(platformLock)
            return CriticalLock(platformLock)
        }
        
        @inlinable
        func deinitialize() {
            CriticalLock.deinitialize(platformLock)
        }
        
        @inlinable
        public func lock() {
            CriticalLock.lock(platformLock)
        }
        
        @inlinable
        public func unlock() {
            CriticalLock.unlock(platformLock)
        }
        
        /// Acquire the lock for the duration of the given block.
        ///
        /// This convenience method should be preferred to `lock` and `unlock` in
        /// most situations, as it ensures that the lock will be released regardless
        /// of how `body` exits.
        ///
        /// - Parameter body: The block to execute while holding the lock.
        /// - Returns: The value returned by the block.
        @inlinable
        func withLock<T>(_ body: () throws -> T) rethrows -> T {
            self.lock()
            defer {
                self.unlock()
            }
            return try body()
        }
        
        // specialise Void return (for performance)
        @inlinable
        func withLockVoid(_ body: () throws -> Void) rethrows -> Void {
            try self.withLock(body)
        }
    }
}

extension KernelSwiftCommon.Concurrency.Core.CriticalLock.Primitive: @unchecked @retroactive Sendable {}

extension KernelSwiftCommon.Concurrency.Core.CriticalLock: LockRepresentable {
    public static func fromUnderlying() -> KernelSwiftCommon.Concurrency.Core.CriticalLock {
        return .allocate()
    }
}
