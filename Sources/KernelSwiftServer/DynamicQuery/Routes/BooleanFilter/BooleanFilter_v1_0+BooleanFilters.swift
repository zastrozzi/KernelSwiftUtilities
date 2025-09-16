//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Routes.BooleanFilter_v1_0 {
    public func bootBooleanFilterRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":filterId".parameterType(UUID.self).description("Boolean Filter ID"), use: getBooleanFilterHandler)
            .summary("Get Boolean Filter")
        routes.get(use: listBooleanFiltersHandler).summary("List Boolean Filters")
        routes.put(":filterId".parameterType(UUID.self).description("Boolean Filter ID"), use: updateBooleanFilterHandler)
            .summary("Update Boolean Filter")
        routes.delete(":filterId".parameterType(UUID.self).description("Boolean Filter ID"), use: deleteBooleanFilterHandler)
            .summary( "Delete Boolean Filter")
    }
    
    public func bootBooleanFilterRoutesForStructuredQuery(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createBooleanFilterForQueryHandler).summary("Create Boolean Filter for Structured Query").tags(tag)
        routes.get(use: listBooleanFiltersHandler).summary("List Boolean Filters for Structured Query").tags(tag)
    }
    
    public func bootBooleanFilterRoutesForFilterGroup(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createBooleanFilterForParentHandler).summary("Create Boolean Filter for Filter Group").tags(tag)
        routes.get(use: listBooleanFiltersHandler).summary("List Boolean Filters for Filter Group").tags(tag)
    }
}

extension KernelDynamicQuery.Routes.BooleanFilter_v1_0 {
    public func createBooleanFilterForQueryHandler(_ req: TypedRequest<CreateBooleanFilterContext>) async throws -> Response {
        try await featureContainer.services.query.createBooleanFilter(
            forStructuredQuery: req.parameters.require("queryId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func createBooleanFilterForParentHandler(_ req: TypedRequest<CreateBooleanFilterContext>) async throws -> Response {
        try await featureContainer.services.query.createBooleanFilter(
            forParentGroup: req.parameters.require("groupId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func getBooleanFilterHandler(_ req: TypedRequest<GetBooleanFilterContext>) async throws -> Response {
        try await featureContainer.services.query.getBooleanFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func listBooleanFiltersHandler(_ req: TypedRequest<ListBooleanFiltersContext>) async throws -> Response {
        try await featureContainer.services.query.listBooleanFilters(
            forStructuredQuery: req.parameters.get("queryId"),
            forParentGroup: req.parameters.get("groupId"),
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func updateBooleanFilterHandler(_ req: TypedRequest<UpdateBooleanFilterContext>) async throws -> Response {
        try await featureContainer.services.query.updateBooleanFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func deleteBooleanFilterHandler(_ req: TypedRequest<DeleteBooleanFilterContext>) async throws -> Response {
        try await featureContainer.services.query.deleteBooleanFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.respondOk()
    }
}

extension KernelDynamicQuery.Routes.BooleanFilter_v1_0 {
    public typealias CreateBooleanFilterContext = PostRouteContext<
        APIModel.BooleanFilter.CreateBooleanFilterRequest,
        APIModel.BooleanFilter.BooleanFilterResponse
    >
    
    public typealias GetBooleanFilterContext = GetRouteContext<APIModel.BooleanFilter.BooleanFilterResponse>
    
    public struct ListBooleanFiltersContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<APIModel.BooleanFilter.BooleanFilterResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
    }
    
    public typealias UpdateBooleanFilterContext = UpdateRouteContext<
        APIModel.BooleanFilter.UpdateBooleanFilterRequest,
        APIModel.BooleanFilter.BooleanFilterResponse
    >
    
    public typealias DeleteBooleanFilterContext = DefaultDeleteRouteContextWithForce
}

