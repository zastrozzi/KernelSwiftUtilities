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
    public func createNumericFilter(
        forStructuredQuery structuredQueryId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.NumericFilter.CreateNumericFilterRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.NumericFilter {
        try platformActor.systemOrAdmin()
        return try await KernelDynamicQuery.Fluent.Model.NumericFilter.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(queryId: structuredQueryId)
        )
    }
    
    public func createNumericFilter(
        forParentGroup parentGroupId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.NumericFilter.CreateNumericFilterRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.NumericFilter {
        try platformActor.systemOrAdmin()
        return try await KernelDynamicQuery.Fluent.Model.NumericFilter.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(parentId: parentGroupId)
        )
    }
    
    public func getNumericFilter(
        id numericFilterId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.NumericFilter {
        try await KernelDynamicQuery.Fluent.Model.NumericFilter.findOrThrow(
            numericFilterId,
            on: selectDB(db)
        ) { FeatureContainer.TypedError(.numericFilterNotFound) }
    }
    
    public func listNumericFilters(
        forStructuredQuery structuredQueryId: UUID? = nil,
        forParentGroup parentGroupId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelDynamicQuery.Fluent.Model.NumericFilter> {
        let queryBuilder = KernelDynamicQuery.Fluent.Model.NumericFilter.makeQuery(on: try selectDB(db))
        
        let dateFilters = queryBuilder()
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
        
        let enumFilters = queryBuilder()
        
        let relationFilters = queryBuilder()
            .filterIfPresent(\.$structuredQuery.$id, .equal, structuredQueryId)
            .filterIfPresent(\.$parentGroup.$id, .equal, parentGroupId)
        
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
    
    public func updateNumericFilter(
        id numericFilterId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.NumericFilter.UpdateNumericFilterRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.NumericFilter {
        try platformActor.systemOrAdmin()
        return try await .update(
            id: numericFilterId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteNumericFilter(
        id numericFilterId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let numericFilter = try await getNumericFilter(id: numericFilterId, on: db, as: platformActor)
        try await KernelDynamicQuery.Fluent.Model.NumericFilter.delete(
            force: force,
            id: numericFilter.requireID(),
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}
