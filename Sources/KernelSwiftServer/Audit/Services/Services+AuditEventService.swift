//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/5/24.
//

import Foundation
import Vapor
import KernelSwiftCommon
import Fluent

extension KernelAudit.Services {
    public struct AuditEventService: DBAccessible, Sendable {
        @KernelDI.Injected(\.vapor) public var app
        public typealias FeatureContainer = KernelAudit
        
        public func listEvents(
            forActor queryPlatformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
            eventType: KernelFluentModel.Audit.EventActionType? = nil,
            forModel queryModel: KernelFluentModel.Audit.EventIdentifier? = nil,
            withPagination pagination: DefaultPaginatedQueryParams,
            on db: DatabaseID? = nil,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> PaginatedPgResult<KernelFluentModel.Audit.Event> {
            try platformActor.systemOrAdmin()
            let eventCount = try await KernelFluentModel.Audit.Event.query(on: try selectDB(db))
                .includeDeleted(pagination.includeDeleted)
                .filterIfPresent(\.$platformActor, .equal, queryPlatformActor)
                .filterIfPresent(\.$eventType, .equal, eventType)
                .filterIfPresent(\.$affectedSchema, .equal, queryModel?.schema)
                .filterIfPresent(\.$affectedTable, .equal, queryModel?.table)
                .filterIfPresent(\.$affectedId, .equal, queryModel?.id)
                .count()
            
            let events = try await KernelFluentModel.Audit.Event.query(on: try selectDB(db))
                .includeDeleted(pagination.includeDeleted)
                .filterIfPresent(\.$platformActor, .equal, queryPlatformActor)
                .filterIfPresent(\.$eventType, .equal, eventType)
                .filterIfPresent(\.$affectedSchema, .equal, queryModel?.schema)
                .filterIfPresent(\.$affectedTable, .equal, queryModel?.table)
                .filterIfPresent(\.$affectedId, .equal, queryModel?.id)
                .paginatedSort(pagination)
                .all()
            return .init(results: events, total: eventCount)
        }
    }
}
