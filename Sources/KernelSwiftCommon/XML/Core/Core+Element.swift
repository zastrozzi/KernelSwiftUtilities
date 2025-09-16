//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

@_documentation(visibility: private)
public protocol _KernelXMLElementRepresentable {}

extension KernelXML {
    public typealias ElementRepresentable = _KernelXMLElementRepresentable
}

extension KernelXML {
    @propertyWrapper
    public struct Element<Value>: KernelXML.ElementRepresentable {
        public var wrappedValue: Value
        
        public init(_ wrappedValue: Value) {
            self.wrappedValue = wrappedValue
        }
    }
}

extension KernelXML.Element: Codable where Value: Codable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        try wrappedValue = .init(from: decoder)
    }
}

extension KernelXML.Element: Equatable where Value: Equatable {}
extension KernelXML.Element: Hashable where Value: Hashable {}
extension KernelXML.Element: Sendable where Value: Sendable {}
