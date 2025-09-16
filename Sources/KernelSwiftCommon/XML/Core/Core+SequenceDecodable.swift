//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

@_documentation(visibility: private)
public protocol _KernelXMLSequenceDecodable {
    init()
}

extension KernelXML {
    public typealias SequenceDecodable = _KernelXMLSequenceDecodable
}

extension Array: KernelXML.SequenceDecodable {}
extension Dictionary: KernelXML.SequenceDecodable {}
