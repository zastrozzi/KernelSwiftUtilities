//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Routes.EnumFilter_v1_0 {
    public func bootEnumFilterRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":filterId".parameterType(UUID.self).description("Enum Filter ID"), use: getEnumFilterHandler)
            .summary("Get Enum Filter")
        routes.get(use: listEnumFiltersHandler).summary("List Enum Filters")
        routes.put(":filterId".parameterType(UUID.self).description("Enum Filter ID"), use: updateEnumFilterHandler)
            .summary("Update Enum Filter")
        routes.delete(":filterId".parameterType(UUID.self).description("Enum Filter ID"), use: deleteEnumFilterHandler)
            .summary( "Delete Enum Filter")
    }
    
    public func bootEnumFilterRoutesForStructuredQuery(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createEnumFilterForQueryHandler).summary("Create Enum Filter for Structured Query").tags(tag)
        routes.get(use: listEnumFiltersHandler).summary("List Enum Filters for Structured Query").tags(tag)
    }
    
    public func bootEnumFilterRoutesForFilterGroup(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createEnumFilterForParentHandler).summary("Create Enum Filter for Filter Group").tags(tag)
        routes.get(use: listEnumFiltersHandler).summary("List Enum Filters for Filter Group").tags(tag)
    }
}

extension KernelDynamicQuery.Routes.EnumFilter_v1_0 {
    public func createEnumFilterForQueryHandler(_ req: TypedRequest<CreateEnumFilterContext>) async throws -> Response {
        try await featureContainer.services.query.createEnumFilter(
            forStructuredQuery: req.parameters.require("queryId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func createEnumFilterForParentHandler(_ req: TypedRequest<CreateEnumFilterContext>) async throws -> Response {
        try await featureContainer.services.query.createEnumFilter(
            forParentGroup: req.parameters.require("groupId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func getEnumFilterHandler(_ req: TypedRequest<GetEnumFilterContext>) async throws -> Response {
        try await featureContainer.services.query.getEnumFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func listEnumFiltersHandler(_ req: TypedRequest<ListEnumFiltersContext>) async throws -> Response {
        try await featureContainer.services.query.listEnumFilters(
            forStructuredQuery: req.parameters.get("queryId"),
            forParentGroup: req.parameters.get("groupId"),
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func updateEnumFilterHandler(_ req: TypedRequest<UpdateEnumFilterContext>) async throws -> Response {
        try await featureContainer.services.query.updateEnumFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func deleteEnumFilterHandler(_ req: TypedRequest<DeleteEnumFilterContext>) async throws -> Response {
        try await featureContainer.services.query.deleteEnumFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.respondOk()
    }
}

extension KernelDynamicQuery.Routes.EnumFilter_v1_0 {
    public typealias CreateEnumFilterContext = PostRouteContext<
        APIModel.EnumFilter.CreateEnumFilterRequest,
        APIModel.EnumFilter.EnumFilterResponse
    >
    
    public typealias GetEnumFilterContext = GetRouteContext<APIModel.EnumFilter.EnumFilterResponse>
    
    public struct ListEnumFiltersContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<APIModel.EnumFilter.EnumFilterResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
    }
    
    public typealias UpdateEnumFilterContext = UpdateRouteContext<
        APIModel.EnumFilter.UpdateEnumFilterRequest,
        APIModel.EnumFilter.EnumFilterResponse
    >
    
    public typealias DeleteEnumFilterContext = DefaultDeleteRouteContextWithForce
}

