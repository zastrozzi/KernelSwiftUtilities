//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import OpenAPIKit30
import KernelSwiftCommon
import Vapor

public protocol OpenAPIExampleProvider: OpenAPIEncodedSchemaType {
    static func openAPIExample(using encoder: JSONEncoder) throws -> AnyCodable?
}

public protocol OpenAPINamedExampleProvider: OpenAPIEncodedSchemaType {
    static var openAPIExamples: OpenAPI.Example.Map { get }
}

extension OpenAPIExampleProvider where Self: Encodable, Self: KernelSwiftCommon.Sampleable {
    public static func openAPIExample(using encoder: JSONEncoder) throws -> AnyCodable? {
        
        let encodedSelf = try encoder.encode(sample)
        return try OpenAPI.jsonDecoder.decode(AnyCodable.self, from: encodedSelf)
    }
    
    /// Get the OpenAPI schema for the `OpenAPIExampleProvider`.
    public static func openAPISchema() throws -> JSONSchema {
//        let encoder = try ContentConfiguration.global.openAPIJSONEncoder()
        
        return try self.openAPISchema(using: OpenAPI.jsonEncoder)
    }
    
    /// Get the OpenAPI schema for the `OpenAPIExampleProvider`.
    public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
        return try genericOpenAPISchemaGuess(using: encoder)
    }
}

extension ContentConfiguration {
    /// The configured JSON encoder for the content configuration.
    func jsonEncoder() throws -> JSONEncoder {
        guard let encoder = try self
            .requireEncoder(for: .json)
                as? JSONEncoder
        else {
            // This is an Abort since this is an error with a Vapor component.
            throw Abort(
                .internalServerError, reason: "Couldn't get encoder for OpenAPI schema.")
        }

        return encoder
    }

    /// The content JSON encoder, but with the settings to encode an OpenAPI schema.
    func openAPIJSONEncoder() throws -> JSONEncoder {
        let encoder = try self.jsonEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .sortedKeys

        return encoder
    }
}
