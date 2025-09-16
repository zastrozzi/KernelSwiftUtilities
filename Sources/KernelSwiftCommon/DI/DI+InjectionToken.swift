//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

public protocol _KernelDIInjectionToken: KernelDI.TestableInjectionToken {
    associatedtype Value = Self
    
    static var liveValue: Value { get }
    static var previewValue: Value { get }
    static var testValue: Value { get }
}

extension KernelDI {
    public typealias InjectionToken = _KernelDIInjectionToken
}

extension KernelDI.InjectionToken {
    public static var previewValue: Value { self.liveValue }
    
    public static var testValue: Value {
#if DEBUG
        
        guard !KernelDI.Injector.isSetting else { return Self.previewValue }
        KernelDI.logger.error(
        """
        \(Self.injectableName) has no test implementation, but was accessed from a test context:
        
        \(Self.injectableDescription)
        
        Injectables registered with the library are not allowed to use their default, live \
        implementations when run from tests.
        
        To fix, override \
        \(KernelDI.Injector.currentInjectable.name.map { "'\($0)'" } ?? "the injectable") with a \
        test value.
        """
        )
        
#endif
        return Self.previewValue
    }
}
