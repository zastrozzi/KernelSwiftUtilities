//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/06/2025.
//

@_documentation(visibility: private)
protocol _KernelXMLOptional {
    init()
}

extension KernelXML {
    typealias XMLOptional = _KernelXMLOptional
}

@_documentation(visibility: private)
extension Optional: KernelXML.XMLOptional {
    internal init() {
        self = nil
    }
}
