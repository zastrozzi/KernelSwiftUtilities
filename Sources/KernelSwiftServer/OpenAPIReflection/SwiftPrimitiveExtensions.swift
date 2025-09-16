//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import OpenAPIKit30

extension Optional: AnyRawRepresentable where Wrapped: AnyRawRepresentable {
    public static var rawValueType: Any.Type { Wrapped.rawValueType }
}

extension Optional: AnyJSONCaseIterable where Wrapped: AnyJSONCaseIterable {
    public static func allCases(using encoder: JSONEncoder) -> [AnyCodable] {
        return Wrapped.allCases(using: encoder)
    }
}

extension Optional: RawOpenAPISchemaType where Wrapped: RawOpenAPISchemaType {
    static public func rawOpenAPISchema() throws -> JSONSchema {
        return try Wrapped.rawOpenAPISchema().optionalSchemaObject()
    }
}

extension Optional: DateOpenAPISchemaType where Wrapped: DateOpenAPISchemaType {
    static public func dateOpenAPISchemaGuess(using encoder: JSONEncoder) -> JSONSchema? {
        return Wrapped.dateOpenAPISchemaGuess(using: encoder)?.optionalSchemaObject()
    }
}

extension Array: OpenAPIEncodedSchemaType where Element: OpenAPIEncodedSchemaType {
    public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
        return .array(
            .init(format: .generic, required: true),
            .init(items: try Element.openAPISchema(using: encoder))
        )
    }
}

extension Dictionary: RawOpenAPISchemaType where Value: OpenAPISchemaType {
    static public func rawOpenAPISchema() throws -> JSONSchema {
//        print("Dictionary: RawOpenAPISchemaType")
        return .object(
            .init(format: .generic),
            .init(properties: [:], additionalProperties: .init(Value.openAPISchema))
        )
    }
}

extension Dictionary: OpenAPIEncodedSchemaType where Key: RawRepresentable, Value: OpenAPIEncodedSchemaType {
    public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
//        print("Dictionary: OpenAPIEncodedSchemaType")
        return .object(
            .init(
                format: .generic
            ),
            .init(
                properties: [:],
                additionalProperties: .init(try Value.openAPISchema(using: encoder))
            )
        )
    }
}

extension UInt: RawOpenAPISchemaType {
    public static func rawOpenAPISchema() throws -> JSONSchema { .integer(format: .other("uint64")) }
}

extension UInt16: RawOpenAPISchemaType {
    public static func rawOpenAPISchema() throws -> JSONSchema { .integer(format: .other("uint16")) }
}

extension UInt32: RawOpenAPISchemaType {
    public static func rawOpenAPISchema() throws -> JSONSchema { .integer(format: .other("uint32")) }
}

extension UInt64: RawOpenAPISchemaType {
    public static func rawOpenAPISchema() throws -> JSONSchema { .integer(format: .other("uint64")) }
}

extension Int: RawOpenAPISchemaType {
    public static func rawOpenAPISchema() throws -> JSONSchema { .integer(format: .other("int64")) }
}

extension Int8: RawOpenAPISchemaType {
    public static func rawOpenAPISchema() throws -> JSONSchema { .integer(format: .other("int8")) }
}

extension Int16: RawOpenAPISchemaType {
    public static func rawOpenAPISchema() throws -> JSONSchema { .integer(format: .other("int16")) }
}

extension Int32: RawOpenAPISchemaType {
    public static func rawOpenAPISchema() throws -> JSONSchema { .integer(format: .other("int32")) }
}

extension Int64: RawOpenAPISchemaType {
    public static func rawOpenAPISchema() throws -> JSONSchema { .integer(format: .other("int64")) }
}
