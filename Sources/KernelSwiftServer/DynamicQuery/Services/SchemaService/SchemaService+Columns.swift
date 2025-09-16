//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Services.SchemaService {
    public func addColumn(
        _ column: FeatureContainer.APIModel.QueryableSchema.ColumnResponse
    ) throws {
        guard !columnCache.has(column.id) else {
            FeatureContainer.logger.error("Failed to add column \(column.columnIdentifiers): \(column.id)")
            throw Abort(.conflict, reason: "Column already registered")
        }
        
        columnCache.set(column.id, value: column)
    }
    
    public func getColumn(
        id columnId: UUID
    ) throws -> FeatureContainer.APIModel.QueryableSchema.ColumnResponse {
        guard let column = columnCache.get(columnId) else {
            FeatureContainer.logger.error("Failed to get column \(columnId)")
            throw Abort(.notFound, reason: "Column not found")
        }
        return column
    }
    
    public func listColumns(
        forTable tableId: UUID? = nil,
        limit: Int? = nil,
        offset: Int? = nil
    ) throws -> KPPaginatedResponse<FeatureContainer.APIModel.QueryableSchema.ColumnResponse> {
        let columns = try columnCache.paginatedFilter(
            limit: limit,
            offset: offset,
            orderBy: \.id.uuidString
        ) { column in
            if let tableId { return column.tableId == tableId }
            return true
        }
        return .init(results: columns.0, total: columns.1)
    }
}
