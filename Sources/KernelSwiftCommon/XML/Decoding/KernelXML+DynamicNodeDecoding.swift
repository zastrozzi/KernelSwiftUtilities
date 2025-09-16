//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/06/2025.
//

import Foundation

@_documentation(visibility: private)
public protocol _KernelXMLDynamicNodeDecoding: Decodable {
    static func nodeDecoding(for key: CodingKey) -> KernelXML.XMLDecoder.NodeDecoding
}

extension KernelXML {
    public typealias DynamicNodeDecoding = _KernelXMLDynamicNodeDecoding
}
