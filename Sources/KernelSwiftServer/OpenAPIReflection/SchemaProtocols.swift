//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import OpenAPIKit30
import KernelSwiftCommon

public protocol OpenAPIEncodedSchemaType {
    static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema
}

extension OpenAPIEncodedSchemaType where Self: KernelSwiftCommon.Sampleable, Self: Encodable {
    public static func openAPISchemaWithExample(using encoder: JSONEncoder = OpenAPI.jsonEncoder) throws -> JSONSchema {
        let exampleData = try encoder.encode(Self.successSample ?? Self.sample)
        let example = try OpenAPI.jsonDecoder.decode(AnyCodable.self, from: exampleData)
        return try openAPISchema(using: encoder).with(example: example)
    }
    
    public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
        return try genericOpenAPISchemaGuess(using: encoder)
    }
}

public protocol RawOpenAPISchemaType {
    static func rawOpenAPISchema() throws -> JSONSchema
}

extension RawOpenAPISchemaType where Self: RawRepresentable, RawValue: OpenAPISchemaType {
    public static func rawOpenAPISchema() throws -> JSONSchema {
        return RawValue.openAPISchema
    }
}

public protocol DateOpenAPISchemaType {
    static func dateOpenAPISchemaGuess(using encoder: JSONEncoder) -> JSONSchema?
}

public protocol OpenAPIStringEnumSampleable: KernelSwiftCommon.Sampleable, RawOpenAPISchemaType, RawRepresentable, CaseIterable, Codable, Sendable {}
public protocol OpenAPIEncodableSampleable: KernelSwiftCommon.Sampleable, OpenAPIEncodedSchemaType, SampleableOpenAPIExampleProvider, Sendable {
    static var sample: Self { get }
}

extension OpenAPIEncodableSampleable where Self: Decodable {
    public static var sample: Self {
        
        guard let sampled = try? Self.randomInstance() else {
            
            return "" as! Self
        }
        return sampled
    }
}

public extension OpenAPIStringEnumSampleable {
    static var sample: Self { Self.allCases.randomElement()! }
    static var samples: [Self] { Self.allCases as! [Self] }
}


extension OpenAPIStringEnumSampleable {
    public static func rawOpenAPISchema() throws -> JSONSchema {
        let allowedValues = Self.allCases.map { AnyCodable(stringLiteral: $0.rawValue as? String ?? "") }
        return JSONSchema.string(allowedValues: allowedValues)
    }
}

extension Array: KernelSwiftCommon.Sampleable where Element: KernelSwiftCommon.Sampleable & Decodable {
    public static var sample: Array<Element> { Element.samples }
}

extension Array: KernelSwiftCommon.AbstractSampleable, RawOpenAPISchemaType {
    public static var abstractSample: Any {
        guard let t = (Self.Element.self as Any) as? any OpenAPIStringEnumSampleable.Type else { fatalError() }
        return t.allCases as any Collection
    }
    
    public static func rawOpenAPISchema() throws -> JSONSchema {
        if let t = (Self.Element.self as Any) as? any OpenAPIStringEnumSampleable.Type {
            let allowedValues = (t.allCases as! Array<any RawRepresentable>).map { AnyCodable(stringLiteral: String(describing: $0.rawValue))}
    //        let allowedValues = Self.Element.allCases.map { AnyCodable(stringLiteral: $0.rawValue as? String ?? "") }
            return JSONSchema.array(items: JSONSchema.string(allowedValues: allowedValues))
        }
        else if let st = (Self.Element.self as Any) as? any SampleableOpenAPIExampleProvider.Type {
            return try JSONSchema.array(items: st.openAPISchema())
        }
        else if let encSt = (Self.Element.self as Any) as? any OpenAPIEncodableSampleable.Type {
            return try JSONSchema.array(items: encSt.openAPISchema())
        }
        else if let raw = (Self.Element.self as Any) as? any RawOpenAPISchemaType.Type {
            return try JSONSchema.array(items: raw.rawOpenAPISchema())
        }
        else {
            print("FAILED HERE")
            throw OpenAPI.EncodableError.primitiveGuessFailed
//            fatalError()
        }
    }
}

public protocol SampleableOpenAPIExampleProvider: OpenAPIExampleProvider, Encodable, KernelSwiftCommon.Sampleable {}
