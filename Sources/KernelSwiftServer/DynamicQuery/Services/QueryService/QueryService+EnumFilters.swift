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
    public func createEnumFilter(
        forStructuredQuery structuredQueryId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.EnumFilter.CreateEnumFilterRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.EnumFilter {
        try platformActor.systemOrAdmin()
        return try await KernelDynamicQuery.Fluent.Model.EnumFilter.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(queryId: structuredQueryId)
        )
    }
    
    public func createEnumFilter(
        forParentGroup parentGroupId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.EnumFilter.CreateEnumFilterRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.EnumFilter {
        try platformActor.systemOrAdmin()
        return try await KernelDynamicQuery.Fluent.Model.EnumFilter.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(parentId: parentGroupId)
        )
    }
    
    public func getEnumFilter(
        id enumFilterId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.EnumFilter {
        try await KernelDynamicQuery.Fluent.Model.EnumFilter.findOrThrow(
            enumFilterId,
            on: selectDB(db)
        ) { FeatureContainer.TypedError(.enumFilterNotFound) }
    }
    
    public func listEnumFilters(
        forStructuredQuery structuredQueryId: UUID? = nil,
        forParentGroup parentGroupId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelDynamicQuery.Fluent.Model.EnumFilter> {
        let queryBuilder = KernelDynamicQuery.Fluent.Model.EnumFilter.makeQuery(on: try selectDB(db))
        
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
    
    public func updateEnumFilter(
        id enumFilterId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.EnumFilter.UpdateEnumFilterRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.EnumFilter {
        try platformActor.systemOrAdmin()
        return try await .update(
            id: enumFilterId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteEnumFilter(
        id enumFilterId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let enumFilter = try await getEnumFilter(id: enumFilterId, on: db, as: platformActor)
        try await KernelDynamicQuery.Fluent.Model.EnumFilter.delete(
            force: force,
            id: enumFilter.requireID(),
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}
