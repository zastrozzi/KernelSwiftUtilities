//
//  File.swift
//  UnionCDP
//
//  Created by Jonathan Forbes on 07/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelSignals.Core.APIModel {
    public enum EventProp: OpenAPIContent, OpenAPISchemaType {
        case boolean(Bool)
        case uint8(UInt8)
        case uint16(UInt16)
        case uint32(UInt32)
        case uint64(UInt64)
        case int8(Int8)
        case int16(Int16)
        case int32(Int32)
        case int64(Int64)
        case float(Float)
        case double(Double)
        case uuid(UUID)
        case string(String)
        case date(Date)
        case null
        indirect case array([EventProp])
        indirect case dictionary(EventPayload)
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let boolValue = try? container.decode(Bool.self) { self = .boolean(boolValue); return }
            
            else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown Value"))
            }
        }
        
        public static func decode(from anyValue: Any, for propType: RawEventPropType) throws -> EventProp {
            switch propType {
            case .boolean:
                if let boolValue = anyValue as? Bool { return .boolean(boolValue) }
            case .uint8:
                if let uint8Value = anyValue as? UInt8 { return .uint8(uint8Value) }
            case .uint16:
                if let uint16Value = anyValue as? UInt16 { return .uint16(uint16Value) }
            case .uint32:
                if let uint32Value = anyValue as? UInt32 { return .uint32(uint32Value) }
            case .uint64:
                if let uint64Value = anyValue as? UInt64 { return .uint64(uint64Value) }
            case .int8:
                if let int8Value = anyValue as? Int8 { return .int8(int8Value) }
            case .int16:
                if let int16Value = anyValue as? Int16 { return .int16(int16Value) }
            case .int32:
                if let int32Value = anyValue as? Int32 { return .int32(int32Value) }
            case .int64:
                if let int64Value = anyValue as? Int64 { return .int64(int64Value) }
            case .float:
                if let floatValue = anyValue as? Float { return .float(floatValue) }
            case .double:
                if let doubleValue = anyValue as? Double { return .double(doubleValue) }
            case .uuid:
                if  let uuidStr = anyValue as? String,
                    let uuidValue = UUID(uuidString: uuidStr)
                { return .uuid(uuidValue) }
            case .string:
                if let stringValue = anyValue as? String { return .string(stringValue) }
            case .date:
                if  let dateStr = anyValue as? String,
                    let dateValue = ISO8601DateFormatter().date(from: dateStr)
                { return .date(dateValue) }
            case .null:
                if let _ = anyValue as? NSNull { return .null }
            case let .array(elementType):
                if let arrayValue = anyValue as? [Any] {
                    let eventProps = try arrayValue.map { try EventProp.decode(from: $0, for: elementType) }
                    return .array(eventProps)
                }
            case let .dictionary(schema):
                if let dictionaryValue = anyValue as? [String: Any] {
                    var eventProps: EventPayload = [:]
                    for (schemaKey, schemaValue) in schema {
                        if  let value = dictionaryValue[schemaKey],
                            let eventProp = try? EventProp.decode(from: value, for: schemaValue)
                        {
                            eventProps[schemaKey] = eventProp
                        }
                    }
                    return .dictionary(eventProps)
                }
            }
            throw Abort(.unprocessableEntity, reason: "Cannot decode into event prop type \(propType)")
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case let .boolean(value): try container.encode(value)
            case let .uint8(value): try container.encode(value)
            case let .uint16(value): try container.encode(value)
            case let .uint32(value): try container.encode(value)
            case let .uint64(value): try container.encode(value)
            case let .int8(value): try container.encode(value)
            case let .int16(value): try container.encode(value)
            case let .int32(value): try container.encode(value)
            case let .int64(value): try container.encode(value)
            case let .float(value): try container.encode(value)
            case let .double(value): try container.encode(value)
            case let .uuid(value): try container.encode(value.uuidString)
            case let .string(value): try container.encode(value)
            case let .date(value): try container.encode(value.iso8601)
            case .null: try container.encodeNil()
            case let .array(values):
                var unkeyedContainer = encoder.unkeyedContainer()
                for value in values {
                    try unkeyedContainer.encode(value)
                }
            case let .dictionary(value):
                try value.encode(to: encoder)
                
            }
        }
        
//        public init(from decoder: any Decoder, for propType: RawEventPropType) throws {
//            
//        }
        public static var openAPISchema: JSONSchema {
            do {
                let primitives: [JSONSchema] = [
                    Bool.openAPISchema,
                    try UInt8.rawOpenAPISchema(),
                    try UInt16.rawOpenAPISchema(),
                    try UInt32.rawOpenAPISchema(),
                    try UInt64.rawOpenAPISchema(),
                    try Int8.rawOpenAPISchema(),
                    try Int16.rawOpenAPISchema(),
                    try Int32.rawOpenAPISchema(),
                    try Int64.rawOpenAPISchema(),
                    Float.openAPISchema,
                    Double.openAPISchema,
                    UUID.openAPISchema,
                    String.openAPISchema
                ]
                let oneOfPrimitives: JSONSchema = .one(of: primitives)
//                let arrayPrimitives: JSONSchema = .array(items: oneOfPrimitives)

                let layerOne: JSONSchema = .one(of: [
                    Bool.openAPISchema,
                    try UInt8.rawOpenAPISchema(),
                    try UInt16.rawOpenAPISchema(),
                    try UInt32.rawOpenAPISchema(),
                    try UInt64.rawOpenAPISchema(),
                    try Int8.rawOpenAPISchema(),
                    try Int16.rawOpenAPISchema(),
                    try Int32.rawOpenAPISchema(),
                    try Int64.rawOpenAPISchema(),
                    Float.openAPISchema,
                    Double.openAPISchema,
                    UUID.openAPISchema,
                    String.openAPISchema,
                    .array(items: oneOfPrimitives),
                    .object(
                        .init(format: .generic),
                        .init(properties: [:], additionalProperties: .init(oneOfPrimitives))
                    )
                ])
                return .one(of: [
                    Bool.openAPISchema,
                    try UInt8.rawOpenAPISchema(),
                    try UInt16.rawOpenAPISchema(),
                    try UInt32.rawOpenAPISchema(),
                    try UInt64.rawOpenAPISchema(),
                    try Int8.rawOpenAPISchema(),
                    try Int16.rawOpenAPISchema(),
                    try Int32.rawOpenAPISchema(),
                    try Int64.rawOpenAPISchema(),
                    Float.openAPISchema,
                    Double.openAPISchema,
                    UUID.openAPISchema,
                    String.openAPISchema,
                    .array(items: layerOne),
                    .object(
                        .init(format: .generic),
                        .init(properties: [:], additionalProperties: .init(layerOne))
                    )
                ])
            } catch {
                return .object
            }
        }
    }
}

//{
//    "enduserId": "00000000-0000-0000-0000-000000000000",
//    "timestamps": {
//        "sessionStart": "2001-01-01T00:00:00Z",
//        "sessionActions": [
//            {
//                "actionId": "00000000-0000-0000-0000-000000000000",
//                "actionSuccess": true
//            }
//        ],
//        "sessionEnd": "2001-01-02T00:00:00Z"
//    }
//}
