//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//  Inspired by Mathew Polzin @github.com/mattpolzin
//

import Foundation
import Vapor
import OpenAPIKit30

public protocol AbstractQueryParam {
    var name: String { get }
    var allowedValues: [String]? { get }
    var description: String? { get }
    var required: Bool { get }
    var deprecated: Bool { get }
    var swiftType: Any.Type { get }
}

public protocol QueryParamProtocol: AbstractQueryParam {
    associatedtype SwiftType
    
    var defaultValue: SwiftType? { get }
}

extension QueryParamProtocol {
    public var swiftType: Any.Type {
        return SwiftType.self
    }
}

public struct QueryParam<T: Decodable & Sendable>: QueryParamProtocol, Sendable {
    public typealias SwiftType = T
    public let name: String
    public let allowedValues: [String]?
    public let description: String?
    public let defaultValue: T?
    public let required: Bool
    public let deprecated: Bool
    
    public init(
        name: String,
        description: String? = nil,
        defaultValue: T? = nil,
        required: Bool = false,
        deprecated: Bool = false
    ) {
        self.name = name
        self.allowedValues = nil
        self.defaultValue = defaultValue
        self.description = description
        self.required = required
        self.deprecated = deprecated
    }
    
    public init<U: LosslessStringConvertible & Sendable>(
        name: String,
        description: String? = nil,
        defaultValue: T? = nil,
        allowedValues: [U],
        required: Bool = false,
        deprecated: Bool = false
    ) {
        self.name = name
        self.description = description
        self.defaultValue = defaultValue
        self.allowedValues = allowedValues.map(String.init(describing:))
        self.required = required
        self.deprecated = deprecated
    }
}

public typealias StringQueryParam = QueryParam<String>
public typealias IntegerQueryParam = QueryParam<Int>
public typealias NumberQueryParam = QueryParam<Double>
public typealias CSVQueryParam<SwiftType: Decodable> = QueryParam<[SwiftType]>

public struct EnumQueryParamContainer<Enum: RawRepresentable & Codable & Equatable & CaseIterable & OpenAPIStringEnumSampleable & Sendable>: Codable, OpenAPISchemaType, Sendable where Enum.RawValue == String {
    public let value: Enum?
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let rawValue = try? container.decode(String.self) else {
            self.init(nil)
            return
        }
        guard let value = Enum(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid enum value: \(rawValue)")
        }
        self.init(value)
    }
    
    public init(_ value: Enum?) {
        self.value = value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = value {
            try container.encode(value.rawValue)
        } else {
            try container.encodeNil()
        }
    }
    
    public static var openAPISchema: JSONSchema {
        let rawSchema: JSONSchema
        do {
            rawSchema = try Enum.rawOpenAPISchema()
        } catch {
            rawSchema = JSONSchema.string()
        }
        return rawSchema
    }
    
    public func require() throws -> Enum {
        guard let value else { throw Abort(.badRequest, reason: "Missing required query parameter: \(Self.openAPISchema.title ?? String(describing: Enum.self))")}
        return value
    }
}

public struct EnumArrayQueryParamContainer<Enum: RawRepresentable & Codable & Equatable & CaseIterable & OpenAPIStringEnumSampleable & Sendable>: Codable, OpenAPISchemaType, Sendable where Enum.RawValue == String {
    public let value: [Enum]
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let rawString = try? container.decode(String.self), !rawString.isEmpty {
            value = rawString.split(separator: ",").compactMap { Enum(rawValue: String($0)) }
        } else {
            value = []
        }
    }
    
    public init(_ value: [Enum]) {
        self.value = value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
//        if let value {
            try container.encode(value.map { $0.rawValue }.joined(separator: ","))
//        } else {
            try container.encodeNil()
//        }
    }
    
    public static var openAPISchema: JSONSchema {
        let rawSchema: JSONSchema
        do {
            rawSchema = try Enum.rawOpenAPISchema()
        } catch {
            rawSchema = JSONSchema.string()
        }
        return .array(items: rawSchema)
    }
    
//    public func require() throws -> [Enum] {
//        guard let value else { throw Abort(.badRequest, reason: "Missing required query parameter: \(Self.openAPISchema.title ?? String(describing: Enum.self))")}
//        return value
//    }
}



public struct NestedQueryParam<SwiftType: Decodable>: QueryParamProtocol {
    public let path: [String]
    public let allowedValues: [String]?
    public let description: String?
    public let defaultValue: SwiftType?
    public let required: Bool
    public let deprecated: Bool
    
    public var name: String { path[0] }
    
