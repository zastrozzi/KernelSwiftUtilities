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
    public func createBooleanFilter(
        forStructuredQuery structuredQueryId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.BooleanFilter.CreateBooleanFilterRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.BooleanFilter {
        try platformActor.systemOrAdmin()
        return try await KernelDynamicQuery.Fluent.Model.BooleanFilter.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(queryId: structuredQueryId)
        )
    }
    
    public func createBooleanFilter(
        forParentGroup parentGroupId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.BooleanFilter.CreateBooleanFilterRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.BooleanFilter {
        try platformActor.systemOrAdmin()
        return try await KernelDynamicQuery.Fluent.Model.BooleanFilter.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(parentId: parentGroupId)
        )
    }
    
    public func getBooleanFilter(
        id booleanFilterId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.BooleanFilter {
        try await KernelDynamicQuery.Fluent.Model.BooleanFilter.findOrThrow(
            booleanFilterId,
            on: selectDB(db)
        ) { FeatureContainer.TypedError(.booleanFilterNotFound) }
    }
    
    public func listBooleanFilters(
        forStructuredQuery structuredQueryId: UUID? = nil,
        forParentGroup parentGroupId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelDynamicQuery.Fluent.Model.BooleanFilter> {
        let queryBuilder = KernelDynamicQuery.Fluent.Model.BooleanFilter.makeQuery(on: try selectDB(db))
        
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
    
    public func updateBooleanFilter(
        id booleanFilterId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.BooleanFilter.UpdateBooleanFilterRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.BooleanFilter {
        try platformActor.systemOrAdmin()
        return try await .update(
            id: booleanFilterId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteBooleanFilter(
        id booleanFilterId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let booleanFilter = try await getBooleanFilter(id: booleanFilterId, on: db, as: platformActor)
        try await KernelDynamicQuery.Fluent.Model.BooleanFilter.delete(
            force: force,
            id: booleanFilter.requireID(),
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}
