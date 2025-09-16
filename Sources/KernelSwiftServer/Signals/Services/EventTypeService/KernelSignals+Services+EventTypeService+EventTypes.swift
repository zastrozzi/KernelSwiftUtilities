//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelSignals.Services.EventTypeService {
    public func createEventType(
        from requestBody: APIModel.CreateEventTypeRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelSignals.Fluent.Model.EventType {
        try platformActor.systemOrAdmin()
        return try await .create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func getEventType(
        id eventTypeId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelSignals.Fluent.Model.EventType {
        try await .findOrThrow(eventTypeId, on: selectDB(db)) {
            Abort(.notFound, reason: "EventType not found")
        }
    }
    
    public func getEventType(
        identifier eventIdentifier: String,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelSignals.Fluent.Model.EventType {
        try await .findOrThrow(\.$eventIdentifier, equals: eventIdentifier, on: selectDB(db)) {
            Abort(.notFound, reason: "EventType not found")
        }
    }
    
    public func listEventTypes(
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        eventIdentifierFilters: StringFilterQueryParamObject? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelSignals.Fluent.Model.EventType> {
        let eventTypeQuery = KernelSignals.Fluent.Model.EventType.makeQuery(on: try selectDB(db))
        
        let dateFilters = eventTypeQuery()
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
        
        let stringFilters = eventTypeQuery()
            .filterIfPresent(\.$eventIdentifier, stringFilters: eventIdentifierFilters)
        
        let enumFilters = eventTypeQuery()
        
        let relationFilters = eventTypeQuery()
        
        let eventTypeCount = try await eventTypeQuery()
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, stringFilters, enumFilters, relationFilters)
            .count()
        
        let eventTypes = try await eventTypeQuery()
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, stringFilters, enumFilters, relationFilters)
            .paginatedSort(pagination)
            .all()
        
        return .init(results: eventTypes, total: eventTypeCount)
    }
    
    public func updateEventType(
        id eventTypeId: UUID,
        from requestBody: APIModel.UpdateEventTypeRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelSignals.Fluent.Model.EventType {
        try platformActor.systemOrAdmin()
        return try await .update(
            id: eventTypeId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteEventType(
        id eventTypeId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let eventType = try await getEventType(id: eventTypeId, on: db, as: platformActor)
        try await KernelSignals.Fluent.Model.EventType.delete(
            force: force,
            id: eventType.requireID(),
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}
