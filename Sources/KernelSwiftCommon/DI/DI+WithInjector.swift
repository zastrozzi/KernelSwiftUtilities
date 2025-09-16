//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

extension KernelDI {
    public static func withEscapedInjector<Result>(_ operation: (Injector.Continuation) throws -> Result) rethrows -> Result {
        try operation(Injector.Continuation())
    }
    
    public static func withEscapedInjector<Result>(_ operation: (Injector.Continuation) async throws -> Result) async rethrows -> Result {
        try await operation(Injector.Continuation())
    }
    
    private static let injectorObjects = InjectorObjects()
    
    @discardableResult
    public static func withInjector<Result: Sendable>(
        _ updateValuesForOperation: (inout Injector) throws -> Void,
        operation: () throws -> Result
    ) rethrows -> Result {
        try injectorIsSetting(true) {
            var injector = Injector._current
            try updateValuesForOperation(&injector)
            return try Injector.$_current.withValue(injector) {
                try injectorIsSetting(false) {
                    let result = try operation()
                    if Result.self is AnyClass {
                        injectorObjects.store(result as AnyObject)
                    }
                    return result
                }
            }
        }
    }
    
    
    @discardableResult
    public static func withInjector<Result: Sendable>(
        isolation: isolated (any Actor)? = #isolation, _ updateValuesForOperation: @Sendable (inout Injector) async throws -> Void,
        operation: @Sendable () async throws -> Result
    ) async rethrows -> Result {
        try await injectorIsSetting(true) {
            var injector = Injector._current
            try await updateValuesForOperation(&injector)
            return try await Injector.$_current.withValue(injector) {
                try await injectorIsSetting(false) {
                    let result = try await operation()
                    if Result.self is AnyClass {
                        injectorObjects.store(result as AnyObject)
                    }
                    return result
                }
            }
        }
    }
    
    @discardableResult
    public static func withInjector<Model: AnyObject, Result: Sendable>(
        from model: Model,
        _ updateValuesForOperation: (inout Injector) throws -> Void,
        operation: () throws -> Result,
        file: StaticString? = nil,
        line: UInt? = nil
    ) rethrows -> Result {
        guard let values = injectorObjects.injector(from: model)
        else {
            return try operation()
        }
        return try withInjector {
            $0 = values.merging(Injector._current)
            try updateValuesForOperation(&$0)
        } operation: {
            let result = try operation()
            if Result.self is AnyClass {
                injectorObjects.store(result as AnyObject)
            }
            return result
        }
    }
    
    @discardableResult
    public static func withInjector<Model: AnyObject, Result: Sendable>(
        from model: Model,
        operation: () throws -> Result,
        file: StaticString? = nil,
        line: UInt? = nil
    ) rethrows -> Result {
        try withInjector(
            from: model,
            { _ in },
            operation: operation,
            file: file,
            line: line
        )
    }
    
    
    @discardableResult
    public static func withInjector<Model: AnyObject, Result: Sendable>(
        isolation: isolated (any Actor)? = #isolation,
        from model: Model,
        _ updateValuesForOperation: @Sendable (inout Injector) async throws -> Void,
        operation: @Sendable () async throws -> Result,
        file: StaticString? = nil,
        line: UInt? = nil
    ) async rethrows -> Result {
        guard let values = injectorObjects.injector(from: model)
        else {
            return try await operation()
        }
        return try await withInjector(isolation: isolation) {
            $0 = values.merging(Injector._current)
            try await updateValuesForOperation(&$0)
        } operation: {
            let result = try await operation()
            if Result.self is AnyClass {
                injectorObjects.store(result as AnyObject)
            }
            return result
        }
    }
    
    
    @discardableResult
    public static func withInjector<Model: AnyObject, Result: Sendable>(
        isolation: isolated (any Actor)? = #isolation,
        from model: Model,
        operation: @Sendable () async throws -> Result,
        file: StaticString? = nil,
        line: UInt? = nil
    ) async rethrows -> Result {
        try await withInjector(isolation: isolation, from: model, { _ in }, operation: operation, file: file, line: line)
    }

}
