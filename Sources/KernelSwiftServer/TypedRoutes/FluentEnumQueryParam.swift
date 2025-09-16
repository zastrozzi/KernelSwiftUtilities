//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 06/02/2025.
//

import Vapor
import OpenAPIKit30

//public protocol AbstractQueryParam {
//    var name: String { get }
//    var allowedValues: [String]? { get }
//    var description: String? { get }
//    var required: Bool { get }
//    var deprecated: Bool { get }
//    var swiftType: Any.Type { get }
//}
//
//public protocol QueryParamProtocol: AbstractQueryParam {
//    associatedtype SwiftType
//    
//    var defaultValue: SwiftType? { get }
//}
//
//extension QueryParamProtocol {
//    public var swiftType: Any.Type {
//        return SwiftType.self
//    }
//}

//public struct StructuredQueryParam<SwiftType: Codable & Sendable>: QueryParamProtocol, Sendable {
//    public let name: String
//    public let allowedValues: [String]?
//    public let description: String?
//    public let defaultValue: SwiftType?
//    public let required: Bool
//    public let deprecated: Bool
//    
//    public init(
//        name: String,
//        description: String? = nil,
//        defaultValue: SwiftType? = nil,
//        allowedValues: [String]? = nil,
//        required: Bool = false,
//        deprecated: Bool = false
//    ) {
//        self.name = name
//        self.allowedValues = allowedValues
//        self.description = description
//        self.defaultValue = defaultValue
//        self.required = required
//        self.deprecated = deprecated
//    }
//}
//

public struct FluentEnumFilterQueryParamObject<Enum: FluentStringEnum>: Codable, Sendable {
    public let equalTo: Enum?
    public let inValues, allValues, notInValues: [Enum]?
    
    public init(
        equalTo: Enum? = nil,
        inValues: [Enum]? = nil,
        allValues: [Enum]? = nil,
        notInValues: [Enum]? = nil
    ) {
        self.equalTo = equalTo
        self.inValues = inValues
        self.allValues = allValues
        self.notInValues = notInValues
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        equalTo = try? container.decodeIfPresent(Enum.self, forKey: .equalTo)
        inValues = Self.decodeQueryParamArray(from: container, for: .inValues)
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
        try container.encodeIfPresent(equalTo, forKey: .equalTo)
        try container.encodeIfPresent(inValues?.map { $0.rawValue }.joined(separator: ","), forKey: .inValues)
        try container.encodeIfPresent(allValues?.map { $0.rawValue }.joined(separator: ","), forKey: .allValues)
        try container.encodeIfPresent(notInValues?.map { $0.rawValue }.joined(separator: ","), forKey: .notInValues)
    }
    
    public enum CodingKeys: String, CodingKey {
        case equalTo = "eq"
        case inValues = "in"
        case allValues = "all"
        case notInValues = "not_in"
    }
}

extension FluentEnumFilterQueryParamObject: OpenAPISchemaType {
    public static var openAPISchema: JSONSchema {
        let rawSchema: JSONSchema = (try? Enum.rawOpenAPISchema()) ?? .string()
        return .object(
            properties: [
                "eq": rawSchema.optionalSchemaObject(withNilExample: true),
                "in": .array(required: false, items: rawSchema, example: .init(nil)),
                "all": .array(required: false, items: rawSchema, example: .init(nil)),
                "not_in": .array(required: false, items: rawSchema, example: .init(nil))
            ]
        )
    }
}

public typealias FluentEnumFilterQueryParam<Enum: FluentStringEnum> = StructuredQueryParam<FluentEnumFilterQueryParamObject<Enum>>
