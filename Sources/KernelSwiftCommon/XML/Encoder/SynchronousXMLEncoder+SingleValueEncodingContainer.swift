//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML.SynchronousXMLEncoder: SingleValueEncodingContainer {
    func assertCanEncodeNewValue() {
        precondition(
            canEncodeNewValue,
            """
            Attempt to encode value through single value container when \
            previously value already encoded.
            """
        )
    }
    
    public func encodeNil() throws {
        assertCanEncodeNewValue()
        storage.push(container: box())
    }
    
    public func encode(_ value: Bool) throws {
        assertCanEncodeNewValue()
        storage.push(container: box(value))
    }
    
    public func encode(_ value: Int) throws {
        assertCanEncodeNewValue()
        storage.push(container: box(value))
    }
    
    public func encode(_ value: Int8) throws {
        assertCanEncodeNewValue()
        storage.push(container: box(value))
    }
    
    public func encode(_ value: Int16) throws {
        assertCanEncodeNewValue()
        storage.push(container: box(value))
    }
    
    public func encode(_ value: Int32) throws {
        assertCanEncodeNewValue()
        storage.push(container: box(value))
    }
    
    public func encode(_ value: Int64) throws {
        assertCanEncodeNewValue()
        storage.push(container: box(value))
    }
    
    public func encode(_ value: UInt) throws {
        assertCanEncodeNewValue()
        storage.push(container: box(value))
    }
    
    public func encode(_ value: UInt8) throws {
        assertCanEncodeNewValue()
        storage.push(container: box(value))
    }
    
    public func encode(_ value: UInt16) throws {
        assertCanEncodeNewValue()
        storage.push(container: box(value))
    }
    
    public func encode(_ value: UInt32) throws {
        assertCanEncodeNewValue()
        storage.push(container: box(value))
    }
    
    public func encode(_ value: UInt64) throws {
        assertCanEncodeNewValue()
        storage.push(container: box(value))
    }
    
    public func encode(_ value: String) throws {
        assertCanEncodeNewValue()
        storage.push(container: box(value))
    }
    
    public func encode(_ value: Float) throws {
        assertCanEncodeNewValue()
        try storage.push(container: box(value))
    }
    
    public func encode(_ value: Double) throws {
        assertCanEncodeNewValue()
        try storage.push(container: box(value))
    }
    
    public func encode<T: Encodable>(_ value: T) throws {
        assertCanEncodeNewValue()
        try storage.push(container: box(value))
    }
}
