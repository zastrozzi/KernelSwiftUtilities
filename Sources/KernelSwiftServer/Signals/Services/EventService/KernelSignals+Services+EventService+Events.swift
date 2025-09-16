//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelSignals.Services.EventService {
    @discardableResult
    public func handleEvent(
        from requestBody: APIModel.SimpleInboundEventRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelSignals.Fluent.Model.Event {
        let eventType = try await featureContainer.services.eventType.getEventType(
            identifier: requestBody.eventIdentifier,
            as: platformActor
        )
        let decodedEvent = try requestBody.decodeForSchema(eventType.payloadSchema)
        return try await .create(
            from: decodedEvent,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(
                eventTypeId: eventType.requireID(),
                payloadSchema: eventType.payloadSchema
            )
        )
    }
    
    public func getEvent(
        id eventId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelSignals.Fluent.Model.Event {
        try await .findOrThrow(eventId, on: selectDB(db)) {
            Abort(.notFound, reason: "Event not found")
        }
    }
    
    public func listEvents(
        forEventType eventTypeId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        eventIdentifierFilters: StringFilterQueryParamObject? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelSignals.Fluent.Model.Event> {
        let eventQuery = KernelSignals.Fluent.Model.Event.makeQuery(on: try selectDB(db))
        
        let dateFilters = eventQuery()
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
        
        let stringFilters = eventQuery()
            .filterIfPresent(\.$eventIdentifier, stringFilters: eventIdentifierFilters)
        
        let enumFilters = eventQuery()
        
        let relationFilters = eventQuery()
            .filterIfPresent(\.$eventType.$id, .equal, eventTypeId)
        
        let eventCount = try await eventQuery()
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, stringFilters, enumFilters, relationFilters)
            .count()
        
        let events = try await eventQuery()
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, stringFilters, enumFilters, relationFilters)
            .paginatedSort(pagination)
            .all()
        
        return .init(results: events, total: eventCount)
    }
    
    //    public func updateEvent(
    //        id eventId: UUID,
    //        from requestBody: APIModel.Event.UpdateEventRequest,
    //        on db: DatabaseID? = nil,
    //        as platformActor: KernelIdentity.Core.Model.PlatformActor
    //    ) async throws -> Ether.Fluent.Model.Event {
    //        return try await .update(
    //            id: eventId,
    //            from: requestBody,
    //            onDB: selectDB(db),
    //            withAudit: true,
    //            as: platformActor
    //        )
    //    }
    
    public func deleteEvent(
        id eventId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let event = try await getEvent(id: eventId, on: db, as: platformActor)
        try await KernelSignals.Fluent.Model.Event.delete(
            force: force,
            id: event.requireID(),
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}
