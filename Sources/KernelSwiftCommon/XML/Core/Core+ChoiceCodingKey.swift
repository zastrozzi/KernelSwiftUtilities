//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

@_documentation(visibility: private)
public protocol _KernelXMLChoiceCodingKey: CodingKey {}

extension KernelXML {
    public typealias ChoiceCodingKey = _KernelXMLChoiceCodingKey
}
