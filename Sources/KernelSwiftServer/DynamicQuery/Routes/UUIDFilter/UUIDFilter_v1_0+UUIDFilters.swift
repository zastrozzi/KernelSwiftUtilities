//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Routes.UUIDFilter_v1_0 {
    public func bootUUIDFilterRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":filterId".parameterType(UUID.self).description("UUID Filter ID"), use: getUUIDFilterHandler)
            .summary("Get UUID Filter")
        routes.get(use: listUUIDFiltersHandler).summary("List UUID Filters")
        routes.put(":filterId".parameterType(UUID.self).description("UUID Filter ID"), use: updateUUIDFilterHandler)
            .summary("Update UUID Filter")
        routes.delete(":filterId".parameterType(UUID.self).description("UUID Filter ID"), use: deleteUUIDFilterHandler)
            .summary( "Delete UUID Filter")
    }
    
    public func bootUUIDFilterRoutesForStructuredQuery(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createUUIDFilterForQueryHandler).summary("Create UUID Filter for Structured Query").tags(tag)
        routes.get(use: listUUIDFiltersHandler).summary("List UUID Filters for Structured Query").tags(tag)
    }
    
    public func bootUUIDFilterRoutesForFilterGroup(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createUUIDFilterForParentHandler).summary("Create UUID Filter for Filter Group").tags(tag)
        routes.get(use: listUUIDFiltersHandler).summary("List UUID Filters for Filter Group").tags(tag)
    }
}

extension KernelDynamicQuery.Routes.UUIDFilter_v1_0 {
    public func createUUIDFilterForQueryHandler(_ req: TypedRequest<CreateUUIDFilterContext>) async throws -> Response {
        try await featureContainer.services.query.createUUIDFilter(
            forStructuredQuery: req.parameters.require("queryId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func createUUIDFilterForParentHandler(_ req: TypedRequest<CreateUUIDFilterContext>) async throws -> Response {
        try await featureContainer.services.query.createUUIDFilter(
            forParentGroup: req.parameters.require("groupId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func getUUIDFilterHandler(_ req: TypedRequest<GetUUIDFilterContext>) async throws -> Response {
        try await featureContainer.services.query.getUUIDFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func listUUIDFiltersHandler(_ req: TypedRequest<ListUUIDFiltersContext>) async throws -> Response {
        try await featureContainer.services.query.listUUIDFilters(
            forStructuredQuery: req.parameters.get("queryId"),
            forParentGroup: req.parameters.get("groupId"),
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func updateUUIDFilterHandler(_ req: TypedRequest<UpdateUUIDFilterContext>) async throws -> Response {
        try await featureContainer.services.query.updateUUIDFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func deleteUUIDFilterHandler(_ req: TypedRequest<DeleteUUIDFilterContext>) async throws -> Response {
        try await featureContainer.services.query.deleteUUIDFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.respondOk()
    }
}

extension KernelDynamicQuery.Routes.UUIDFilter_v1_0 {
    public typealias CreateUUIDFilterContext = PostRouteContext<
        APIModel.UUIDFilter.CreateUUIDFilterRequest,
        APIModel.UUIDFilter.UUIDFilterResponse
    >
    
    public typealias GetUUIDFilterContext = GetRouteContext<APIModel.UUIDFilter.UUIDFilterResponse>
    
    public struct ListUUIDFiltersContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<APIModel.UUIDFilter.UUIDFilterResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
    }
    
    public typealias UpdateUUIDFilterContext = UpdateRouteContext<
        APIModel.UUIDFilter.UpdateUUIDFilterRequest,
        APIModel.UUIDFilter.UUIDFilterResponse
    >
    
    public typealias DeleteUUIDFilterContext = DefaultDeleteRouteContextWithForce
}

