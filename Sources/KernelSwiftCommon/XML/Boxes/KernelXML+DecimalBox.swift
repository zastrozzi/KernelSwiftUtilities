//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML {
    public struct DecimalBox: Equatable {
        public typealias Value = Decimal
        
        public let value: Value
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public init?(xmlString: String) {
            guard let value = Value(string: xmlString) else {
                return nil
            }
            self.init(value)
        }
    }
}

extension KernelXML.DecimalBox: KernelXML.Boxable {
    public var isNull: Bool { false }
    public var xmlString: String? { "\(value)" }
}

extension KernelXML.DecimalBox: KernelXML.SimpleBoxable {}

extension KernelXML.DecimalBox: CustomStringConvertible {
    public var description: String { value.description }
}
