//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/11/2023.
//

import Foundation

extension KernelSwiftCommon.Concurrency {
    public struct LifecyclePromise: Sendable {
        public static func start(using promise: AsyncPromise<Void> = .init()) -> Self {
            return self.init(promise: promise)
        }
        
        public var onStop: Void {
            get async throws { try await self.promise.awaitValue }
        }
        
        private let promise: AsyncPromise<Void>
        
        public func stop() { self.promise.fulfill() }
    }
}
