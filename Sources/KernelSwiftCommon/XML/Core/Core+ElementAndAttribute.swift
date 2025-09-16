//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

@_documentation(visibility: private)
public protocol _KernelXMLElementAndAttributeRepresentable {}

extension KernelXML {
    public typealias ElementAndAttributeRepresentable = _KernelXMLElementAndAttributeRepresentable
}

extension KernelXML {
    @propertyWrapper
    public struct ElementAndAttribute<Value>: KernelXML.ElementAndAttributeRepresentable {
        public var wrappedValue: Value
        
        public init(_ wrappedValue: Value) {
            self.wrappedValue = wrappedValue
        }
    }
}

extension KernelXML.ElementAndAttribute: Codable where Value: Codable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        try wrappedValue = .init(from: decoder)
    }
}

extension KernelXML.ElementAndAttribute: Equatable where Value: Equatable {}
extension KernelXML.ElementAndAttribute: Hashable where Value: Hashable {}
extension KernelXML.ElementAndAttribute: Sendable where Value: Sendable {}
