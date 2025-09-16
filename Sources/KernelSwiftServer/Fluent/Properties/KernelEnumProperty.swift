//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/5/24.
//

import Foundation
import FluentKit

extension Fields {
    public typealias KernelEnum<Value> = KernelEnumProperty<Self, Value> where Value: FluentEnumConvertible
}

// MARK: Type

@propertyWrapper
public final class KernelEnumProperty<Model, Value>
    where Model: FluentKit.Fields, Value: FluentEnumConvertible
{
    public let field: FieldProperty<Model, String>

    public var projectedValue: KernelEnumProperty<Model, Value> {
        return self
    }

    public var wrappedValue: Value {
        get {
            guard let value = self.value else {
                fatalError("Cannot access enum field before it is initialized or fetched: \(self.field.key)")
            }
            return value
        }
        set {
            self.value = newValue
        }
    }

    public init(key: FieldKey) {
        self.field = .init(key: key)
    }
}

// MARK: Property

extension KernelEnumProperty: AnyProperty { }

extension KernelEnumProperty: Property {
    public var value: Value? {
        get {
            guard let fieldValue = self.field.value else { return nil }
            return Value(rawValue: fieldValue)
        }
        set {
            self.field.value = newValue?.rawValue
        }
    }
}

// MARK: Queryable

extension KernelEnumProperty: AnyQueryableProperty {
    public var path: [FieldKey] {
        self.field.path
    }
}

extension KernelEnumProperty: QueryableProperty {
    public static func queryValue(_ value: Value) -> DatabaseQuery.Value {
        .enumCase(value.rawValue)
    }
}

// MARK: Query-addressable

extension KernelEnumProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: any AnyQueryableProperty { self }
    public var queryablePath: [FieldKey] { self.path }
}

extension KernelEnumProperty: QueryAddressableProperty {
    public var queryableProperty: KernelEnumProperty<Model, Value> { self }
}

// MARK: Database

extension KernelEnumProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] {
        self.field.keys
    }

    public func input(to input: any DatabaseInput) {
        if let value = self.field.value {
            input.set(.enumCase(value), at: self.field.key)
        } else {
            input.set(.default, at: self.field.key)
        }
    }

    public func output(from output: any DatabaseOutput) throws {
        try self.field.output(from: output)
    }
}

// MARK: Codable

extension KernelEnumProperty: AnyCodableProperty {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }

    public func decode(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(Value.self)
    }
}

