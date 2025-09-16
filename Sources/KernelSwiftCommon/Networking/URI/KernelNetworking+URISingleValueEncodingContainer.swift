//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelNetworking {
    struct URISingleValueEncodingContainer {
        let encoder: URIValueToNodeEncoder
    }
}

extension KernelNetworking.URISingleValueEncodingContainer {
    
    private func _setValue(
        _ node: KernelNetworking.URIEncodedNode.Primitive
    ) throws { try encoder.currentStackEntry.storage.set(node) }
    
    private func _setBinaryFloatingPoint(_ value: some BinaryFloatingPoint) throws {
        try _setValue(.double(Double(value)))
    }
    
    private func _setFixedWidthInteger(_ value: some FixedWidthInteger) throws {
        guard let validatedValue = Int(exactly: value) else {
            throw KernelNetworking.URIValueToNodeEncoder.GeneralError.integerOutOfRange
        }
        try _setValue(.integer(validatedValue))
    }
}

extension KernelNetworking.URISingleValueEncodingContainer: SingleValueEncodingContainer {
    
    var codingPath: [any CodingKey] { encoder.codingPath }
    
    func encodeNil() throws { }
    
    func encode(_ value: Bool) throws { try _setValue(.bool(value)) }
    
    func encode(_ value: String) throws { try _setValue(.string(value)) }
    
    func encode(_ value: Double) throws { try _setBinaryFloatingPoint(value) }
    
    func encode(_ value: Float) throws { try _setBinaryFloatingPoint(value) }
    
    func encode(_ value: Int) throws { try _setFixedWidthInteger(value) }
    
    func encode(_ value: Int8) throws { try _setFixedWidthInteger(value) }
    
    func encode(_ value: Int16) throws { try _setFixedWidthInteger(value) }
    
    func encode(_ value: Int32) throws { try _setFixedWidthInteger(value) }
    
    func encode(_ value: Int64) throws { try _setFixedWidthInteger(value) }
    
    func encode(_ value: UInt) throws { try _setFixedWidthInteger(value) }
    
    func encode(_ value: UInt8) throws { try _setFixedWidthInteger(value) }
    
    func encode(_ value: UInt16) throws { try _setFixedWidthInteger(value) }
    
    func encode(_ value: UInt32) throws { try _setFixedWidthInteger(value) }
    
    func encode(_ value: UInt64) throws { try _setFixedWidthInteger(value) }
    
    func encode<T>(_ value: T) throws where T: Encodable {
        switch value {
        case let value as UInt8: try encode(value)
        case let value as Int8: try encode(value)
        case let value as UInt16: try encode(value)
        case let value as Int16: try encode(value)
        case let value as UInt32: try encode(value)
        case let value as Int32: try encode(value)
        case let value as UInt64: try encode(value)
        case let value as Int64: try encode(value)
        case let value as Int: try encode(value)
        case let value as UInt: try encode(value)
        case let value as Float: try encode(value)
        case let value as Double: try encode(value)
        case let value as String: try encode(value)
        case let value as Bool: try encode(value)
        case let value as Date: try _setValue(.date(value))
        default: try value.encode(to: encoder)
        }
    }
}
