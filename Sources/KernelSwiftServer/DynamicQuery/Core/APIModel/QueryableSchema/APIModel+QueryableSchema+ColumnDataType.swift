//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Core.APIModel.QueryableSchema {
    public enum ColumnDataType: OpenAPIContent {
        case bool
        case bytea
        case char
        case date
        case float4
        case float8
        case int2
        case int4
        case int8
        case interval
        case json
        case jsonb
        case numeric
        case text
        case time
        case timestamp
        case timestamptz
        case timetz
        case uuid
        case varchar
        case xml
        case custom
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let strValue = try container.decode(String.self)
            if !RawColumnDataType.simpleTypeStrings.contains(strValue) {
                self = .custom
                return
            } else {
                self = switch strValue {
                case "bool": .bool
                case "bytea": .bytea
                case "char": .char
                case "date": .date
                case "float4": .float4
                case "float8": .float8
                case "int2": .int2
                case "int4": .int4
                case "int8": .int8
                case "interval": .interval
                case "json": .json
                case "jsonb": .jsonb
                case "numeric": .numeric
                case "text": .text
                case "time": .time
                case "timestamp": .timestamp
                case "timestamptz": .timestamptz
                case "timetz": .timetz
                case "uuid": .uuid
                case "varchar": .varchar
                case "xml": .xml
                default: .custom
                }
            }
        }
        
        public init(from rawType: RawColumnDataType) {
            self = switch rawType {
            case .custom: .custom
            case let .array(elementType): .init(from: elementType)
            case .bool: .bool
            case .bytea: .bytea
            case .char: .char
            case .date: .date
            case .float4: .float4
            case .float8: .float8
            case .int2: .int2
            case .int4: .int4
            case .int8: .int8
            case .interval: .interval
            case .json: .json
            case .jsonb: .jsonb
            case .numeric: .numeric
            case .text: .text
            case .time: .time
            case .timestamp: .timestamp
            case .timestamptz: .timestamptz
            case .timetz: .timetz
            case .uuid: .uuid
            case .varchar: .varchar
            case .xml: .xml
            }
        }
        
        public func encode(to encoder: any Encoder) throws {
//            var container = encoder.singleValueContainer()
            try asString.encode(to: encoder)
        }
        
        public var asString: String {
            switch self {
            case .custom: "custom"
            case .bool: "bool"
            case .bytea: "bytea"
            case .char: "char"
            case .date: "date"
            case .float4: "float4"
            case .float8: "float8"
            case .int2: "int2"
            case .int4: "int4"
            case .int8: "int8"
            case .interval: "interval"
            case .json: "json"
            case .jsonb: "jsonb"
            case .numeric: "numeric"
            case .text: "text"
            case .time: "time"
            case .timestamp: "timestamp"
            case .timestamptz: "timestamptz"
            case .timetz: "timetz"
            case .uuid: "uuid"
            case .varchar: "varchar"
            case .xml: "xml"
            }
        }
    }
}
