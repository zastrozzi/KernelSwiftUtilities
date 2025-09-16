//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 07/11/2024.
//

import Fluent
import Foundation

extension Model {
    public func require<Field, Value>(_ field: KeyPath<Self, Field>) throws -> Value where Field: Property, Field.Value == Optional<Value> {
        guard let fieldValue = self[keyPath: field].value, let value = fieldValue else {
            throw FluentError.missingField(name: field.stringValue)
        }
        return value
    }
    
    public func require<Value>(_ field: KeyPath<Self, Value?>) throws -> Value {
        guard let fieldValue = self[keyPath: field] else {
            throw FluentError.missingField(name: field.stringValue)
        }
        return fieldValue
    }
}
