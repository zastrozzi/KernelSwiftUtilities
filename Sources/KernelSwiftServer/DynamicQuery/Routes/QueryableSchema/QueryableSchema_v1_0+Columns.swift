//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Routes.QueryableSchema_v1_0 {
    public func bootColumnRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(use: listColumnsHandler).summary("List Columns")
        routes.get(":columnId".parameterType(UUID.self).description("Column ID"), use: getColumnHandler).summary("Get Column")
    }
    
    public func bootColumnRoutesForTable(routes: TypedRoutesBuilder) throws {
        routes.get(use: listColumnsHandler).summary("List Columns for Table")
    }
}

extension KernelDynamicQuery.Routes.QueryableSchema_v1_0 {
    public func getColumnHandler(_ req: TypedRequest<GetColumnContext>) async throws -> Response {
        let column = try featureContainer.services.schema.getColumn(
            id: req.parameters.require("columnId")
        )
        return try await req.response.success.encode(column)
    }
    
    public func listColumnsHandler(_ req: TypedRequest<ListColumnsContext>) async throws -> Response {
        let columns = try featureContainer.services.schema.listColumns(
            forTable: req.parameters.get("tableId"),
            limit: req.query.limit,
            offset: req.query.offset
        )
        return try await req.response.success.encode(columns)
    }
    
}

extension KernelDynamicQuery.Routes.QueryableSchema_v1_0 {
    public typealias GetColumnContext = GetRouteContext<APIModel.QueryableSchema.ColumnResponse>
    
    public struct ListColumnsContext: RouteContext {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<APIModel.QueryableSchema.ColumnResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit")
        public let offset: QueryParam<Int> = .init(name: "offset")
    }
}
