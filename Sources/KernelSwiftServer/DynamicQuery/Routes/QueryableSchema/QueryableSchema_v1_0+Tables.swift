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
    public func bootTableRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(use: listTablesHandler).summary("List Tables")
        routes.get(":tableId".parameterType(UUID.self).description("Table ID"), use: getTableHandler).summary("Get Table")
        let tableSubroutes = routes.typeGrouped(":tableId".parameterType(UUID.self).description("Table ID"))
        try bootColumnRoutesForTable(routes: tableSubroutes.typeGrouped("columns"))
        try bootRelationshipRoutesForTable(routes: tableSubroutes.typeGrouped("relationships"))
    }
}

extension KernelDynamicQuery.Routes.QueryableSchema_v1_0 {
    public func getTableHandler(_ req: TypedRequest<GetTableContext>) async throws -> Response {
        let table = try featureContainer.services.schema.getTable(
            id: req.parameters.require("tableId")
        )
        return try await req.response.success.encode(table)
    }
    
    public func listTablesHandler(_ req: TypedRequest<ListTablesContext>) async throws -> Response {
        let tables = try featureContainer.services.schema.listTables(
            limit: req.query.limit,
            offset: req.query.offset,
            order: req.query.withDefault(\.order).value,
            orderBy: req.query.withDefault(\.orderBy),
            displayNameFilters: req.query.displayName,
            schemaNameFilters: req.query.schemaName,
            tableNameFilters: req.query.tableName
        )
        return try await req.response.success.encode(tables)
    }
    
}

extension KernelDynamicQuery.Routes.QueryableSchema_v1_0 {
    public typealias GetTableContext = GetRouteContext<APIModel.QueryableSchema.TableResponse>
    
    public struct ListTablesContext: RouteContext {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<APIModel.QueryableSchema.TableResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit")
        public let offset: QueryParam<Int> = .init(name: "offset")
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .ascending)
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "displayName")
        public let displayName: StringFilterQueryParam = .init(name: "display_name")
        public let schemaName: StringFilterQueryParam = .init(name: "schema_name")
        public let tableName: StringFilterQueryParam = .init(name: "table_name")
    }
}

