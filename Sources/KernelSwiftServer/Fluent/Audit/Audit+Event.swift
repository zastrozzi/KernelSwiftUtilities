//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/06/2024.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelFluentModel.Audit {
    public final class Event: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.auditEvent
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        
        @Field(key: "affected_schema") public var affectedSchema: String
        @Field(key: "affected_table") public var affectedTable: String
        @Field(key: "affected_id") public var affectedId: UUID
        @KernelEnum(key: "event_type") public var eventType: EventActionType
        @Field(key: "event_data") public var eventData: [String: EventFieldData]
        @Field(key: "platform_actor") public var platformActor: KernelIdentity.Core.Model.PlatformActor
        
        public init() {}
        
        public func response() -> EventResponse {
            return .init(
                id: self.id!,
                dbCreatedAt: self.dbCreatedAt!,
                schema: self.affectedSchema,
                table: self.affectedTable,
                affectedId: self.affectedId,
                eventType: self.eventType,
                eventData: self.eventData,
                platformActor: self.platformActor
            )
        }
    }
    
    public struct Event_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.auditEvent)
                .id()
                .field("db_created_at", .datetime)
                .field("affected_schema", .string, .required)
                .field("affected_table", .string, .required)
                .field("affected_id", .uuid, .required)
                .field("event_type", .enum(EventActionType.toFluentEnum()), .required)
                .field("event_data", .json, .required)
                .field("platform_actor", .json, .required)
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.auditEvent).delete()
        }
    }
}
