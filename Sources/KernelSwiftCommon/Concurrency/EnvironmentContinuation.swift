//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import Foundation

#if DEBUG
public typealias EnvironmentContinuation = CheckedContinuation

@inlinable
public func withEnvironmentContinuation<T>(
    function: String = #function,
    _ body: (CheckedContinuation<T, Never>) -> Void
) async -> T {
    await withCheckedContinuation(function: function, body)
}

@inlinable
public func withThrowingEnvironmentContinuation<T>(
    function: String = #function,
    _ body: (CheckedContinuation<T, Error>) -> Void
) async throws -> T {
    try await withCheckedThrowingContinuation(function: function, body)
}
#else
public typealias EnvironmentContinuation = CheckedContinuation

@inlinable
public func withEnvironmentContinuation<T>(
    function: String = #function,
    _ body: (CheckedContinuation<T, Never>) -> Void
) async -> T {
    await withCheckedContinuation(function: function, body)
}

@inlinable
public func withThrowingEnvironmentContinuation<T>(
    function: String = #function,
    _ body: (CheckedContinuation<T, Error>) -> Void
) async throws -> T {
    try await withCheckedThrowingContinuation(function: function, body)
}
#endif
