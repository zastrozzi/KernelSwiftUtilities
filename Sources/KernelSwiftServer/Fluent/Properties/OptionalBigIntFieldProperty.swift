//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/12/2023.
//

import Foundation
import Fluent
import FluentKit
import KernelSwiftCommon

extension Fields {
    public typealias OptionalBigIntField = KernelFluentModel.Properties.OptionalBigIntFieldProperty<Self>
}

extension KernelFluentModel.Properties {
    @propertyWrapper
    public final class OptionalBigIntFieldProperty<Model> where Model: Fields {
        @OptionalCustomSerialisableFieldProperty<Model, KernelNumerics.BigInt>
        public var field: KernelNumerics.BigInt?
        
        public init(key: FieldKey) {
            self._field = .init(
                key: key,
                serialiser: { wrappedValue in
                    .init(wrappedValue.signedBytes())
                },
                deserialiser: { wrappedValue in
                    .init(signedBytes: wrappedValue.copyBytes())
                }
            )
        }
        
        public var wrappedValue: KernelNumerics.BigInt? {
            get {
                guard let value = self.value else { return nil }
                guard let value else { return nil }
                return value
            }
            set {
                self.value = newValue
            }
        }
    }
}

extension KernelFluentModel.Properties.OptionalBigIntFieldProperty: Property {
    public var value: KernelNumerics.BigInt?? {
        get { self.$field.wrappedValue }
        set { self.$field.wrappedValue = newValue! }
    }
}

extension KernelFluentModel.Properties.OptionalBigIntFieldProperty: AnyProperty {}

extension KernelFluentModel.Properties.OptionalBigIntFieldProperty: AnyQueryableProperty {
    public var path: [FieldKey] { self.$field.path }
}

extension KernelFluentModel.Properties.OptionalBigIntFieldProperty: QueryableProperty {}

extension KernelFluentModel.Properties.OptionalBigIntFieldProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: AnyQueryableProperty { self }
    public var queryablePath: [FieldKey] { self.path }
}

extension KernelFluentModel.Properties.OptionalBigIntFieldProperty: QueryAddressableProperty {
    public var queryableProperty: KernelFluentModel.Properties.OptionalBigIntFieldProperty<Model> { self }
}

extension KernelFluentModel.Properties.OptionalBigIntFieldProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] { self.$field.keys }
    public func input(to input: DatabaseInput) { self.$field.input(to: input) }
    public func output(from output: DatabaseOutput) throws { try self.$field.output(from: output) }
}

extension KernelFluentModel.Properties.OptionalBigIntFieldProperty: AnyCodableProperty {
    public func encode(to encoder: Encoder) throws {
        fatalError("Cannot encode field: \(self.$field.$field.key)")
    }
    
    public func decode(from decoder: Decoder) throws {
        fatalError("Cannot decode field: \(self.$field.$field.key)")
    }
}
