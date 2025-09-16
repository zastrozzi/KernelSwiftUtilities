//
//  File.swift
//  UnionCDP
//
//  Created by Jonathan Forbes on 07/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelSignals.Core.APIModel {
    public struct EventPayload: OpenAPIContent, Collection, ExpressibleByDictionaryLiteral {
        public typealias DatabaseStorage = Dictionary<String, AnyJSONCodable>
        public typealias Storage = [String : EventProp]
        public typealias Index = Storage.Index
        public typealias Element = Storage.Element
        public typealias Key = String
        public typealias Value = EventProp
        
        private var underlyingStorage = Storage()
        
        init(from underlyingStorage: [String : EventProp]) {
            self.underlyingStorage = underlyingStorage
        }
        
        public var startIndex: Index { return underlyingStorage.startIndex }
        public var endIndex: Index { return underlyingStorage.endIndex }
        
        public subscript(index: Index) -> Element {
            get { return underlyingStorage[index] }
        }
        
        public subscript(fieldName: String) -> EventProp {
            get { return underlyingStorage[fieldName] ?? .null }
            set { underlyingStorage[fieldName] = newValue }
        }

        public func index(after i: EventPayload.Storage.Index) -> EventPayload.Storage.Index {
            return underlyingStorage.index(after: i)
        }
        
        
        public init(dictionaryLiteral elements: (String, EventProp)...) {
            for (fieldName, propType) in elements {
                underlyingStorage[fieldName] = propType
            }
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let dictionaryValue = try container.decode(Storage.self)
            self.init(from: dictionaryValue)
        }
        
        public func encode(to encoder: any Encoder) throws {
            try underlyingStorage.encode(to: encoder)
        }
        
        public func toDatabaseStorage() throws -> DatabaseStorage {
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()
            guard let encoded = try? encoder.encode(self) else {
                throw Abort(.unprocessableEntity, reason: "Payload failed Data conversion")
            }
            return try decoder.decode(DatabaseStorage.self, from: encoded)
        }
        
        public static func fromDatabaseStorage(_ storage: DatabaseStorage, forSchema schema: EventPayloadSchema) throws -> EventPayload {
            let encoder = JSONEncoder()
            guard let encoded = try? encoder.encode(storage) else {
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
            return eventProps
        }
        
        public static var sample: KernelSignals.Core.APIModel.EventPayload {
            [
                "userId": .uuid(.sample),
                "timestamps": .dictionary([
                    "sessionStart": .date(.sample),
                    "sessionEnd": .date(.sample)
                ]),
                "referrerUrl": .string("https://example.com"),
                "sessionActions": .array([
                    .dictionary([
                        "actionName": .string("SessionStart"),
                        "wasSuccessful": .boolean(true)
                    ]),
                    .dictionary([
                        "actionName": .string("SessionEnd"),
                        "wasSuccessful": .boolean(true)
                    ])
                ])
            ]
        }
        
        public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
            return .object(
                .init(format: .generic),
                .init(properties: [:], additionalProperties: .init(EventProp.openAPISchema))
            )
        }
    }
}

