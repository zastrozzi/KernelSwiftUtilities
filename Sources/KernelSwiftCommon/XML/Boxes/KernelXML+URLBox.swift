//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML {
    public struct URLBox: Equatable {
        public typealias Value = URL
        
        public let value: Value
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public init?(xmlString: String) {
            guard let value = Value(string: xmlString) else { return nil }
            self.init(value)
        }
    }
}

extension KernelXML.URLBox: KernelXML.Boxable {
    public var isNull: Bool { false }
    public var xmlString: String? { value.absoluteString }
}

extension KernelXML.URLBox: KernelXML.SimpleBoxable {}

extension KernelXML.URLBox: CustomStringConvertible {
    public var description: String { value.description }
}
