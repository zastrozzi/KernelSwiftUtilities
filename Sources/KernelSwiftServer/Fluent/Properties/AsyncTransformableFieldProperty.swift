//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/05/2023.
//

import Foundation
import Fluent

extension Fields {
    public typealias AsyncTransformableField<Value, TransformedValue> = AsyncTransformableFieldProperty<Self, Value, TransformedValue> where Value: Codable & Sendable
}

@propertyWrapper
public final class AsyncTransformableFieldProperty<Model, Value, TransformedValue> where Model: FluentKit.Fields, Value: Codable & Sendable {
   
    
    @FieldProperty<Model, Value>
    public var field: Value
    
    public let transformer: (_ wrappedValue: Value) async throws -> (TransformedValue?)
    
    public func asyncTransformed() async throws -> TransformedValue? {
        try await self.transformer(self.wrappedValue)
    }
    public var projectedValue: AsyncTransformableFieldProperty<Model, Value, TransformedValue> { self }

    public var wrappedValue: Value {
        get {
            guard let value = self.value else {
                fatalError("Cannot access field before it is initialized or fetched: \(self.$field.key)")
            }
            return value
        }
        set {
            self.value = newValue
        }
    }

    public init(key: FieldKey, transformer: @escaping (_ wrappedValue: Value) async throws -> (TransformedValue?)) {
        self._field = .init(key: key)
        self.transformer = transformer
    }
}

extension AsyncTransformableFieldProperty: Property {
    public var value: Value? {
        get { self.$field.value }
        set { self.$field.value = newValue }
    }
}

extension AsyncTransformableFieldProperty: AnyProperty {}

extension AsyncTransformableFieldProperty: AnyQueryableProperty {
    public var path: [FieldKey] { self.$field.path }
}

extension AsyncTransformableFieldProperty: QueryableProperty {}

extension AsyncTransformableFieldProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: AnyQueryableProperty { self }
    public var queryablePath: [FieldKey] { self.path }
}

extension AsyncTransformableFieldProperty: QueryAddressableProperty {
    public var queryableProperty: AsyncTransformableFieldProperty<Model, Value, TransformedValue> { self }
}

extension AsyncTransformableFieldProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] { self.$field.keys }
    public func input(to input: DatabaseInput) { self.$field.input(to: input) }
    public func output(from output: DatabaseOutput) throws { try self.$field.output(from: output) }
}

extension AsyncTransformableFieldProperty: AnyCodableProperty {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }

    public func decode(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(Value.self)
    }
}
