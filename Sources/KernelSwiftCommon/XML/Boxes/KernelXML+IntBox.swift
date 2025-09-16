//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

extension KernelXML {
    public struct IntBox: Equatable {
        public typealias Value = Int64
        
        public let value: Value
        
        public init<Integer: SignedInteger>(_ value: Integer) {
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

extension KernelXML.IntBox: KernelXML.Boxable {
    public var isNull: Bool { false }
    public var xmlString: String? { value.description }
}

extension KernelXML.IntBox: KernelXML.SimpleBoxable {}

extension KernelXML.IntBox: CustomStringConvertible {
    public var description: String { value.description }
}
