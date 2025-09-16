//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/08/2022.
//

import Foundation

@preconcurrency
typealias embedFunction<Value: Sendable, Root: Sendable> = (Value) -> Root

public struct KernelCasePath<Root: Sendable, Value: Sendable>: @unchecked Sendable {
    private let _embed: embedFunction<Value, Root>
    private let _extract: (Root) -> Value?

    /// Creates a case path with a pair of functions.
    /// - Parameters:
    ///   - embed: A function that always succeeds in embedding a value in a root.
    ///   - extract: A function that can optionally fail in extracting a value from a root.
    public init(embed: @escaping (Value) -> Root, extract: @escaping (Root) -> Value?) {
        self._embed = embed
        self._extract = extract
    }
    
    /// Returns a root by embedding a value.
    /// - Parameter value: A  value to embed.
    /// - Returns: A root that embeds `value`
    public func embed(_ value: Value) -> Root {
        self._embed(value)
    }
    
    /// Attempts to extract a value from a root.
    /// - Parameter root: A root to extract from.
    /// - Returns: A value if it can be extracted from the given root, otherwise `nil`.
    public func extract(from root: Root) -> Value? {
        self._extract(root)
    }
    
    public func modify<Result>(
        _ root: inout Root,
        _ body: (inout Value) throws -> Result
    ) throws -> Result {
        guard var value = self.extract(from: root) else { throw ExtractionFailed() }
        let result = try body(&value)
        root = self.embed(value)
        return result
    }
    
    public func appending<AppendedValue>(path: KernelCasePath<Value, AppendedValue>) -> KernelCasePath<Root, AppendedValue> {
        KernelCasePath<Root, AppendedValue>(
            embed: { self.embed(path.embed($0)) },
            extract: { self.extract(from: $0).flatMap(path.extract) }
        )
    }
}

extension KernelCasePath: CustomStringConvertible {
    public var description: String {
        "KernelCasePath<\(Root.self), \(Value.self)>"
    }
}

struct ExtractionFailed: Error {}
