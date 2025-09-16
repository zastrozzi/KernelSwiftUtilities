//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Routes.NumericFilter_v1_0 {
    public func bootNumericFilterRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":filterId".parameterType(UUID.self).description("Numeric Filter ID"), use: getNumericFilterHandler)
            .summary("Get Numeric Filter")
        routes.get(use: listNumericFiltersHandler).summary("List Numeric Filters")
        routes.put(":filterId".parameterType(UUID.self).description("Numeric Filter ID"), use: updateNumericFilterHandler)
            .summary("Update Numeric Filter")
        routes.delete(":filterId".parameterType(UUID.self).description("Numeric Filter ID"), use: deleteNumericFilterHandler)
            .summary( "Delete Numeric Filter")
    }
    
    public func bootNumericFilterRoutesForStructuredQuery(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createNumericFilterForQueryHandler).summary("Create Numeric Filter for Structured Query").tags(tag)
        routes.get(use: listNumericFiltersHandler).summary("List Numeric Filters for Structured Query").tags(tag)
    }
    
    public func bootNumericFilterRoutesForFilterGroup(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createNumericFilterForParentHandler).summary("Create Numeric Filter for Filter Group").tags(tag)
        routes.get(use: listNumericFiltersHandler).summary("List Numeric Filters for Filter Group").tags(tag)
    }
}

extension KernelDynamicQuery.Routes.NumericFilter_v1_0 {
    public func createNumericFilterForQueryHandler(_ req: TypedRequest<CreateNumericFilterContext>) async throws -> Response {
        try await featureContainer.services.query.createNumericFilter(
            forStructuredQuery: req.parameters.require("queryId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func createNumericFilterForParentHandler(_ req: TypedRequest<CreateNumericFilterContext>) async throws -> Response {
        try await featureContainer.services.query.createNumericFilter(
            forParentGroup: req.parameters.require("groupId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func getNumericFilterHandler(_ req: TypedRequest<GetNumericFilterContext>) async throws -> Response {
        try await featureContainer.services.query.getNumericFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func listNumericFiltersHandler(_ req: TypedRequest<ListNumericFiltersContext>) async throws -> Response {
        try await featureContainer.services.query.listNumericFilters(
            forStructuredQuery: req.parameters.get("queryId"),
            forParentGroup: req.parameters.get("groupId"),
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func updateNumericFilterHandler(_ req: TypedRequest<UpdateNumericFilterContext>) async throws -> Response {
        try await featureContainer.services.query.updateNumericFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func deleteNumericFilterHandler(_ req: TypedRequest<DeleteNumericFilterContext>) async throws -> Response {
        try await featureContainer.services.query.deleteNumericFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.respondOk()
    }
}

extension KernelDynamicQuery.Routes.NumericFilter_v1_0 {
    public typealias CreateNumericFilterContext = PostRouteContext<
        APIModel.NumericFilter.CreateNumericFilterRequest,
        APIModel.NumericFilter.NumericFilterResponse
    >
    
    public typealias GetNumericFilterContext = GetRouteContext<APIModel.NumericFilter.NumericFilterResponse>
    
    public struct ListNumericFiltersContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<APIModel.NumericFilter.NumericFilterResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
    }
    
    public typealias UpdateNumericFilterContext = UpdateRouteContext<
        APIModel.NumericFilter.UpdateNumericFilterRequest,
        APIModel.NumericFilter.NumericFilterResponse
    >
    
    public typealias DeleteNumericFilterContext = DefaultDeleteRouteContextWithForce
}

