//
//  File.swift
//  UnionCDP
//
//  Created by Jonathan Forbes on 07/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelSignals.Core.APIModel {
    public struct EventPayloadSchema: OpenAPIContent, Collection, ExpressibleByDictionaryLiteral, FluentSerialisationSchema {
        public typealias SerialisableValue = EventPayload
        
        public typealias Storage = [String : RawEventPropType]
        public typealias Index = Storage.Index
        public typealias Element = Storage.Element
        public typealias Key = String
        public typealias Value = RawEventPropType
        
        private var underlyingStorage = Storage()
        
        init(from underlyingStorage: [String : RawEventPropType]) {
            self.underlyingStorage = underlyingStorage
        }
        
        public var startIndex: Index { return underlyingStorage.startIndex }
        public var endIndex: Index { return underlyingStorage.endIndex }
        
        public subscript(index: Index) -> Element {
            get { return underlyingStorage[index] }
        }
        
        public subscript(fieldName: String) -> RawEventPropType {
            get { return underlyingStorage[fieldName] ?? .null }
            set { underlyingStorage[fieldName] = newValue }
        }
        
        public func index(after i: EventPayloadSchema.Storage.Index) -> EventPayloadSchema.Storage.Index {
            return underlyingStorage.index(after: i)
        }
        
        
        public init(dictionaryLiteral elements: (String, RawEventPropType)...) {
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
        
        public static var sample: KernelSignals.Core.APIModel.EventPayloadSchema {
            [
                "userId": .uuid,
                "timestamps": .dictionary([
                    "sessionStart": .date,
                    "sessionEnd": .date
                ]),
                "referrerUrl": .string,
                "sessionActions": .array(
                    .dictionary([
                        "actionName": .string,
                        "wasSuccessful": .boolean
                    ])
                )
            ]
        }
        
        public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
            return .object(
                .init(format: .generic),
                .init(properties: [:], additionalProperties: .init(RawEventPropType.openAPISchema))
            )
        }
        
        public func serialise(_ value: KernelSignals.Core.APIModel.EventPayload) throws -> Data {
            let encoder = JSONEncoder()
            guard let encoded = try? encoder.encode(value) else {
                throw Abort(.unprocessableEntity, reason: "Payload failed Data conversion")
            }
            return encoded
        }
        
        public func deserialise(_ data: Data) throws -> KernelSignals.Core.APIModel.EventPayload {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                throw Abort(.unprocessableEntity, reason: "Payload must be a JSON object")
            }
            
            var eventProps: EventPayload = [:]
            for (schemaKey, schemaValue) in self {
                if  let value = json[schemaKey],
                    let eventProp = try? EventProp.decode(from: value, for: schemaValue)
                {
                    eventProps[schemaKey] = eventProp
                }
            }
            return eventProps
        }
    }
}