    public init(
        path: String...,
        description: String? = nil,
        defaultValue: SwiftType? = nil,
        allowedValues: [String]? = nil,
        required: Bool = false,
        deprecated: Bool = false
    ) {
        self.init(
            path: path,
            description: description,
            defaultValue: defaultValue,
            allowedValues: allowedValues,
            required: required,
            deprecated: deprecated
        )
    }
    
    public init(
        path: [String],
        description: String? = nil,
        defaultValue: SwiftType? = nil,
        allowedValues: [String]? = nil,
        required: Bool = false,
        deprecated: Bool = false
    ) {
        self.path = path
        self.allowedValues = allowedValues
        self.description = description
        self.defaultValue = defaultValue
        self.required = required
        self.deprecated = deprecated
    }
}

public struct StructuredQueryParam<SwiftType: Codable & Sendable>: QueryParamProtocol, Sendable {
    public let name: String
    public let allowedValues: [String]?
    public let description: String?
    public let defaultValue: SwiftType?
    public let required: Bool
    public let deprecated: Bool
    
    public init(
        name: String,
        description: String? = nil,
        defaultValue: SwiftType? = nil,
        allowedValues: [String]? = nil,
        required: Bool = false,
        deprecated: Bool = false
    ) {
        self.name = name
        self.allowedValues = allowedValues
        self.description = description
        self.defaultValue = defaultValue
        self.required = `required`
        self.deprecated = deprecated
    }
}

extension StructuredQueryParam {
    public init<Enum: RawRepresentable & Codable & Equatable & CaseIterable & OpenAPIStringEnumSampleable & Sendable>(
        name: String,
        description: String? = nil,
        defaultValue: Enum? = nil,
        allowedValues: [String]? = nil,
        required: Bool = false,
        deprecated: Bool = false
    ) where SwiftType == EnumQueryParamContainer<Enum> {
        self.name = name
        self.allowedValues = allowedValues
        self.description = description
        self.defaultValue = .init(defaultValue)
        self.required = `required`
        self.deprecated = deprecated
    }
}

public struct DateFilterQueryParamObject: Codable, OpenAPISchemaType, Sendable {
    public let lessThan: Date?
    public let greaterThan: Date?
    public let equalTo: Date?
    
