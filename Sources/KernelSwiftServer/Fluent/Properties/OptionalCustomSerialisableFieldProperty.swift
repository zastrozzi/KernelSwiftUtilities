//
//  File.swift
//
//
//  Created by Jonathan Forbes on 03/12/2023.
//

import Foundation
import Fluent

extension Fields {
    public typealias OptionalCustomSerialisableField<SerialisableValue> = KernelFluentModel.Properties.OptionalCustomSerialisableFieldProperty<Self, SerialisableValue>
}

extension KernelFluentModel.Properties {
    
    @propertyWrapper
    public final class OptionalCustomSerialisableFieldProperty<Model, SerialisableValue> where Model: FluentKit.Fields {
        
        
        @OptionalFieldProperty<Model, Data>
        public var field: Data?
        
        public let serialiser: (_ wrappedValue: SerialisableValue) -> Data
        public let deserialiser: (_ wrappedValue: Data) throws -> SerialisableValue
        
        public var projectedValue: OptionalCustomSerialisableFieldProperty<Model, SerialisableValue> { self }
        
        public var wrappedValue: SerialisableValue? {
            get {
                guard let value = self.value else { return nil }
                guard let value else { return nil }
                guard let deserialisedValue = try? deserialiser(value) else { return nil }
                return deserialisedValue
            }
            set {
                if let newValue { self.value = serialiser(newValue) }
                else { self.value = nil }
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

extension KernelFluentModel.Properties.OptionalCustomSerialisableFieldProperty: Property {
    public var value: Data?? {
        get { self.$field.value }
        set { self.$field.value = newValue }
    }
}

extension KernelFluentModel.Properties.OptionalCustomSerialisableFieldProperty: AnyProperty {}

extension KernelFluentModel.Properties.OptionalCustomSerialisableFieldProperty: AnyQueryableProperty {
    public var path: [FieldKey] { self.$field.path }
}

extension KernelFluentModel.Properties.OptionalCustomSerialisableFieldProperty: QueryableProperty {}

extension KernelFluentModel.Properties.OptionalCustomSerialisableFieldProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: AnyQueryableProperty { self }
    public var queryablePath: [FieldKey] { self.path }
}

extension KernelFluentModel.Properties.OptionalCustomSerialisableFieldProperty: QueryAddressableProperty {
    public var queryableProperty: KernelFluentModel.Properties.OptionalCustomSerialisableFieldProperty<Model, SerialisableValue> { self }
}

extension KernelFluentModel.Properties.OptionalCustomSerialisableFieldProperty: AnyDatabaseProperty {
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
