//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import OpenAPIKit30

extension Date: DateOpenAPISchemaType {
    public static func dateOpenAPISchemaGuess(using encoder: JSONEncoder) -> JSONSchema? {
        switch encoder.dateEncodingStrategy {
        case .deferredToDate, .custom:
            return nil

        case .secondsSince1970,
             .millisecondsSince1970:
            return .number(format: .double)

        case .iso8601:
            return .string(format: .dateTime)

        case .formatted(let formatter):
            let hasTime = formatter.timeStyle != .none
            let format: JSONTypeFormat.StringFormat = hasTime ? .dateTime : .date

            return .string(format: format)

        @unknown default:
            return nil
        }
    }
}

extension Date: OpenAPIEncodedSchemaType {
    public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
        guard let dateSchema: JSONSchema = try openAPISchemaGuess(for: Date(), using: encoder) else {
            throw OpenAPI.TypeError.unknownSchemaType(type(of: self))
        }

        return dateSchema
    }
}

extension Date: OpenAPIEncodableSampleable {}
