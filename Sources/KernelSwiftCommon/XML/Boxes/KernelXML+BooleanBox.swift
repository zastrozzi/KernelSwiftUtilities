//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/06/2025.
//

extension KernelXML {
    public struct BooleanBox: Equatable {
        public typealias Value = Bool
        
        public let value: Value
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public init?(xmlString: String) {
            switch xmlString.lowercased() {
            case "false", "0", "n", "no": self.init(false)
            case "true", "1", "y", "yes": self.init(true)
            default: return nil
            }
        }
    }
}

extension KernelXML.BooleanBox: KernelXML.Boxable {
    public var isNull: Bool { false }
    public var xmlString: String? { value ? "true" : "false" }
}

extension KernelXML.BooleanBox: KernelXML.SimpleBoxable {}

extension KernelXML.BooleanBox: CustomStringConvertible {
    public var description: String { value.description }
}
