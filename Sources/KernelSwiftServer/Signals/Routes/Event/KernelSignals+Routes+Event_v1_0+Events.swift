//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelSignals.Routes.Event_v1_0 {
    public func bootEventRoutes(routes: TypedRoutesBuilder) throws {
        routes.post(use: handleInboundEventHandler).summary( "Handle Inbound Event")
        routes.get(":eventId".parameterType(UUID.self).description("Event ID"), use: getEventHandler)
            .summary("Get Event")
        routes.get(use: listEventsHandler).summary("List Events")
        routes.delete(":eventId".parameterType(UUID.self).description("Event ID"), use: deleteEventHandler)
            .summary( "Delete Event")
    }
    
    public func bootEventRoutesForEventType(routes: TypedRoutesBuilder, tag: String) throws {
        routes.get(use: listEventsHandler).summary("List Events for Event Type").tags(tag)
    }
}

extension KernelSignals.Routes.Event_v1_0 {
    public func handleInboundEventHandler(_ req: TypedRequest<HandleInboundEventContext>) async throws -> Response {
        try await featureContainer.services.event.handleEvent(
            from: req.decodeBody(),
            as: req.platformActor
        )
        return try await req.respondAccepted()
    }
    
    public func getEventHandler(_ req: TypedRequest<GetEventContext>) async throws -> Response {
        try await featureContainer.services.event.getEvent(
            id: req.parameters.require("eventId", as: UUID.self),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func listEventsHandler(_ req: TypedRequest<ListEventsContext>) async throws -> Response {
        try await featureContainer.services.event.listEvents(
            forEventType: req.parameters.get("eventTypeId"),
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            eventIdentifierFilters: req.query.eventIdentifier,
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
        
    }
    
    public func deleteEventHandler(_ req: TypedRequest<DeleteEventContext>) async throws -> Response {
        try await featureContainer.services.event.deleteEvent(
            id: req.parameters.require("eventId", as: UUID.self),
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.respondOk()
    }
}

extension KernelSignals.Routes.Event_v1_0 {
    public typealias HandleInboundEventContext = PostRouteContext<
        KernelSignals.Core.APIModel.SimpleInboundEventRequest,
        KernelSwiftCommon.Networking.HTTP.EmptyResponse
    >
    
    public typealias GetEventContext = GetRouteContext<KernelSignals.Core.APIModel.EventResponse>
    
    public struct ListEventsContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<KernelSignals.Core.APIModel.EventResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
        public let eventIdentifier: StringFilterQueryParam = .init(name: "event_identifier")
    }
    
    public typealias DeleteEventContext = DefaultDeleteRouteContextWithForce
}
