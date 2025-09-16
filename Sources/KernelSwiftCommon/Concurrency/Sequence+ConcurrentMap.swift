//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/09/2023.
//

import Foundation

extension Sequence {
    @MainActor
    public func concurrentMap<T: Sendable>(_ transform: @escaping @Sendable (Element) async throws -> T) async rethrows -> [T] {
        let tasks = map { element in
            Task { try await transform(element) }
        }
        
        return try await tasks.asyncMap { task in
            try await task.value
        }
    }
}
