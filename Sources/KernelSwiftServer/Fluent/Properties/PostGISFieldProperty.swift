//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/10/2024.
//

import Foundation
import Fluent
import FluentKit
import KernelSwiftCommon

extension Fields {
    public typealias PostGISField<PostGISValue> = KernelFluentModel.Properties.PostGISFieldProperty<Self, PostGISValue> where PostGISValue: PostGISCodable
}

extension KernelFluentModel.Properties {
    @propertyWrapper
    public final class PostGISFieldProperty<Model, PostGISValue> where Model: Fields, PostGISValue: PostGISCodable {
        @CustomSerialisableFieldProperty<Model, PostGISValue>
        public var field: PostGISValue
        
        public init(key: FieldKey) {
            self._field = .init(
                key: key,
                serialiser: { wrappedValue in
                    wrappedValue.binaryEncoded()
                },
                deserialiser: { wrappedValue in
                    let decoder = KernelWellKnown.BinaryDecoder()
                    do {
                        let geometry: PostGISValue.GeometryType = try decoder.decode(from: wrappedValue)
                        return PostGISValue.init(geometry: geometry)
                    } catch {
                        print(error)
                        throw error
                    }
//                    do {
//                        return try decoder.decode(from: bytes)
//                    } catch {
//                        print(error)
//                        throw error
//                    }
//                    return try KernelWellKnown.BinaryDecoder.decode(from: wrappedValue)
                }
            )
        }
        
        public var projectedValue: PostGISFieldProperty<Model, PostGISValue> {
            return self
        }
        
        public var wrappedValue: PostGISValue {
            get {
                guard let value = self.value else { fatalError("Cannot access PostGIS field before it is initialised or fetched: \(self.$field.$field.key)") }
                return value
            }
            set {
                self.value = newValue
            }
        }
    }
}

extension KernelFluentModel.Properties.PostGISFieldProperty: Property {
    public var value: PostGISValue? {
        get { self.$field.wrappedValue }
        set { self.$field.wrappedValue = newValue! }
    }
}

extension KernelFluentModel.Properties.PostGISFieldProperty: AnyProperty {}

extension KernelFluentModel.Properties.PostGISFieldProperty: AnyQueryableProperty {
    public var path: [FieldKey] { self.$field.path }
}

extension KernelFluentModel.Properties.PostGISFieldProperty: QueryableProperty {}

extension KernelFluentModel.Properties.PostGISFieldProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: AnyQueryableProperty { self }
    public var queryablePath: [FieldKey] { self.path }
}

extension KernelFluentModel.Properties.PostGISFieldProperty: QueryAddressableProperty {
    public var queryableProperty: KernelFluentModel.Properties.PostGISFieldProperty<Model, PostGISValue> { self }
}

extension KernelFluentModel.Properties.PostGISFieldProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] { self.$field.keys }
    public func input(to input: DatabaseInput) { self.$field.input(to: input) }
    public func output(from output: DatabaseOutput) throws { try self.$field.output(from: output) }
}

extension KernelFluentModel.Properties.PostGISFieldProperty: AnyCodableProperty {
    public func encode(to encoder: Encoder) throws {
        fatalError("Cannot encode field: \(self.$field.$field.key)")
    }
    
    public func decode(from decoder: Decoder) throws {
        fatalError("Cannot decode field: \(self.$field.$field.key)")
    }
}
