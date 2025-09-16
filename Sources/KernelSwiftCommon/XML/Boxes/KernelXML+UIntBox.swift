//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

extension KernelXML {
    public struct UIntBox: Equatable {
        public typealias Value = UInt64
        
        public let value: Value
        
        public init<Unsigned: UnsignedInteger>(_ value: Unsigned) {
            self.value = Value(value)
        }
        
        public init?(xmlString: String) {
            guard let value = Value(xmlString) else {
                return nil
            }
            self.init(value)
        }
        
        public func unbox<Integer: BinaryInteger>() -> Integer? {
            return Integer(exactly: value)
        }
    }
}

extension KernelXML.UIntBox: KernelXML.Boxable {
    public var isNull: Bool { false }
    public var xmlString: String? { value.description }
}

extension KernelXML.UIntBox: KernelXML.SimpleBoxable {}

extension KernelXML.UIntBox: CustomStringConvertible {
    public var description: String { value.description }
}
