//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/10/2023.
//  Extended implementation of Matt Polzin's Sampleable library.
//

import Foundation

@_documentation(visibility: internal)
public protocol _KernelAbstractSampleable {
    static var abstractSample: Any { get }
}

extension KernelSwiftCommon {
    public typealias AbstractSampleable = _KernelAbstractSampleable
}
