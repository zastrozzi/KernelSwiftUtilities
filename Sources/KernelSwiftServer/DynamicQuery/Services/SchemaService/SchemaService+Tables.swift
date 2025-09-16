//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Services.SchemaService {
    public func addTable(
        _ table: APIModel.QueryableSchema.TableResponse
    ) throws {
        guard !tableCache.has(table.id) else {
            FeatureContainer.logger.error("Failed to add table \(table.displayName): \(table.id)")
            throw Abort(.conflict, reason: "Table already registered")
        }
        
        tableCache.set(table.id, value: table)
    }
    
    public func getTable(
        id tableId: UUID
    ) throws -> APIModel.QueryableSchema.TableResponse {
        guard let table = tableCache.get(tableId) else {
            FeatureContainer.logger.error("Failed to get table \(tableId)")
            throw Abort(.notFound, reason: "Table not found")
        }
        return table
    }
    
    public func listTables(
        limit: Int? = nil,
        offset: Int? = nil,
        order: KPPaginationOrder? = nil,
        orderBy: String = "displayName",
        displayNameFilters: StringFilterQueryParamObject? = nil,
        schemaNameFilters: StringFilterQueryParamObject? = nil,
        tableNameFilters: StringFilterQueryParamObject? = nil
    ) throws -> KPPaginatedResponse<APIModel.QueryableSchema.TableResponse> {
        let tables = try tableCache
            .paginatedFilter(
                limit: limit,
                offset: offset,
                order: (order ?? .ascending).asSortOrder,
                orderBy: orderBy
            ) { table in
                var condition = true
                if condition, let displayNameEqual = displayNameFilters?.equalTo {
                    condition = table.displayName == displayNameEqual
                }
                if condition, let displayNameContains = displayNameFilters?.contains {
                    condition = table.displayName.lowercased().contains(displayNameContains.lowercased())
                }
                if condition, let schemaNameEqual = schemaNameFilters?.equalTo {
                    condition = table.tableIdentifiers.schema == schemaNameEqual
                }
                if condition, let tableNameEqual = tableNameFilters?.equalTo {
                    condition = table.tableIdentifiers.table == tableNameEqual
                }
                if condition, let schemaNameContains = schemaNameFilters?.contains {
                    condition = table.tableIdentifiers.schema.lowercased().contains(schemaNameContains.lowercased())
                }
                if condition, let tableNameContains = tableNameFilters?.contains {
                    condition = table.tableIdentifiers.table.lowercased().contains(tableNameContains.lowercased())
                }
                return condition
            }
        return .init(results: tables.0, total: tables.1)
    }
}
