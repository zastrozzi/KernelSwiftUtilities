//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

extension KernelXML {
    public struct FloatBox: Equatable, KernelXML.ValueBoxable {
        public typealias Value = Float
        
        public let value: Value
        
        public init<Float: BinaryFloatingPoint>(_ value: Float) {
            self.value = .init(value)
        }
        
        public init?(xmlString: String) {
            guard let value = Value(xmlString) else {
                return nil
            }
            self.init(value)
        }
    }
}

extension KernelXML.FloatBox: KernelXML.Boxable {
    public var isNull: Bool { false }
    
    public var xmlString: String? {
        guard !value.isNaN else { return "NaN" }
        guard !value.isInfinite else { return (value > 0.0) ? "INF" : "-INF" }
        return value.description
    }
}

extension KernelXML.FloatBox: KernelXML.SimpleBoxable {}

extension KernelXML.FloatBox: CustomStringConvertible {
    public var description: String { value.description }
}
