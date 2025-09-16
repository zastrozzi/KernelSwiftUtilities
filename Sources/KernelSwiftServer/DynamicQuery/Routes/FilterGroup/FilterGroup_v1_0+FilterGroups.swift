//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Routes.FilterGroup_v1_0 {
    public func bootFilterGroupRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":groupId".parameterType(UUID.self).description("Filter Group ID"), use: getFilterGroupHandler)
            .summary("Get Filter Group")
        routes.get(use: listFilterGroupsHandler).summary("List Filter Groups")
        routes.put(":groupId".parameterType(UUID.self).description("Filter Group ID"), use: updateFilterGroupHandler)
            .summary("Update Filter Group")
        routes.delete(":groupId".parameterType(UUID.self).description("Filter Group ID"), use: deleteFilterGroupHandler)
            .summary( "Delete Filter Group")
        
        let filterGroupSubroutes = routes.typeGrouped(":groupId".parameterType(UUID.self).description("Filter Group ID"))
        try filterGroupSubroutes.register(collection: Feature.FilterGroup_v1_0(forContext: .parentFilterGroup))
        try filterGroupSubroutes.register(collection: Feature.BooleanFilter_v1_0(forContext: .filterGroup))
        try filterGroupSubroutes.register(collection: Feature.DateFilter_v1_0(forContext: .filterGroup))
        try filterGroupSubroutes.register(collection: Feature.EnumFilter_v1_0(forContext: .filterGroup))
        try filterGroupSubroutes.register(collection: Feature.NumericFilter_v1_0(forContext: .filterGroup))
        try filterGroupSubroutes.register(collection: Feature.StringFilter_v1_0(forContext: .filterGroup))
        try filterGroupSubroutes.register(collection: Feature.UUIDFilter_v1_0(forContext: .filterGroup))
    }
    
    public func bootFilterGroupRoutesForStructuredQuery(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createFilterGroupForQueryHandler).summary("Create Filter Group for Structured Query").tags(tag)
        routes.get(use: listFilterGroupsHandler).summary("List Filter Groups for Structured Query").tags(tag)
    }
    
    public func bootFilterGroupRoutesForParentGroup(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(use: createFilterGroupForParentHandler).summary("Create Filter Group for Parent Group").tags(tag)
        routes.get(use: listFilterGroupsHandler).summary("List Filter Groups for Parent Group").tags(tag)
    }
}

extension KernelDynamicQuery.Routes.FilterGroup_v1_0 {
    public func createFilterGroupForQueryHandler(_ req: TypedRequest<CreateFilterGroupContext>) async throws -> Response {
        try await featureContainer.services.query.createFilterGroup(
            forStructuredQuery: req.parameters.require("queryId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func createFilterGroupForParentHandler(_ req: TypedRequest<CreateFilterGroupContext>) async throws -> Response {
        try await featureContainer.services.query.createFilterGroup(
            forParentGroup: req.parameters.require("groupId"),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func getFilterGroupHandler(_ req: TypedRequest<GetFilterGroupContext>) async throws -> Response {
        try await featureContainer.services.query.getFilterGroup(
            id: req.parameters.require("groupId", as: UUID.self),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func listFilterGroupsHandler(_ req: TypedRequest<ListFilterGroupsContext>) async throws -> Response {
        try await featureContainer.services.query.listFilterGroups(
            forStructuredQuery: req.parameters.get("queryId"),
            forParentGroup: req.parameters.get("groupId"),
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func updateFilterGroupHandler(_ req: TypedRequest<UpdateFilterGroupContext>) async throws -> Response {
        try await featureContainer.services.query.updateFilterGroup(
            id: req.parameters.require("groupId", as: UUID.self),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func deleteFilterGroupHandler(_ req: TypedRequest<DeleteFilterGroupContext>) async throws -> Response {
        try await featureContainer.services.query.deleteFilterGroup(
            id: req.parameters.require("groupId", as: UUID.self),
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.respondOk()
    }
}

extension KernelDynamicQuery.Routes.FilterGroup_v1_0 {
    public typealias CreateFilterGroupContext = PostRouteContext<
        APIModel.FilterGroup.CreateFilterGroupRequest,
        APIModel.FilterGroup.FilterGroupResponse
    >
    
    public typealias GetFilterGroupContext = GetRouteContext<APIModel.FilterGroup.FilterGroupResponse>
    
    public struct ListFilterGroupsContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<APIModel.FilterGroup.FilterGroupResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
    }
    
    public typealias UpdateFilterGroupContext = UpdateRouteContext<
        APIModel.FilterGroup.UpdateFilterGroupRequest,
        APIModel.FilterGroup.FilterGroupResponse
    >
    
    public typealias DeleteFilterGroupContext = DefaultDeleteRouteContextWithForce
}

