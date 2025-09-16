//
//  File.swift
//  UnionCDP
//
//  Created by Jonathan Forbes on 07/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelSignals.Core.APIModel {
    public struct InboundEventRequest: OpenAPIContent {
        public var eventIdentifier: String
        public var payload: EventPayload
        
        public init(
            eventIdentifier: String,
            payload: EventPayload
        ) {
            self.eventIdentifier = eventIdentifier
            self.payload = payload
        }
    }
    
    public struct SimpleInboundEventRequest: OpenAPIContent {
        public var eventIdentifier: String
        public var payload: [String: AnyJSONCodable]
        
        public init(
            eventIdentifier: String,
            payload: [String: AnyJSONCodable]
        ) {
            self.eventIdentifier = eventIdentifier
            self.payload = payload
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            eventIdentifier = try container.decode(String.self, forKey: .eventIdentifier)
            payload = try container.decode([String: AnyJSONCodable].self, forKey: .payload)
        }
        
        public func decodeForSchema(_ schema: EventPayloadSchema) throws -> InboundEventRequest {
            let encoder = JSONEncoder()
            guard let encoded = try? encoder.encode(payload) else {
                throw Abort(.unprocessableEntity, reason: "Payload failed Data conversion")
            }
            guard let json = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else {
                throw Abort(.unprocessableEntity, reason: "Payload must be a JSON object")
            }
            
            var eventProps: EventPayload = [:]
            for (schemaKey, schemaValue) in schema {
                if  let value = json[schemaKey],
                    let eventProp = try? EventProp.decode(from: value, for: schemaValue)
                {
                    eventProps[schemaKey] = eventProp
                }
            }
            
            return .init(eventIdentifier: eventIdentifier, payload: eventProps)
        }
        
        public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
            .object(
                properties: [
                    "eventIdentifier": .string,
                    "payload": .object
                ]
            )
        }
        
        public static func openAPIExample(using encoder: JSONEncoder) throws -> AnyCodable? {
            return .init(dictionaryLiteral:
                ("eventIdentifier", "SomeEvent"),
                ("payload", ["foo": "bar"])
            )
        }
    }
}
