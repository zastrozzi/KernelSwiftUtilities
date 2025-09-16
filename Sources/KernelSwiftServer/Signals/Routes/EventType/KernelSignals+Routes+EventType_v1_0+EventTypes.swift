//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelSignals.Routes.EventType_v1_0 {
    public func bootEventTypeRoutes(routes: TypedRoutesBuilder) throws {
        routes.post(use: createEventTypeHandler).summary("Create Event Type")
        routes.get(":eventTypeId".parameterType(UUID.self).description("Event Type ID"), use: getEventTypeHandler)
            .summary("Get Event Type")
        routes.get(use: listEventTypesHandler).summary("List Event Types")
        routes.put(":eventTypeId".parameterType(UUID.self).description("Event Type ID"), use: updateEventTypeHandler)
            .summary("Update Event Type")
        routes.delete(":eventTypeId".parameterType(UUID.self).description("Event Type ID"), use: deleteEventTypeHandler)
            .summary( "Delete Event Type")
        
        let eventTypeSubroutes = routes.typeGrouped(":eventTypeId".parameterType(UUID.self).description("Event Type ID"))
        try eventTypeSubroutes.register(collection: KernelSignals.Routes.Event_v1_0(forContext: .eventType))
    }
}

extension KernelSignals.Routes.EventType_v1_0 {
    public func createEventTypeHandler(_ req: TypedRequest<CreateEventTypeContext>) async throws -> Response {
        try await featureContainer.services.eventType.createEventType(
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func getEventTypeHandler(_ req: TypedRequest<GetEventTypeContext>) async throws -> Response {
        try await featureContainer.services.eventType.getEventType(
            id: req.parameters.require("eventTypeId", as: UUID.self),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func listEventTypesHandler(_ req: TypedRequest<ListEventTypesContext>) async throws -> Response {
        try await featureContainer.services.eventType.listEventTypes(
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            eventIdentifierFilters: req.query.eventIdentifier,
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
        
    }
    
    public func updateEventTypeHandler(_ req: TypedRequest<UpdateEventTypeContext>) async throws -> Response {
        try await featureContainer.services.eventType.updateEventType(
            id: req.parameters.require("eventTypeId", as: UUID.self),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func deleteEventTypeHandler(_ req: TypedRequest<DeleteEventTypeContext>) async throws -> Response {
        try await featureContainer.services.eventType.deleteEventType(
            id: req.parameters.require("eventTypeId", as: UUID.self),
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.respondOk()
    }
}

extension KernelSignals.Routes.EventType_v1_0 {
    public typealias CreateEventTypeContext = PostRouteContext<
        KernelSignals.Core.APIModel.CreateEventTypeRequest,
        KernelSignals.Core.APIModel.EventTypeResponse
    >
    
    public typealias GetEventTypeContext = GetRouteContext<KernelSignals.Core.APIModel.EventTypeResponse>
    
    public struct ListEventTypesContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<KernelSignals.Core.APIModel.EventTypeResponse>> = .success(.ok)
        
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
    
    public typealias UpdateEventTypeContext = UpdateRouteContext<
        KernelSignals.Core.APIModel.UpdateEventTypeRequest,
        KernelSignals.Core.APIModel.EventTypeResponse
    >
    
    public typealias DeleteEventTypeContext = DefaultDeleteRouteContextWithForce
}
