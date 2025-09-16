//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Routes.StringFilter_v1_0 {
    public func bootStringFilterRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":filterId".parameterType(UUID.self).description("String Filter ID"), use: getStringFilterHandler)
            .summary("Get String Filter")
        routes.get(use: listStringFiltersHandler).summary("List String Filters")
        routes.put(":filterId".parameterType(UUID.self).description("String Filter ID"), use: updateStringFilterHandler)
            .summary("Update String Filter")
        routes.delete(":filterId".parameterType(UUID.self).description("String Filter ID"), use: deleteStringFilterHandler)
            .summary( "Delete String Filter")
    }
    
    public func bootStringFilterRoutesForStructuredQuery(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createStringFilterForQueryHandler).summary("Create String Filter for Structured Query").tags(tag)
        routes.get(use: listStringFiltersHandler).summary("List String Filters for Structured Query").tags(tag)
    }
    
    public func bootStringFilterRoutesForFilterGroup(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createStringFilterForParentHandler).summary("Create String Filter for Filter Group").tags(tag)
        routes.get(use: listStringFiltersHandler).summary("List String Filters for Filter Group").tags(tag)
    }
}

extension KernelDynamicQuery.Routes.StringFilter_v1_0 {
    public func createStringFilterForQueryHandler(_ req: TypedRequest<CreateStringFilterContext>) async throws -> Response {
        try await featureContainer.services.query.createStringFilter(
            forStructuredQuery: req.parameters.require("queryId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func createStringFilterForParentHandler(_ req: TypedRequest<CreateStringFilterContext>) async throws -> Response {
        try await featureContainer.services.query.createStringFilter(
            forParentGroup: req.parameters.require("groupId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func getStringFilterHandler(_ req: TypedRequest<GetStringFilterContext>) async throws -> Response {
        try await featureContainer.services.query.getStringFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func listStringFiltersHandler(_ req: TypedRequest<ListStringFiltersContext>) async throws -> Response {
        try await featureContainer.services.query.listStringFilters(
            forStructuredQuery: req.parameters.get("queryId"),
            forParentGroup: req.parameters.get("groupId"),
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func updateStringFilterHandler(_ req: TypedRequest<UpdateStringFilterContext>) async throws -> Response {
        try await featureContainer.services.query.updateStringFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func deleteStringFilterHandler(_ req: TypedRequest<DeleteStringFilterContext>) async throws -> Response {
        try await featureContainer.services.query.deleteStringFilter(
            id: req.parameters.require("filterId", as: UUID.self),
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.respondOk()
    }
}

extension KernelDynamicQuery.Routes.StringFilter_v1_0 {
    public typealias CreateStringFilterContext = PostRouteContext<
        APIModel.StringFilter.CreateStringFilterRequest,
        APIModel.StringFilter.StringFilterResponse
    >
    
    public typealias GetStringFilterContext = GetRouteContext<APIModel.StringFilter.StringFilterResponse>
    
    public struct ListStringFiltersContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<APIModel.StringFilter.StringFilterResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
    }
    
    public typealias UpdateStringFilterContext = UpdateRouteContext<
        APIModel.StringFilter.UpdateStringFilterRequest,
        APIModel.StringFilter.StringFilterResponse
    >
    
    public typealias DeleteStringFilterContext = DefaultDeleteRouteContextWithForce
}