    public init(lessThan: Date? = nil, greaterThan: Date? = nil, equalTo: Date? = nil) {
        self.lessThan = lessThan
        self.greaterThan = greaterThan
        self.equalTo = equalTo
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let lessThanInt = try? container.decodeIfPresent(Int.self, forKey: .lessThan)
        let greaterThanInt = try? container.decodeIfPresent(Int.self, forKey: .greaterThan)
        let equalToInt = try? container.decodeIfPresent(Int.self, forKey: .equalTo)
        if var lessThanInt = lessThanInt {
            if lessThanInt > 33281265389 { lessThanInt = lessThanInt / 1000 }
            lessThan = Date(timeIntervalSince1970: TimeInterval(lessThanInt))
        } else {
            lessThan = nil
        }
        if var greaterThanInt = greaterThanInt {
            if greaterThanInt > 33281265389 { greaterThanInt = greaterThanInt / 1000 }
            greaterThan = Date(timeIntervalSince1970: TimeInterval(greaterThanInt))
        } else {
            greaterThan = nil
        }
        if var equalToInt = equalToInt {
            if equalToInt > 33281265389 { equalToInt = equalToInt / 1000 }
            equalTo = Date(timeIntervalSince1970: TimeInterval(equalToInt))
        } else {
            equalTo = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let lessThan = lessThan {
            try container.encode(Int(lessThan.timeIntervalSince1970), forKey: .lessThan)
        }
        if let greaterThan = greaterThan {
            try container.encode(Int(greaterThan.timeIntervalSince1970), forKey: .greaterThan)
        }
        if let equalTo = equalTo {
            try container.encode(Int(equalTo.timeIntervalSince1970), forKey: .equalTo)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case lessThan = "lt"
        case greaterThan = "gt"
        case equalTo = "eq"
    }
    
    public static var openAPISchema: JSONSchema {
        .object(
            properties: [
                "lt": .integer(format: .other("Unix Timestamp"), required: false, description: "lessThan", example: .init(nil)),
                "gt": .integer(format: .other("Unix Timestamp"), required: false, description: "greaterThan", example: .init(nil)),
                "eq": .integer(format: .other("Unix Timestamp"), required: false, description: "equalTo", example: .init(nil))
            ]
        )
    }
}

public struct NumericFilterQueryParamObject<NumericType: Numeric & Codable & Sendable>: Codable, OpenAPISchemaType, Sendable {
    public let lessThan: NumericType?
    public let greaterThan: NumericType?
    public let equalTo: NumericType?
    public let lessThanOrEqualTo: NumericType?
    public let greaterThanOrEqualTo: NumericType?
    
    public init(
        lessThan: NumericType? = nil,
        greaterThan: NumericType? = nil,
        equalTo: NumericType? = nil,
        lessThanOrEqualTo: NumericType? = nil,
        greaterThanOrEqualTo: NumericType? = nil
    ) {
        self.lessThan = lessThan
        self.greaterThan = greaterThan
        self.equalTo = equalTo
        self.lessThanOrEqualTo = lessThanOrEqualTo
        self.greaterThanOrEqualTo = greaterThanOrEqualTo
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lessThan = try? container.decodeIfPresent(NumericType.self, forKey: .lessThan)
        greaterThan = try? container.decodeIfPresent(NumericType.self, forKey: .greaterThan)
        equalTo = try? container.decodeIfPresent(NumericType.self, forKey: .equalTo)
        lessThanOrEqualTo = try? container.decodeIfPresent(NumericType.self, forKey: .lessThanOrEqualTo)
        greaterThanOrEqualTo = try? container.decodeIfPresent(NumericType.self, forKey: .greaterThanOrEqualTo)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(lessThan, forKey: .lessThan)
        try container.encodeIfPresent(greaterThan, forKey: .greaterThan)
        try container.encodeIfPresent(equalTo, forKey: .equalTo)
        try container.encodeIfPresent(lessThanOrEqualTo, forKey: .lessThanOrEqualTo)
        try container.encodeIfPresent(greaterThanOrEqualTo, forKey: .greaterThanOrEqualTo)
    }
    
    public enum CodingKeys: String, CodingKey {
        case lessThan = "lt"
        case greaterThan = "gt"
        case equalTo = "eq"
        case lessThanOrEqualTo = "lte"
        case greaterThanOrEqualTo = "gte"
    }
    
    public static var openAPISchema: JSONSchema {
        .object(
            properties: [
                "lt": .number(required: false, description: "lessThan", example: .init(nil)),
                "gt": .number(required: false, description: "greaterThan", example: .init(nil)),
                "eq": .number(required: false, description: "equalTo", example: .init(nil)),
                "lte": .number(required: false, description: "lessThanOrEqualTo", example: .init(nil)),
                "gte": .number(required: false, description: "greaterThanOrEqualTo", example: .init(nil))
            ]
        )
    }
}

public struct StringFilterQueryParamObject: Codable, OpenAPISchemaType, Sendable {
    public let equalTo: String?
    public let contains: String?
    
    public init(equalTo: String? = nil, contains: String? = nil) {
        self.equalTo = equalTo
        self.contains = contains
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let equalToStr = try? container.decodeIfPresent(String.self, forKey: .equalTo)
        if let equalToStr = equalToStr, !equalToStr.isEmpty {
            equalTo = equalToStr
        } else {
            equalTo = nil
        }
        let containsStr = try? container.decodeIfPresent(String.self, forKey: .contains)
        if let containsStr = containsStr, !containsStr.isEmpty {
            contains = containsStr
        } else {
            contains = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(equalTo, forKey: .equalTo)
        try container.encodeIfPresent(contains, forKey: .contains)
    }
    
    public enum CodingKeys: String, CodingKey {
        case equalTo = "eq"
        case contains = "contains"
    }
    
    public static var openAPISchema: JSONSchema {
        .object(
            properties: [
                "eq": .string(required: false, description: "equalTo", example: .init(nil)),
                "contains": .string(required: false, description: "contains", example: .init(nil))
            ]
        )
    }
}

public typealias DateFilterQueryParam = StructuredQueryParam<DateFilterQueryParamObject>
public typealias NumericFilterQueryParam<NumericType: Numeric & Codable> = StructuredQueryParam<NumericFilterQueryParamObject<NumericType>>
public typealias StringFilterQueryParam = StructuredQueryParam<StringFilterQueryParamObject>
public typealias EnumQueryParam<Enum: RawRepresentable & Codable & Equatable & CaseIterable & OpenAPIStringEnumSampleable> = StructuredQueryParam<EnumQueryParamContainer<Enum>> where Enum.RawValue == String
public typealias EnumArrayQueryParam<Enum: RawRepresentable & Codable & Equatable & CaseIterable & OpenAPIStringEnumSampleable> = StructuredQueryParam<EnumArrayQueryParamContainer<Enum>> where Enum.RawValue == String

