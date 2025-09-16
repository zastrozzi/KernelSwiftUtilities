//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

public protocol _KernelDIHasInitialValues {
    var initialValues: KernelDI.Injector { get }
}

extension KernelDI {
    public typealias HasInitialValues = _KernelDIHasInitialValues
}
