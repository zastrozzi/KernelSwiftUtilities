//
//  File.swift
//
//
//  Created by Jonathan Forbes on 12/6/24.
//

import Foundation
import FluentKit

extension Fields {
    public typealias OptionalKernelEnum<Value> = OptionalKernelEnumProperty<Self, Value>
    where Value: FluentEnumConvertible
}

// MARK: Type

@propertyWrapper
public final class OptionalKernelEnumProperty<Model, WrappedValue>
    where Model: FluentKit.Fields,
          WrappedValue: FluentEnumConvertible
{
    public let field: OptionalFieldProperty<Model, String>

    public var projectedValue: OptionalKernelEnumProperty<Model, WrappedValue> {
        return self
    }

    public var wrappedValue: WrappedValue? {
        get {
            self.value ?? nil
        }
        set {
            self.value = .some(newValue)
        }
    }

    public init(key: FieldKey) {
        self.field = .init(key: key)
    }
}

// MARK: Property

extension OptionalKernelEnumProperty: AnyProperty { }

extension OptionalKernelEnumProperty: Property {
    public var value: WrappedValue?? {
        get {
            self.field.value.map {
                $0.map {
                    WrappedValue(rawValue: $0)!
                }
            }
        }
        set {
            switch newValue {
            case .some(.some(let newValue)):
                self.field.value = .some(.some(newValue.rawValue))
            case .some(.none):
                self.field.value = .some(.none)
            case .none:
                self.field.value = .none
            }
        }
    }
}

// MARK: Queryable

extension OptionalKernelEnumProperty: AnyQueryableProperty {
    public var path: [FieldKey] {
        self.field.path
    }
}

extension OptionalKernelEnumProperty: QueryableProperty {
    public static func queryValue(_ value: Value) -> DatabaseQuery.Value {
        value.flatMap { .enumCase($0.rawValue) } ?? .null
    }
}

// MARK: Query-addressable

extension OptionalKernelEnumProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: any AnyQueryableProperty { self }
    public var queryablePath: [FieldKey] { self.path }
}

extension OptionalKernelEnumProperty: QueryAddressableProperty {
    public var queryableProperty: OptionalKernelEnumProperty<Model, WrappedValue> { self }
}

// MARK: Database

extension OptionalKernelEnumProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] {
        self.field.keys
    }

    public func input(to input: any DatabaseInput) {
//        let value: DatabaseQuery.Value
        if let value = self.field.value {
            if let unwrapped = value {
                input.set(.enumCase(unwrapped), at: self.field.key)
            } else {
                if input.wantsUnmodifiedKeys { input.set(.null, at: self.field.key) }
                else { return }
            }
            
        } else {
            if input.wantsUnmodifiedKeys { input.set(.default, at: self.field.key) }
            else { return }
        }
    }

    public func output(from output: any DatabaseOutput) throws {
        try self.field.output(from: output)
    }
}

// MARK: Codable

extension OptionalKernelEnumProperty: AnyCodableProperty {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }

    public func decode(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self.value = nil
        } else {
            self.value = try container.decode(Value.self)
        }
    }
}
