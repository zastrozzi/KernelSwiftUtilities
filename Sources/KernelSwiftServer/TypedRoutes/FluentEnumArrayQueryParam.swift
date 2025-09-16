//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 07/02/2025.
//

import OpenAPIKit30
import Vapor

public struct FluentEnumArrayFilterQueryParamObject<Enum: FluentStringEnum>: Codable, Sendable {
    public let equalValues, inValues, anyValues, allValues, notInValues: [Enum]?
    
    public init(
        equalValues: [Enum]? = nil,
        inValues: [Enum]? = nil,
        anyValues: [Enum]? = nil,
        allValues: [Enum]? = nil,
        notInValues: [Enum]? = nil
    ) {
        self.equalValues = equalValues
        self.inValues = inValues
        self.anyValues = anyValues
        self.allValues = allValues
        self.notInValues = notInValues
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        equalValues = Self.decodeQueryParamArray(from: container, for: .equalValues)
        inValues = Self.decodeQueryParamArray(from: container, for: .inValues)
        anyValues = Self.decodeQueryParamArray(from: container, for: .anyValue)
        allValues = Self.decodeQueryParamArray(from: container, for: .allValues)
        notInValues = Self.decodeQueryParamArray(from: container, for: .notInValues)
    }
    
    static func decodeQueryParamArray(from container: KeyedDecodingContainer<CodingKeys>, for codingKey: CodingKeys) -> [Enum]? {
        let arr = try? container.decodeIfPresent([String].self, forKey: codingKey)
        let str = try? container.decodeIfPresent(String.self, forKey: codingKey)
        
        return if let arr, arrayParamIsValid(arr) {
            arr.compactMap { Enum(rawValue: $0) }
        }
        else if let str, !str.isEmpty {
            str.split(separator: ",").compactMap { Enum(rawValue: String($0)) }
        }
        else { nil }
    }
    
    static func arrayParamIsValid(_ arr: [String]) -> Bool {
        !arr.isEmpty && !arr.allSatisfy(\.isEmpty) && arr.allSatisfy( { !$0.contains(",") })
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(equalValues?.map { $0.rawValue }.joined(separator: ","), forKey: .equalValues)
        try container.encodeIfPresent(inValues?.map { $0.rawValue }.joined(separator: ","), forKey: .inValues)
        try container.encodeIfPresent(anyValues?.map { $0.rawValue }.joined(separator: ","), forKey: .anyValue)
        try container.encodeIfPresent(allValues?.map { $0.rawValue }.joined(separator: ","), forKey: .allValues)
        try container.encodeIfPresent(notInValues?.map { $0.rawValue }.joined(separator: ","), forKey: .notInValues)
    }
    
    public enum CodingKeys: String, CodingKey {
        case equalValues = "eq"
        case inValues = "in"
        case anyValue = "any"
        case allValues = "all"
        case notInValues = "not_in"
    }
}

extension FluentEnumArrayFilterQueryParamObject: OpenAPISchemaType {
    public static var openAPISchema: JSONSchema {
        let rawSchema: JSONSchema = (try? Enum.rawOpenAPISchema()) ?? .string()
        return .object(
            properties: [
                "eq": .array(required: false, items: rawSchema, example: .init(nil)),
                "in": .array(required: false, items: rawSchema, example: .init(nil)),
                "any": .array(required: false, items: rawSchema, example: .init(nil)),
                "all": .array(required: false, items: rawSchema, example: .init(nil)),
                "not_in": .array(required: false, items: rawSchema, example: .init(nil))
            ]
        )
    }
}

public typealias FluentEnumArrayFilterQueryParam<Enum: FluentStringEnum> = StructuredQueryParam<FluentEnumArrayFilterQueryParamObject<Enum>>

