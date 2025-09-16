//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/12/2023.
//

import Foundation
import Fluent

extension Fields {
    public typealias CustomSerialisableField<SerialisableValue> = KernelFluentModel.Properties.CustomSerialisableFieldProperty<Self, SerialisableValue>
}

extension KernelFluentModel.Properties {
    
    @propertyWrapper
    public final class CustomSerialisableFieldProperty<Model, SerialisableValue> where Model: FluentKit.Fields {
        
        
        @FieldProperty<Model, Data>
        public var field: Data
        
        public let serialiser: (_ wrappedValue: SerialisableValue) -> Data
        public let deserialiser: (_ wrappedValue: Data) throws -> SerialisableValue

        public var projectedValue: CustomSerialisableFieldProperty<Model, SerialisableValue> { self }
        
        public var wrappedValue: SerialisableValue {
            get {
                guard let value = self.value else {
                    fatalError("Cannot access field before it is initialized or fetched: \(self.$field.key)")
                }
                guard let deserialisedValue = try? deserialiser(value) else {
                    fatalError("Cannot deserialise field: \(self.$field.key)")
                }
                return deserialisedValue
            }
            set {
                self.value = serialiser(newValue)
            }
        }
        
        public init(
            key: FieldKey,
            serialiser: @escaping (_ wrappedValue: SerialisableValue) -> Data,
            deserialiser: @escaping (_ wrappedValue: Data) throws -> SerialisableValue
        ) {
            self._field = .init(key: key)
            self.serialiser = serialiser
            self.deserialiser = deserialiser
        }
    }
}

extension KernelFluentModel.Properties.CustomSerialisableFieldProperty: Property {
    public var value: Data? {
        get { self.$field.value }
        set { self.$field.value = newValue }
    }
}

extension KernelFluentModel.Properties.CustomSerialisableFieldProperty: AnyProperty {}

extension KernelFluentModel.Properties.CustomSerialisableFieldProperty: AnyQueryableProperty {
    public var path: [FieldKey] { self.$field.path }
}

extension KernelFluentModel.Properties.CustomSerialisableFieldProperty: QueryableProperty {}

extension KernelFluentModel.Properties.CustomSerialisableFieldProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: AnyQueryableProperty { self }
    public var queryablePath: [FieldKey] { self.path }
}

extension KernelFluentModel.Properties.CustomSerialisableFieldProperty: QueryAddressableProperty {
    public var queryableProperty: KernelFluentModel.Properties.CustomSerialisableFieldProperty<Model, SerialisableValue> { self }
}

extension KernelFluentModel.Properties.CustomSerialisableFieldProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] { self.$field.keys }
    public func input(to input: DatabaseInput) { self.$field.input(to: input) }
    public func output(from output: DatabaseOutput) throws { try self.$field.output(from: output) }
}
//
//extension AsyncTransformableFieldProperty: AnyCodableProperty {
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(self.wrappedValue)
//    }
//    
//    public func decode(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        self.value = try container.decode(Value.self)
//    }
//}
//
