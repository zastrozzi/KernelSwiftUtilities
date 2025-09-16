//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 07/02/2025.
//

import Foundation
import Fluent

public protocol FluentSerialisationSchema: Codable, Sendable {
    associatedtype SerialisableValue: Codable, Sendable
    func serialise(_ value: SerialisableValue) throws -> Data
    func deserialise(_ data: Data) throws -> SerialisableValue
}

public struct FluentSerialisationContainer<SerialisationSchema: FluentSerialisationSchema> {
    public var schema: SerialisationSchema
    public var value: SerialisationSchema.SerialisableValue
    
    public init(schema: SerialisationSchema, value: SerialisationSchema.SerialisableValue) {
        self.schema = schema
        self.value = value
    }
}

extension Fields {
    public typealias SchemaSerialisableField<SerialisationSchema: FluentSerialisationSchema> = KernelFluentModel.Properties.SchemaSerialisableFieldProperty<Self, SerialisationSchema>
}

extension KernelFluentModel.Properties {
    
    @propertyWrapper
    public final class SchemaSerialisableFieldProperty<Model, SerialisationSchema> where Model: FluentKit.Fields, SerialisationSchema: FluentSerialisationSchema {
        @FieldProperty<Model, Data>
        public var field: Data
        
        @FieldProperty<Model, SerialisationSchema>
        public var serialiser: SerialisationSchema
        
        
//        public let serialiser: (_ wrappedValue: SerialisableValue) -> Data
//        public let deserialiser: (_ wrappedValue: Data) throws -> SerialisableValue
        
        public var projectedValue: SchemaSerialisableFieldProperty<Model, SerialisationSchema> { self }
        
        public var wrappedValue: FluentSerialisationContainer<SerialisationSchema> {
            get {
                guard let value = self.value else {
                    fatalError("Cannot access field before it is initialized or fetched: \(self.$field.key)")
                }
                guard let serialiserValue = self.serialiserValue else {
                    fatalError("Cannot access field before it is initialized or fetched: \(self.$serialiser.key)")
                }
                guard let deserialisedValue = try? serialiserValue.deserialise(value) else {
                    fatalError("Cannot deserialise field: \(self.$field.key)")
                }
                return .init(schema: serialiserValue, value: deserialisedValue)
            }
            set {
                guard let serialisedValue = try? newValue.schema.serialise(newValue.value) else {
                    fatalError("Cannot serialise field: \(self.$field.key)")
                }
                self.value = serialisedValue
                self.serialiserValue = newValue.schema
            }
        }
        
        public init(
            key: FieldKey,
            schemaKey: FieldKey
        ) {
            self._field = .init(key: key)
            self._serialiser = .init(key: schemaKey)
        }
    }
}

extension KernelFluentModel.Properties.SchemaSerialisableFieldProperty: Property {
    public var value: Data? {
        get { self.$field.value }
        set { self.$field.value = newValue }
    }
    
    public var serialiserValue: SerialisationSchema? {
        get { self.$serialiser.value }
        set { self.$serialiser.value = newValue }
    }
}

extension KernelFluentModel.Properties.SchemaSerialisableFieldProperty: AnyProperty {}

extension KernelFluentModel.Properties.SchemaSerialisableFieldProperty: AnyQueryableProperty {
    public var path: [FieldKey] { self.$field.path }
}

extension KernelFluentModel.Properties.SchemaSerialisableFieldProperty: QueryableProperty {}

extension KernelFluentModel.Properties.SchemaSerialisableFieldProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: AnyQueryableProperty { self }
    public var queryablePath: [FieldKey] { self.path }
}

extension KernelFluentModel.Properties.SchemaSerialisableFieldProperty: QueryAddressableProperty {
    public var queryableProperty: KernelFluentModel.Properties.SchemaSerialisableFieldProperty<Model, SerialisationSchema> { self }
}

extension KernelFluentModel.Properties.SchemaSerialisableFieldProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] { self.$field.keys }
    public func input(to input: DatabaseInput) {
        self.$field.input(to: input)
//        self.$serialiser.input(to: input)
    }
    public func output(from output: DatabaseOutput) throws {
        try self.$field.output(from: output)
//        try self.$serialiser.output(from: output)
    }
}
