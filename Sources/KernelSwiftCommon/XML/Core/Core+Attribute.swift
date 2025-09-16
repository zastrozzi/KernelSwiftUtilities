//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/06/2025.
//

@_documentation(visibility: private)
public protocol _KernelXMLAttributable {}

@_documentation(visibility: private)
protocol _KernelXMLOptionalAttributable: _KernelXMLAttributable {
    init()
}

extension KernelXML {
    public typealias Attributable = _KernelXMLAttributable
    typealias OptionalAttributable = _KernelXMLOptionalAttributable
}

extension KernelXML {
    @propertyWrapper
    public struct Attribute<Value>: Attributable {
        public var wrappedValue: Value
        public init(_ wrappedValue: Value) {
            self.wrappedValue = wrappedValue
        }
    }
}

extension KernelXML.Attribute: Codable where Value: Codable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        try wrappedValue = .init(from: decoder)
    }
}

extension KernelXML.Attribute: Equatable where Value: Equatable {}
extension KernelXML.Attribute: Hashable where Value: Hashable {}
extension KernelXML.Attribute: Sendable where Value: Sendable {}

extension KernelXML.Attribute: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Value.IntegerLiteralType
    
    public init(integerLiteral value: Value.IntegerLiteralType) {
        wrappedValue = Value(integerLiteral: value)
    }
}

extension KernelXML.Attribute: ExpressibleByUnicodeScalarLiteral where Value: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Value.UnicodeScalarLiteralType) {
        wrappedValue = Value(unicodeScalarLiteral: value)
    }
    
    public typealias UnicodeScalarLiteralType = Value.UnicodeScalarLiteralType
}

extension KernelXML.Attribute: ExpressibleByExtendedGraphemeClusterLiteral where Value: ExpressibleByExtendedGraphemeClusterLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = Value.ExtendedGraphemeClusterLiteralType
    
    public init(extendedGraphemeClusterLiteral value: Value.ExtendedGraphemeClusterLiteralType) {
        wrappedValue = Value(extendedGraphemeClusterLiteral: value)
    }
}

extension KernelXML.Attribute: ExpressibleByStringLiteral where Value: ExpressibleByStringLiteral {
    public typealias StringLiteralType = Value.StringLiteralType
    
    public init(stringLiteral value: Value.StringLiteralType) {
        wrappedValue = Value(stringLiteral: value)
    }
}

extension KernelXML.Attribute: ExpressibleByBooleanLiteral where Value: ExpressibleByBooleanLiteral {
    public typealias BooleanLiteralType = Value.BooleanLiteralType
    
    public init(booleanLiteral value: Value.BooleanLiteralType) {
        wrappedValue = Value(booleanLiteral: value)
    }
}

extension KernelXML.Attribute: ExpressibleByNilLiteral where Value: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        wrappedValue = Value(nilLiteral: ())
    }
}

extension KernelXML.Attribute: KernelXML.OptionalAttributable where Value: KernelXML.XMLOptional {
    init() {
        wrappedValue = Value()
    }
}
