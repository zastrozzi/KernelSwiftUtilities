//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelNetworking {
    struct URIUnkeyedEncodingContainer {
        let encoder: URIValueToNodeEncoder
        
        init(encoder: URIValueToNodeEncoder) {
            self.encoder = encoder
            try? encoder.currentStackEntry.storage.markAsArray()
        }
    }
}

extension KernelNetworking.URIUnkeyedEncodingContainer {
    
    private func _appendValue(_ node: KernelNetworking.URIEncodedNode) throws { try encoder.currentStackEntry.storage.append(node) }
    
    private func _appendValue(_ node: KernelNetworking.URIEncodedNode.Primitive) throws { try _appendValue(.primitive(node)) }
    
    private func _appendBinaryFloatingPoint(_ value: some BinaryFloatingPoint) throws {
        try _appendValue(.double(Double(value)))
    }
    
    private func _appendFixedWidthInteger(_ value: some FixedWidthInteger) throws {
        guard let validatedValue = Int(exactly: value) else {
            throw KernelNetworking.URIValueToNodeEncoder.GeneralError.integerOutOfRange
        }
        try _appendValue(.integer(validatedValue))
    }
}

extension KernelNetworking.URIUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    
    var codingPath: [any CodingKey] { encoder.codingPath }
    
    var count: Int {
        switch encoder.currentStackEntry.storage {
        case .array(let array): return array.count
        case .unset: return 0
        default: fatalError("Cannot have an unkeyed container at \(encoder.currentStackEntry).")
        }
    }
    
    func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer { encoder.unkeyedContainer() }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey>
    where NestedKey: CodingKey { encoder.container(keyedBy: NestedKey.self) }
    
    func superEncoder() -> any Encoder { encoder }
    
    func encodeNil() throws { throw KernelNetworking.URIValueToNodeEncoder.GeneralError.nilNotSupported }
    
    func encode(_ value: Bool) throws { try _appendValue(.bool(value)) }
    
    func encode(_ value: String) throws { try _appendValue(.string(value)) }
    
    func encode(_ value: Double) throws { try _appendBinaryFloatingPoint(value) }
    
    func encode(_ value: Float) throws { try _appendBinaryFloatingPoint(value) }
    
    func encode(_ value: Int) throws { try _appendFixedWidthInteger(value) }
    
    func encode(_ value: Int8) throws { try _appendFixedWidthInteger(value) }
    
    func encode(_ value: Int16) throws { try _appendFixedWidthInteger(value) }
    
    func encode(_ value: Int32) throws { try _appendFixedWidthInteger(value) }
    
    func encode(_ value: Int64) throws { try _appendFixedWidthInteger(value) }
    
    func encode(_ value: UInt) throws { try _appendFixedWidthInteger(value) }
    
    func encode(_ value: UInt8) throws { try _appendFixedWidthInteger(value) }
    
    func encode(_ value: UInt16) throws { try _appendFixedWidthInteger(value) }
    
    func encode(_ value: UInt32) throws { try _appendFixedWidthInteger(value) }
    
    func encode(_ value: UInt64) throws { try _appendFixedWidthInteger(value) }
    
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
        case let value as Date: try _appendValue(.date(value))
        default:
            encoder.push(key: .init(intValue: count), newStorage: .unset)
            try value.encode(to: encoder)
            try encoder.pop()
        }
    }
}
