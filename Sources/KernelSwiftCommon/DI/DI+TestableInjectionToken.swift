//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

public protocol _KernelDITestableInjectionToken: KernelDI.InjectionTokenStringConvertible {
    associatedtype Value: Sendable = Self
    
    static var previewValue: Value { get }
    static var testValue: Value { get }
}

extension KernelDI {
    public typealias TestableInjectionToken = _KernelDITestableInjectionToken
}

extension KernelDI.TestableInjectionToken {
    public static var injectableName: String {
        KernelDI.Injector.currentInjectable.name.map { "@Injectable(\\.\($0))" } ?? "Unknown Injectable"
    }
    
    public static var injectableDescription: String {
        var description = ""
        if
            let fileID = KernelDI.Injector.currentInjectable.fileID,
            let line = KernelDI.Injector.currentInjectable.line
        {
            description.append(
            """
            Location:
                \(fileID):\(line)
            """
            )
        }
        
        description.append(
            Self.self == Self.Value.self ?
        """
        Injectable:
            \(typeName(Self.Value.self))
        """
            :
        """
        Key:
            \(typeName(Self.self))
        Value:
            \(typeName(Self.Value.self))
        """
        )
        
        return description
    }
}
