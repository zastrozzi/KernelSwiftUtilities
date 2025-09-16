//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import OpenAPIKit30

public protocol AnyRawRepresentable {
    static var rawValueType: Any.Type { get }
}

extension AnyRawRepresentable where Self: RawRepresentable {
    public static var rawValueType: Any.Type { return Self.RawValue.self }
}

public protocol AnyJSONCaseIterable: AnyRawRepresentable {
    static func allCases(using encoder: JSONEncoder) -> [AnyCodable]
}

extension AnyJSONCaseIterable where Self: RawRepresentable {
    public static var rawValueType: Any.Type { return Self.RawValue.self }
}

public extension AnyJSONCaseIterable {
    static func allCases<T: Encodable>(from input: [T], using encoder: JSONEncoder) throws -> [AnyCodable] {
        return try allCasesEncodable(from: input, using: encoder)
    }
}

public extension AnyJSONCaseIterable where Self: CaseIterable, Self: Codable {
    static func caseIterableOpenAPISchemaGuess(using encoder: JSONEncoder) throws -> JSONSchema {
        guard let first = allCases.first else {
            throw OpenAPI.EncodableError.exampleNotCodable
        }
        let itemSchema = try nestedGenericOpenAPISchemaGuess(for: first, using: encoder)

        return itemSchema.with(allowedValues: allCases.map { AnyCodable($0) })
    }
}

extension CaseIterable where Self: Encodable {
    public static func allCases(using encoder: JSONEncoder) -> [AnyCodable] {
        return (try? allCasesEncodable(from: Array(Self.allCases), using: encoder)) ?? []
    }
}

func allCasesEncodable<T: Encodable>(from input: [T], using encoder: JSONEncoder) throws -> [AnyCodable] {
//    if let alreadyGoodToGo = input as? [AnyCodable] {
//        return alreadyGoodToGo
//    }
//
//    guard let arrayOfCodables = try JSONSerialization.jsonObject(with: encoder.encode(input), options: []) as? [Any] else {
//        throw OpenAPI.EncodableError.allCasesArrayNotCodable
//    }
//    return arrayOfCodables.map(AnyCodable.init)
    return []
}
