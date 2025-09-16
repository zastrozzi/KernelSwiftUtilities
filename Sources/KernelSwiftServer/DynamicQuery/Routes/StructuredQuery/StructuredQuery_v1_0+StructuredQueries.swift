//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Routes.StructuredQuery_v1_0 {
    public func bootStructuredQueryRoutes(routes: TypedRoutesBuilder) throws {
        routes.post(use: createStructuredQueryHandler).summary("Create Structured Query")
        routes.get(":queryId".parameterType(UUID.self).description("Structured Query ID"), use: getStructuredQueryHandler)
            .summary("Get Structured Query")
        routes.get(use: listStructuredQueriesHandler).summary("List Structured Queries")
        routes.put(":queryId".parameterType(UUID.self).description("Structured Query ID"), use: updateStructuredQueryHandler)
            .summary("Update Structured Query")
        routes.delete(":queryId".parameterType(UUID.self).description("Structured Query ID"), use: deleteStructuredQueryHandler)
            .summary( "Delete Structured Query")
        
        let querySubroutes = routes.typeGrouped(":queryId".parameterType(UUID.self).description("Structured Query ID"))
        try querySubroutes.register(collection: Feature.FilterGroup_v1_0(forContext: .structuredQuery))
        try querySubroutes.register(collection: Feature.BooleanFilter_v1_0(forContext: .structuredQuery))
        try querySubroutes.register(collection: Feature.DateFilter_v1_0(forContext: .structuredQuery))
        try querySubroutes.register(collection: Feature.EnumFilter_v1_0(forContext: .structuredQuery))
        try querySubroutes.register(collection: Feature.NumericFilter_v1_0(forContext: .structuredQuery))
        try querySubroutes.register(collection: Feature.StringFilter_v1_0(forContext: .structuredQuery))
        try querySubroutes.register(collection: Feature.UUIDFilter_v1_0(forContext: .structuredQuery))
    }
}

extension KernelDynamicQuery.Routes.StructuredQuery_v1_0 {
    public func createStructuredQueryHandler(_ req: TypedRequest<CreateStructuredQueryContext>) async throws -> Response {
        try await featureContainer.services.query.createStructuredQuery(
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func getStructuredQueryHandler(_ req: TypedRequest<GetStructuredQueryContext>) async throws -> Response {
        try await featureContainer.services.query.getStructuredQuery(
            id: req.parameters.require("queryId", as: UUID.self),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func listStructuredQueriesHandler(_ req: TypedRequest<ListStructuredQueriesContext>) async throws -> Response {
        try await featureContainer.services.query.listStructuredQueries(
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func updateStructuredQueryHandler(_ req: TypedRequest<UpdateStructuredQueryContext>) async throws -> Response {
        try await featureContainer.services.query.updateStructuredQuery(
            id: req.parameters.require("queryId", as: UUID.self),
            from: req.decodeBody(),
            as: req.platformActor
        ).encodeResponse(for: req, \.success)
    }
    
    public func deleteStructuredQueryHandler(_ req: TypedRequest<DeleteStructuredQueryContext>) async throws -> Response {
        try await featureContainer.services.query.deleteStructuredQuery(
            id: req.parameters.require("queryId", as: UUID.self),
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.respondOk()
    }
}

extension KernelDynamicQuery.Routes.StructuredQuery_v1_0 {
    public typealias CreateStructuredQueryContext = PostRouteContext<
        APIModel.StructuredQuery.CreateStructuredQueryRequest,
        APIModel.StructuredQuery.StructuredQueryResponse
    >
    
    public typealias GetStructuredQueryContext = GetRouteContext<APIModel.StructuredQuery.StructuredQueryResponse>
    
    public struct ListStructuredQueriesContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<APIModel.StructuredQuery.StructuredQueryResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
    }
    
    public typealias UpdateStructuredQueryContext = UpdateRouteContext<
        APIModel.StructuredQuery.UpdateStructuredQueryRequest,
        APIModel.StructuredQuery.StructuredQueryResponse
    >
    
    public typealias DeleteStructuredQueryContext = DefaultDeleteRouteContextWithForce
}

