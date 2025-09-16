//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

public protocol _KernelDIInjectable {
    associatedtype Token: KernelDI.InjectionToken = KernelDI.DefaultInjectableToken<Self>
    init()
//    static func resolve() async throws -> Self
}

extension KernelDI {
    public typealias Injectable = _KernelDIInjectable
}

