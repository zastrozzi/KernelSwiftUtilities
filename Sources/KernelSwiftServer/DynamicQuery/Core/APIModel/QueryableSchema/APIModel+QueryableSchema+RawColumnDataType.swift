//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Core.APIModel.QueryableSchema {
    public enum RawColumnDataType: OpenAPIContent {
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
        case custom(String)
        indirect case array(RawColumnDataType)
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let strValue = try container.decode(String.self)
            try self.init(from: strValue)
        }
        
        public init(from stringValue: String) throws {
            if stringValue.hasPrefix("_") {
                let innerValue = try Self.init(from: .init(stringValue.dropFirst()))
                self = .array(innerValue)
                return
            } else if !RawColumnDataType.simpleTypeStrings.contains(stringValue) {
                self = .custom(stringValue)
                return
            } else {
                self = switch stringValue {
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
                default: .custom(stringValue)
                }
            }
        }
        
        public var isArray: Bool {
            if case .array = self { true } else { false }
        }
        
        public var isCustom: Bool {
            switch self {
            case .custom: true
            case let .array(innerValue): innerValue.isCustom
            default: false
            }
        }
        
        public var asString: String {
            switch self {
            case let .array(element):
                "_\(element.asString)"
            case let .custom(value): value
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
        
        public var customDataType: String? {
            switch self {
            case let .custom(customType): customType
            case let .array(innerValue): innerValue.customDataType
            default: nil
            }
        }
        
        public static let simpleTypes: [RawColumnDataType] = [
            .bool,
            .bytea,
            .char,
            .date,
            .float4,
            .float8,
            .int2,
            .int4,
            .int8,
            .interval,
            .json,
            .jsonb,
            .numeric,
            .text,
            .time,
            .timestamp,
            .timestamptz,
            .timetz,
            .uuid,
            .varchar,
            .xml
        ]
        
        public static let simpleTypeStrings: [String] = simpleTypes.map(\.asString)
    }
}
