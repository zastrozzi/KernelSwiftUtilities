//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

@_documentation(visibility: private)
public protocol _KernelXMLDynamicNodeEncoding: Encodable {
    static func nodeEncoding(for key: CodingKey) -> KernelXML.XMLEncoder.NodeEncoding
}

extension KernelXML {
    public typealias DynamicNodeEncoding = _KernelXMLDynamicNodeEncoding
}

extension Array: KernelXML.DynamicNodeEncoding where Element: KernelXML.DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> KernelXML.XMLEncoder.NodeEncoding {
        return Element.nodeEncoding(for: key)
    }
}

extension KernelXML.DynamicNodeEncoding where Self: Collection, Self.Iterator.Element: KernelXML.DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> KernelXML.XMLEncoder.NodeEncoding {
        return Element.nodeEncoding(for: key)
    }
}
