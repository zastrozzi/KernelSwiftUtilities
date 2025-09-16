//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/08/2022.
//

import Foundation

prefix operator /

public func ~= <Root, Value>(pattern: KernelCasePath<Root, Value>, value: Root) -> Bool {
    pattern.extract(from: value) != nil
}

public prefix func / <Root, Value>(embed: @escaping (Value) -> Root) -> KernelCasePath<Root, Value> {
    .init(embed: embed, extract: extractHelper(embed))
}

public prefix func / <Root, Value>(embed: @escaping (Value) -> Root?) -> KernelCasePath<Root?, Value> {
    .init(embed: embed, extract: optionalPromotedExtractHelper(embed))
}

public prefix func / <Root>(root: Root) -> KernelCasePath<Root, Void> {
    .init(embed: { root }, extract: extractVoidHelper(root))
}

public prefix func / <Root>(root: Root?) -> KernelCasePath<Root?, Void> {
    .init(embed: { root }, extract: optionalPromotedExtractVoidHelper(root))
}

public prefix func / <Root>(type: Root.Type) -> KernelCasePath<Root, Root> {
    .self
}

public prefix func / <Root>(type: KernelCasePath<Root, Root>) -> KernelCasePath<Root, Root> {
    .self
}

@_disfavoredOverload
public prefix func / <Root: Sendable, Value: Sendable>(embed: @escaping (Value) -> Root) -> (Root) -> Value? {
    (/embed).extract(from:)
}

@_disfavoredOverload
public prefix func / <Root: Sendable, Value: Sendable>(embed: @escaping (Value) -> Root?) -> (Root?) -> Value? {
    (/embed).extract(from:)
}

@_disfavoredOverload
public prefix func / <Root: Sendable>(root: Root) -> (Root) -> Void? {
    (/root).extract(from:)
}

@_disfavoredOverload
public prefix func / <Root: Sendable>(root: Root) -> (Root?) -> Void? {
    (/root).extract(from:)
}

precedencegroup KernelCasePathCompositionPrecedence {
    associativity: left
}

infix operator ..: KernelCasePathCompositionPrecedence

extension KernelCasePath {
    public static func .. <AppendedValue>(lhs: KernelCasePath, rhs: KernelCasePath<Value, AppendedValue>) -> KernelCasePath<Root, AppendedValue> {
        lhs.appending(path: rhs)
    }
    
    public static func .. <AppendedValue>(lhs: KernelCasePath, rhs: @escaping (AppendedValue) -> Value) -> KernelCasePath<Root, AppendedValue> {
        lhs.appending(path: /rhs)
    }
}

public func .. <Root, Value: Sendable, AppendedValue: Sendable>(lhs: @escaping (Root) -> Value?, rhs: @escaping (AppendedValue) -> Value) -> (Root) -> AppendedValue? {
    return { root in lhs(root).flatMap((/rhs).extract(from:)) }
}
