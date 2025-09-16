//
//  File.swift
//  UnionCDP
//
//  Created by Jonathan Forbes on 07/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelSignals.Core.APIModel {
    public enum RawEventPropType: OpenAPIContent, OpenAPISchemaType {
        
        case boolean
        case uint8
        case uint16
        case uint32
        case uint64
        case int8
        case int16
        case int32
        case int64
        case float
        case double
        case uuid
        case string
        case date
        case null
        indirect case array(RawEventPropType)
        indirect case dictionary(Dictionary<String, RawEventPropType>)
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case
                    .boolean, .uint8, .uint16, .uint32, .uint64,
                    .int8, .int16, .int32, .int64, .float, .double,
                    .uuid, .string, .date, .null
                : try container.encode(self.stringValue)
            case .array(let a0):
                var unkeyedContainer = encoder.unkeyedContainer()
                try unkeyedContainer.encode(a0)
            case .dictionary(let a0):
                try a0.encode(to: encoder)
            }
        }
        
        public init(from decoder: any Decoder) throws {
            if
                let container = try? decoder.singleValueContainer(),
                let str = try? container.decode(String.self)
            {
                switch str {
                case "boolean": self = .boolean
                case "uint8": self = .uint8
                case "uint16": self = .uint16
                case "uint32": self = .uint32
                case "uint64": self = .uint64
                case "int8": self = .int8
                case "int16": self = .int16
                case "int32": self = .int32
                case "int64": self = .int64
                case "float": self = .float
                case "double": self = .double
                case "uuid": self = .uuid
                case "string": self = .string
                case "date": self = .date
                case "null": self = .null
                default: self = .null
                }
                return
            }
            else if
                var unkeyedContainer = try? decoder.unkeyedContainer(),
                let arrayValue = try? unkeyedContainer.decode(RawEventPropType.self)
            {
                self = .array(arrayValue)
                return
            }
            else if
                let container = try? decoder.singleValueContainer(),
                let dictionaryValue = try? container.decode(Dictionary<String, RawEventPropType>.self)
            {
                self = .dictionary(dictionaryValue)
                return
            }
            else {
                self = .null
                return
            }
        }
        
        public var stringValue: String {
            switch self {
            case .boolean: "boolean"
            case .uint8: "uint8"
            case .uint16: "uint16"
            case .uint32: "uint32"
            case .uint64: "uint64"
            case .int8: "int8"
            case .int16: "int16"
            case .int32: "int32"
            case .int64: "int64"
            case .float: "float"
            case .double: "double"
            case .uuid: "uuid"
            case .string: "string"
            case .date: "date"
            case .null: "null"
            case .array(let value): "[\(value.stringValue)]"
            case .dictionary(let value): "{\(value.map { "\($0.key): \($0.value.stringValue)"}.joined(separator: ", "))}"
            
            }
        }
        
        public var primitiveStringValue: String? {
            switch self {
            case .boolean: "boolean"
            case .uint8: "uint8"
            case .uint16: "uint16"
            case .uint32: "uint32"
            case .uint64: "uint64"
            case .int8: "int8"
            case .int16: "int16"
            case .int32: "int32"
            case .int64: "int64"
            case .float: "float"
            case .double: "double"
            case .uuid: "uuid"
            case .string: "string"
            case .date: "date"
            case .null: "null"
            default: nil
                
            }
        }
        
        public static var primitiveCases: [RawEventPropType] {
            [.boolean, .uint8, .uint16, .uint32, .uint64, .int8, .int16, .int32, .int64, .float, .double, .uuid, .string, .date, .null]
        }
        
        public static var sample: KernelSignals.Core.APIModel.RawEventPropType { .string }
        
        public static var openAPISchema: JSONSchema {
            let primitive: JSONSchema = .string(allowedValues: primitiveCases.compactMap { $0.primitiveStringValue }.map { .init($0) })
            let layerOne: JSONSchema = .one(of: [
                primitive,
                .array(items: primitive),
                .object(
                    .init(format: .generic),
                    .init(properties: [:], additionalProperties: .init(primitive))
                )
            ])
            return .one(of: [
                primitive,
                .array(items: layerOne),
                .object(
                    .init(format: .generic),
                    .init(properties: [:], additionalProperties: .init(layerOne))
                )
            ])
        }
    }
    
    public enum KeyedEventPropType: OpenAPIContent {
        case boolean(key: String)
        case uint8(key: String)
        case uint16(key: String)
        case uint32(key: String)
        case uint64(key: String)
        case int8(key: String)
        case int16(key: String)
        case int32(key: String)
        case int64(key: String)
        case float(key: String)
        case double(key: String)
        case uuid(key: String)
        case string(key: String)
        case date(key: String)
        indirect case array(key: String, type: RawEventPropType)
        indirect case dictionary(key: String, values: [KeyedEventPropType])
    }
}
