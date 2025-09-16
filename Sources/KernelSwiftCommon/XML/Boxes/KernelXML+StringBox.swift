//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

extension KernelXML {
    public struct StringBox: Equatable {
        public typealias Value = String
        
        public let value: Value
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public init(xmlString: Value) {
            self.init(xmlString)
        }
    }
}

extension KernelXML.StringBox: KernelXML.Boxable {
    public var isNull: Bool { false }
    public var xmlString: String? { value.description }
}

extension KernelXML.StringBox: KernelXML.SimpleBoxable {}

extension KernelXML.StringBox: CustomStringConvertible {
    public var description: String { value.description }
}
