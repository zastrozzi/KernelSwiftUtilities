//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

extension KernelXML {
    public struct DoubleBox: Equatable, KernelXML.ValueBoxable {
        public typealias Value = Double
        
        public let value: Value
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public init?(xmlString: String) {
            guard let value = Double(xmlString) else { return nil }
            self.init(value)
        }
    }
}

extension KernelXML.DoubleBox: KernelXML.Boxable {
    public var isNull: Bool { false }

    public var xmlString: String? {
        guard !value.isNaN else { return "NaN" }
        guard !value.isInfinite else { return (value > 0.0) ? "INF" : "-INF" }
        return value.description
    }
}

extension KernelXML.DoubleBox: KernelXML.SimpleBoxable {}

extension KernelXML.DoubleBox: CustomStringConvertible {
    public var description: String { value.description }
}
