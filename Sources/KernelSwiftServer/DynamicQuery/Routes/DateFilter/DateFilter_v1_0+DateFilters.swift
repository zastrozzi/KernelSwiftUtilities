//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Routes.DateFilter_v1_0 {
    public func bootDateFilterRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":filterId".parameterType(UUID.self).description("Date Filter ID"), use: getDateFilterHandler)
            .summary("Get Date Filter")
        routes.get(use: listDateFiltersHandler).summary("List Date Filters")
        routes.put(":filterId".parameterType(UUID.self).description("Date Filter ID"), use: updateDateFilterHandler)
            .summary("Update Date Filter")
        routes.delete(":filterId".parameterType(UUID.self).description("Date Filter ID"), use: deleteDateFilterHandler)
            .summary( "Delete Date Filter")
    }
    
    public func bootDateFilterRoutesForStructuredQuery(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createDateFilterForQueryHandler).summary("Create Date Filter for Structured Query").tags(tag)
        routes.get(use: listDateFiltersHandler).summary("List Date Filters for Structured Query").tags(tag)
    }
    
    public func bootDateFilterRoutesForFilterGroup(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createDateFilterForParentHandler).summary("Create Date Filter for Filter Group").tags(tag)
        routes.get(use: listDateFiltersHandler).summary("List Date Filters for Filter Group").tags(tag)
    }
}

extension KernelDynamicQuery.Routes.DateFilter_v1_0 {
    public func createDateFilterForQueryHandler(_ req: TypedRequest<CreateDateFilterContext>) async throws -> Response {
        try await featureContainer.services.query.createDateFilter(
            forStructuredQuery: req.parameters.require("queryId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func createDateFilterForParentHandler(_ req: TypedRequest<CreateDateFilterContext>) async throws -> Response {
        try await featureContainer.services.query.createDateFilter(
            forParentGroup: req.parameters.require("groupId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func getDateFilterHandler(_ req: TypedRequest<GetDateFilterContext>) async throws -> Response {
        try await featureContainer.services.query.getDateFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func listDateFiltersHandler(_ req: TypedRequest<ListDateFiltersContext>) async throws -> Response {
        try await featureContainer.services.query.listDateFilters(
            forStructuredQuery: req.parameters.get("queryId"),
            forParentGroup: req.parameters.get("groupId"),
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func updateDateFilterHandler(_ req: TypedRequest<UpdateDateFilterContext>) async throws -> Response {
        try await featureContainer.services.query.updateDateFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func deleteDateFilterHandler(_ req: TypedRequest<DeleteDateFilterContext>) async throws -> Response {
        try await featureContainer.services.query.deleteDateFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.respondOk()
    }
}

extension KernelDynamicQuery.Routes.DateFilter_v1_0 {
    public typealias CreateDateFilterContext = PostRouteContext<
        APIModel.DateFilter.CreateDateFilterRequest,
        APIModel.DateFilter.DateFilterResponse
    >
    
    public typealias GetDateFilterContext = GetRouteContext<APIModel.DateFilter.DateFilterResponse>
    
    public struct ListDateFiltersContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<APIModel.DateFilter.DateFilterResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
    }
    
    public typealias UpdateDateFilterContext = UpdateRouteContext<
        APIModel.DateFilter.UpdateDateFilterRequest,
        APIModel.DateFilter.DateFilterResponse
    >
    
    public typealias DeleteDateFilterContext = DefaultDeleteRouteContextWithForce
}

