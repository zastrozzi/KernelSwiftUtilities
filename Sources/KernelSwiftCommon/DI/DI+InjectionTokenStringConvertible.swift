//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

public protocol _KernelDIInjectionTokenStringConvertible {
    static var injectableDescription: String { get }
    static var injectableName: String { get }
}

extension KernelDI {
    public typealias InjectionTokenStringConvertible = _KernelDIInjectionTokenStringConvertible
}
