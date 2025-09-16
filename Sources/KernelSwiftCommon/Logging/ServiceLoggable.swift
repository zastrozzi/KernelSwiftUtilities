//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 06/03/2025.
//

import Logging

@_documentation(visibility: private)
public protocol _KernelServiceLoggable {
    associatedtype FeatureContainer: FeatureLoggable
}

extension KernelDI {
    public typealias ServiceLoggable = _KernelServiceLoggable
}

extension KernelDI.ServiceLoggable {
    public static var logger: Logger { FeatureContainer.logger }
}
