//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import OpenAPIKit30
import KernelSwiftCommon

extension KernelSwiftCommon.Sampleable where Self: Encodable {
    public static func genericOpenAPISchemaGuess(using encoder: JSONEncoder) throws -> JSONSchema {
        return try KernelSwiftServer.genericOpenAPISchemaGuess(for: Self.sample, using: encoder)
    }
}

public func genericOpenAPISchemaGuess<T>(for value: T, using encoder: JSONEncoder) throws -> JSONSchema {
    if
        let date = value as? Date,
        let node = try type(of: date).dateOpenAPISchemaGuess(using: encoder) ?? reencodedSchemaGuess(for: date, using: encoder) {
        return node
    }
    let mirror = Mirror(reflecting: value)
    let properties: [(String, JSONSchema)] = try mirror.children.compactMap { child in
        let maybeAllCases: [AnyCodable]? = {
            switch type(of: child.value) {
            case let valType as AnyJSONCaseIterable.Type: return valType.allCases(using: encoder)
            default: return nil
            }
        }()
        let openAPINode: JSONSchema = try openAPISchemaGuess(for: child.value, using: encoder) ?? nestedGenericOpenAPISchemaGuess(for: child.value, using: encoder)
        let newNode: JSONSchema
        if let allCases = maybeAllCases {
            newNode = openAPINode.with(allowedValues: allCases)
        } else { newNode = openAPINode }
        return zip(child.label, newNode) { ($0, $1) }
    }
    
    if properties.count != mirror.children.count {
        throw OpenAPI.TypeError.unknownSchemaType(type(of: value))
    }
    
    let propertiesDict = OpenAPIOrderedDictionary(properties) { _, value2 in value2 }
    
    return .object(required: true, properties: propertiesDict)
}

internal func nestedGenericOpenAPISchemaGuess<T>(for value: T, using encoder: JSONEncoder) throws -> JSONSchema {
    if let schema = try openAPISchemaGuess(for: value, using: encoder) { return schema }
    else {
        if let unwrapping = value as Any as! Optional<T?> {
            switch unwrapping {
            case .some(let unwrapped):
                if let unwrappedSchema = try openAPISchemaGuess(for: unwrapped, using: encoder) { return unwrappedSchema.optionalSchemaObject() }
            case .none:
                if let unwrappedSchema = try openAPISchemaGuess(for: unwrapping!.self, using: encoder) { return unwrappedSchema.optionalSchemaObject() }
//            default: break
            }
        }
        
    }
    return try genericOpenAPISchemaGuess(for: value, using: encoder)
}

internal func nestedValueIsOptional(_ value: Any) -> Bool {
    let valueDescription = String(describing: value)
    let isOptional = valueDescription.hasPrefix("Optional(")
    return isOptional
}

internal func reencodedSchemaGuess<T: Encodable>(for value: T, using encoder: JSONEncoder) throws -> JSONSchema? {
    let data = try encoder.encode(PrimitiveWrapper(primitive: value))
    let wrappedValue = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
    
    guard
        let wrapperDict = wrappedValue as? [String: Any],
        wrapperDict.contains(where: { $0.key == "primitive" })
    else { throw OpenAPI.EncodableError.primitiveGuessFailed }
    
    let value = (wrappedValue as! [String: Any])["primitive"]!
    
    return try openAPISchemaGuess(for: value, using: encoder)
}

internal func openAPISchemaGuess(for type: Any.Type, using encoder: JSONEncoder) throws -> JSONSchema? {
    let nodeGuess: JSONSchema? = try {
        switch type {
        case let valType as OpenAPISchemaType.Type: return valType.openAPISchema
        case let valType as RawOpenAPISchemaType.Type: return try valType.rawOpenAPISchema()
        case let valType as DateOpenAPISchemaType.Type: return valType.dateOpenAPISchemaGuess(using: encoder)
        case let valType as OpenAPIEncodedSchemaType.Type: return try valType.openAPISchema(using: encoder)
        case let valType as AnyRawRepresentable.Type:
            if valType.rawValueType != valType {
                let guess = try openAPISchemaGuess(for: valType.rawValueType, using: encoder)
                return valType is _OptionalWrapper.Type ? guess?.optionalSchemaObject() : guess
            } else { return nil }
        default: return nil
        }
    }()
    
    return nodeGuess
}

internal func openAPISchemaGuess(for value: Any, using encoder: JSONEncoder) throws -> JSONSchema? {
    let nodeGuess: JSONSchema? = try openAPISchemaGuess(for: type(of: value), using: encoder)
    if nodeGuess != nil { return nodeGuess }
    
    let primitiveGuess: JSONSchema? = try {
        switch value {
        case is String: return .string
        case is Int: return .integer
        case is Double: return .number(format: .double)
        case is Bool: return .boolean
        case is Data: return .string(format: .other("binary"))
        case is DateOpenAPISchemaType: return try reencodedSchemaGuess(for: Date(), using: encoder)
        default: return nil
        }
    }()
    
    return primitiveGuess
}

private struct PrimitiveWrapper<Wrapped: Encodable>: Encodable {
    let primitive: Wrapped
}
