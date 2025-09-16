//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/06/2024.
//

import FluentKit
import KernelSwiftCommon

extension Fields {
    public typealias OptionalGroup<Value> = OptionalGroupProperty<Self, Value> where Value: Fields
}

// MARK: Type

@propertyWrapper @dynamicMemberLookup
public final class OptionalGroupProperty<Model, WrappedValue>: @unchecked Sendable
    where Model: Fields, WrappedValue: Fields
{
    public let key: FieldKey
    public var value: WrappedValue??
    
    public var wrappedValue: WrappedValue? {
        get { self.value ?? .none }
        set { self.value = .some(newValue) }
    }
    
    public var projectedValue: OptionalGroupProperty<Model, WrappedValue> {
        return self
    }
    
    public init(key: FieldKey) {
        self.key = key
        self.value = .init()
    }
    
    public subscript<Nested>(
        dynamicMember keyPath: KeyPath<WrappedValue, Nested>
    ) -> OptionalGroupPropertyPath<Model, Nested>
        where Nested: Property
    {
        .init(key: self.key, property: value!![keyPath: keyPath])
    }
}


extension OptionalGroupProperty: CustomStringConvertible {
    public var description: String {
        "@\(Model.self).OptionalGroup<\(WrappedValue.self)>(key: \(self.key))"
    }
}

extension OptionalGroupProperty: AnyProperty { }

extension OptionalGroupProperty: Property { }

extension OptionalGroupProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] {
        WrappedValue.keys.map {
            .prefix(.prefix(self.key, .string("_")), $0)
        }
    }

    private var prefix: FieldKey {
        .prefix(self.key, .string("_"))
    }

    public func input(to input: any DatabaseInput) {
        self.value??.input(to: input.prefixed(by: self.prefix))
    }

    public func output(from output: any DatabaseOutput) throws {
        if self.value == nil { self.value = .init() }
        try? self.value??.output(from: output.prefixed(by: self.prefix))
    }
    
    public var isEmpty: Bool {
        guard let unwrapped = self.wrappedValue else { return true }
        let empty = unwrapped.properties.compactMap { $0.anyValue }.isEmpty
        return empty
    }
    
    public var requiresCreate: Bool {
        guard let unwrapped = self.wrappedValue else { return true }
        return !unwrapped.properties.allSatisfy { property in
            let anyValueNil = property.anyValue == nil
            let expressibleByNilLiteral: Bool = type(of: property).anyValueType is ExpressibleByNilLiteral.Type
            let validField = !(anyValueNil && !expressibleByNilLiteral)
            return validField
        }
    }
}

extension GroupProperty {
    public var requiresCreate: Bool {
        return !wrappedValue.properties.allSatisfy { property in
            let anyValueNil = property.anyValue == nil
            let expressibleByNilLiteral: Bool = type(of: property).anyValueType is ExpressibleByNilLiteral.Type
            let validField = !(anyValueNil && !expressibleByNilLiteral)
            return validField
        }
    }
}

extension OptionalGroupProperty where WrappedValue: KernelFluentCRUDFields {
    public func response() throws -> WrappedValue.ResponseDTO? {
//        let isEmpty = self.wrappedValue?.properties.compactMap { $0.anyValue }.isEmpty ?? true
        return isEmpty ? nil : try self.wrappedValue?.response()
    }
}

extension OptionalGroupProperty: AnyCodableProperty {
    public func encode(to encoder: any Encoder) throws {
        try self.value?.encode(to: encoder)
    }

    public func decode(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self.value = nil
        } else {
            self.value = .some(try container.decode(Value.self))
        }
    }
    
    public var skipPropertyEncoding: Bool { self.value == nil }
}

@dynamicMemberLookup
public final class OptionalGroupPropertyPath<Model, Property>
    where Model: Fields
{
    let key: FieldKey
    let property: Property

    init(key: FieldKey, property: Property) {
        self.key = key
        self.property = property
    }

    public subscript<Nested>(
         dynamicMember keyPath: KeyPath<Property, Nested>
    ) -> OptionalGroupPropertyPath<Model, Nested> {
        .init(
            key: self.key,
            property: self.property[keyPath: keyPath]
        )
    }
}

extension OptionalGroupPropertyPath: AnyProperty
    where Property: AnyProperty
{
    public static var anyValueType: Any.Type {
        Property.anyValueType
    }

    public var anyValue: Any? {
        self.property.anyValue
    }
}

extension OptionalGroupPropertyPath: FluentKit.Property
    where Property: FluentKit.Property
{
    public typealias Model = Property.Model
    public typealias Value = Property.Value

    public var value: Value? {
        get {
            self.property.value
        }
        set {
            self.property.value = newValue
        }
    }
}


extension OptionalGroupPropertyPath: AnyQueryableProperty
    where Property: QueryableProperty
{
    public var path: [FieldKey] {
        let subPath = self.property.path
        return [
            .prefix(.prefix(self.key, .string("_")), subPath[0])
        ] + subPath[1...]
    }
}

extension OptionalGroupPropertyPath: QueryableProperty
    where Property: QueryableProperty
{
    public static func queryValue(_ value: Value) -> DatabaseQuery.Value {
        Property.queryValue(value)
    }
}

extension OptionalGroupPropertyPath: AnyQueryAddressableProperty
    where Property: AnyQueryAddressableProperty
{
    public var anyQueryableProperty: any AnyQueryableProperty {
        self.property.anyQueryableProperty
    }
    
    public var queryablePath: [FieldKey] {
        let subPath = self.property.queryablePath
        return [
            .prefix(.prefix(self.key, .string("_")), subPath[0])
        ] + subPath[1...]
    }
}

extension OptionalGroupPropertyPath: QueryAddressableProperty
    where Property: QueryAddressableProperty
{
    public typealias QueryablePropertyType = Property.QueryablePropertyType
    
    public var queryableProperty: QueryablePropertyType {
        self.property.queryableProperty
    }
}
