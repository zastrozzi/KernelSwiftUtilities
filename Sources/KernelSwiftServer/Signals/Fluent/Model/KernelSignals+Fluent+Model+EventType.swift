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
    public final class EventType: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.eventType
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Field(key: "event_identifier") public var eventIdentifier: String
        @Field(key: "payload_schema") public var payloadSchema: APIModel.EventPayloadSchema
        
        public init() {}
    }
}

extension KernelSignals.Fluent.Model.EventType: CRUDModel {
    public typealias CreateDTO = KernelSignals.Core.APIModel.CreateEventTypeRequest
    public typealias UpdateDTO = KernelSignals.Core.APIModel.UpdateEventTypeRequest
    public typealias ResponseDTO = KernelSignals.Core.APIModel.EventTypeResponse
    
    public static func createFields(
        from dto: CreateDTO,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        let model = Self.init()
        model.eventIdentifier = dto.eventIdentifier
        model.payloadSchema = dto.payloadSchema
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.eventIdentifier, from: dto.eventIdentifier)
        try model.updateIfChanged(\.payloadSchema, from: dto.payloadSchema)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            eventIdentifier: eventIdentifier,
            payloadSchema: payloadSchema
        )
    }
}
