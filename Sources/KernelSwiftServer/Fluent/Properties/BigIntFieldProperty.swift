//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/12/2023.
//

import Foundation
import Fluent
import FluentKit
import KernelSwiftCommon

extension Fields {
    public typealias BigIntField = KernelFluentModel.Properties.BigIntFieldProperty<Self>
}

extension KernelFluentModel.Properties {
    @propertyWrapper
    public final class BigIntFieldProperty<Model> where Model: Fields {
        @CustomSerialisableFieldProperty<Model, KernelNumerics.BigInt>
        public var field: KernelNumerics.BigInt
        
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
        
        public var wrappedValue: KernelNumerics.BigInt {
            get {
                guard let value = self.value else { fatalError("Cannot access BigInt field before it is initialised or fetched: \(self.$field.$field.key)") }
                return value
            }
            set {
                self.value = newValue
            }
        }
    }
}

extension KernelFluentModel.Properties.BigIntFieldProperty: Property {
    public var value: KernelNumerics.BigInt? {
        get { self.$field.wrappedValue }
        set { self.$field.wrappedValue = newValue! }
    }
}

extension KernelFluentModel.Properties.BigIntFieldProperty: AnyProperty {}

extension KernelFluentModel.Properties.BigIntFieldProperty: AnyQueryableProperty {
    public var path: [FieldKey] { self.$field.path }
}

extension KernelFluentModel.Properties.BigIntFieldProperty: QueryableProperty {}

extension KernelFluentModel.Properties.BigIntFieldProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: AnyQueryableProperty { self }
    public var queryablePath: [FieldKey] { self.path }
}

extension KernelFluentModel.Properties.BigIntFieldProperty: QueryAddressableProperty {
    public var queryableProperty: KernelFluentModel.Properties.BigIntFieldProperty<Model> { self }
}

extension KernelFluentModel.Properties.BigIntFieldProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] { self.$field.keys }
    public func input(to input: DatabaseInput) { self.$field.input(to: input) }
    public func output(from output: DatabaseOutput) throws { try self.$field.output(from: output) }
}

extension KernelFluentModel.Properties.BigIntFieldProperty: AnyCodableProperty {
    public func encode(to encoder: Encoder) throws {
        fatalError("Cannot encode field: \(self.$field.$field.key)")
    }
    
    public func decode(from decoder: Decoder) throws {
        fatalError("Cannot decode field: \(self.$field.$field.key)")
    }
}
