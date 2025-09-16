//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Services.QueryService {
    public func createStructuredQuery(
        from requestBody: KernelDynamicQuery.Core.APIModel.StructuredQuery.CreateStructuredQueryRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.StructuredQuery {
        try platformActor.systemOrAdmin()
        let query = try await KernelDynamicQuery.Fluent.Model.StructuredQuery.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
        return query
    }
    
    public func getStructuredQuery(
        id structuredQueryId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.StructuredQuery {
        try await KernelDynamicQuery.Fluent.Model.StructuredQuery.findOrThrow(
            structuredQueryId,
            on: selectDB(db)
        ) { FeatureContainer.TypedError(.structuredQueryNotFound) }
    }
    
    public func listStructuredQueries(
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelDynamicQuery.Fluent.Model.StructuredQuery> {
        let queryBuilder = KernelDynamicQuery.Fluent.Model.StructuredQuery.makeQuery(on: try selectDB(db))
        
        let dateFilters = queryBuilder()
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
        
        let enumFilters = queryBuilder()
        
        let relationFilters = queryBuilder()
        
        let total = try await queryBuilder()
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, enumFilters, relationFilters)
            .count()
        
        let results = try await queryBuilder()
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, enumFilters, relationFilters)
            .paginatedSort(pagination)
            .all()
        
        return .init(results: results, total: total)
    }
    
    public func updateStructuredQuery(
        id structuredQueryId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.StructuredQuery.UpdateStructuredQueryRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.StructuredQuery {
        try platformActor.systemOrAdmin()
        return try await .update(
            id: structuredQueryId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteStructuredQuery(
        id structuredQueryId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let structuredQuery = try await getStructuredQuery(id: structuredQueryId, on: db, as: platformActor)
        try await KernelDynamicQuery.Fluent.Model.StructuredQuery.delete(
            force: force,
            id: structuredQuery.requireID(),
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}
