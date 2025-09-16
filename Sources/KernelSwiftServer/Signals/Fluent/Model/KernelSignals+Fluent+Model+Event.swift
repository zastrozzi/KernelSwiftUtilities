//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelSignals.Fluent.Model {
    public final class Event: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.event
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Field(key: "event_identifier") public var eventIdentifier: String
        //        @SchemaSerialisableField(key: "payload", schemaKey: "payload_schema") public var payload: FluentSerialisationContainer< Ether.Core.APIModel.Event.EventPayloadSchema>
        @Field(key: "payload") public var payload: APIModel.EventPayload.DatabaseStorage
        @Field(key: "payload_schema") public var payloadSchema: APIModel.EventPayloadSchema
        @Parent(key: "event_type_id") public var eventType: EventType
        
        public init() {}
        
        public func validatedPayload() throws -> APIModel.EventPayload {
            try .fromDatabaseStorage(payload, forSchema: payloadSchema)
        }
    }
}

extension KernelSignals.Fluent.Model.Event: CRUDModel {
    public typealias CreateDTO = KernelSignals.Core.APIModel.InboundEventRequest
    public typealias UpdateDTO = KernelSignals.Core.APIModel.InboundEventRequest
    public typealias ResponseDTO = KernelSignals.Core.APIModel.EventResponse
    
    public struct CreateOptions: Sendable {
        public var eventTypeId: UUID
        public var payloadSchema: KernelSignals.Core.APIModel.EventPayloadSchema
        
        public init(
            eventTypeId: UUID,
            payloadSchema: KernelSignals.Core.APIModel.EventPayloadSchema
        ) {
            self.eventTypeId = eventTypeId
            self.payloadSchema = payloadSchema
        }
    }
    
    public static func createFields(
        from dto: CreateDTO,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        guard let options else { throw Abort(.badRequest, reason: "No Create Options provided") }
        let model = Self.init()
        model.eventIdentifier = dto.eventIdentifier
        model.payload = try dto.payload.toDatabaseStorage()
        model.payloadSchema = options.payloadSchema
        model.$eventType.id = options.eventTypeId
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.eventIdentifier, from: dto.eventIdentifier)
        //        try model.updateIfChanged(\.payload, from: dto.payload)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            eventIdentifier: eventIdentifier,
            payload: try validatedPayload(),
            eventTypeId: $eventType.id
        )
    }
}
