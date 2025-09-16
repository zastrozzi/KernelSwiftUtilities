//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/06/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelFluentModel.Audit {
    public struct EventResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public let id: UUID
        public let dbCreatedAt: Date
        public let schema: String
        public let table: String
        public let affectedId: UUID
        public let eventType: EventActionType
        public let eventData: [String: EventFieldData]
        public let platformActorType: String
        public let platformActorId: UUID?
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            schema: String,
            table: String,
            affectedId: UUID,
            eventType: EventActionType,
            eventData: [String: EventFieldData],
            platformActor: KernelIdentity.Core.Model.PlatformActor
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.schema = schema
            self.table = table
            self.affectedId = affectedId
            self.eventType = eventType
            self.eventData = eventData
            self.platformActorType = switch platformActor {
            case .adminUser: "adminUser"
            case .enduser: "enduser"
            case .otherUser: "otherUser"
            case .none: "none"
            case .system: "system"
            }
            do { self.platformActorId = try platformActor.userId() }
            catch { self.platformActorId = nil }
        }
    }
}
