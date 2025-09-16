//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/12/2023.
//

import Foundation
import Fluent
import FluentKit

extension Fields {
    public typealias ASN1Field<ASN1Value> = KernelFluentModel.Properties.ASN1FieldProperty<Self, ASN1Value> where ASN1Value: ASN1Decodable & ASN1Buildable & Sendable
}

extension KernelFluentModel.Properties {
    @propertyWrapper
    public final class ASN1FieldProperty<Model, ASN1Value> where Model: Fields, ASN1Value: ASN1Decodable & ASN1Buildable & Sendable {
        @CustomSerialisableFieldProperty<Model, ASN1Value>
        public var field: ASN1Value
        
        public init(key: FieldKey) {
            self._field = .init(
                key: key,
                serialiser: { wrappedValue in
                        .init(wrappedValue.buildASN1Type().serialise())
                },
                deserialiser: { wrappedValue in
                    guard let parsed = try? KernelASN1.ASN1Parser4.objectFromBytes(wrappedValue.copyBytes()) else { throw KernelASN1.TypedError(.decodingFailed) }
                    return try KernelASN1.ASN1Decoder.decode(from: parsed)
                }
            )
        }
        
        public var wrappedValue: ASN1Value {
            get {
                guard let value = self.value else { fatalError("Cannot access field before it is initialised or fetched: \(self.$field.$field.key)") }
                return value
            }
            set {
                self.value = newValue
            }
        }
    }
}

extension KernelFluentModel.Properties.ASN1FieldProperty: Property {
    public var value: ASN1Value? {
        get { self.$field.wrappedValue }
        set { self.$field.wrappedValue = newValue! }
    }
}

extension KernelFluentModel.Properties.ASN1FieldProperty: AnyProperty {}

extension KernelFluentModel.Properties.ASN1FieldProperty: AnyQueryableProperty {
    public var path: [FieldKey] { self.$field.path }
}

extension KernelFluentModel.Properties.ASN1FieldProperty: QueryableProperty {}

extension KernelFluentModel.Properties.ASN1FieldProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: AnyQueryableProperty { self }
    public var queryablePath: [FieldKey] { self.path }
}

extension KernelFluentModel.Properties.ASN1FieldProperty: QueryAddressableProperty {
    public var queryableProperty: KernelFluentModel.Properties.ASN1FieldProperty<Model, ASN1Value> { self }
}

extension KernelFluentModel.Properties.ASN1FieldProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] { self.$field.keys }
    public func input(to input: DatabaseInput) { self.$field.input(to: input) }
    public func output(from output: DatabaseOutput) throws { try self.$field.output(from: output) }
}

extension KernelFluentModel.Properties.ASN1FieldProperty: AnyCodableProperty {
    public func encode(to encoder: Encoder) throws {
        fatalError("Cannot encode field: \(self.$field.$field.key)")
    }
    
    public func decode(from decoder: Decoder) throws {
        fatalError("Cannot decode field: \(self.$field.$field.key)")
    }
}
