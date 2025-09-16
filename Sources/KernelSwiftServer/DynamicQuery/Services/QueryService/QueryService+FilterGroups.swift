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
    public func createFilterGroup(
        forStructuredQuery structuredQueryId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.FilterGroup.CreateFilterGroupRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.FilterGroup {
        try platformActor.systemOrAdmin()
        return try await KernelDynamicQuery.Fluent.Model.FilterGroup.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(queryId: structuredQueryId)
        )
    }
    
    public func createFilterGroup(
        forParentGroup parentGroupId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.FilterGroup.CreateFilterGroupRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.FilterGroup {
        try platformActor.systemOrAdmin()
        return try await KernelDynamicQuery.Fluent.Model.FilterGroup.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(parentId: parentGroupId)
        )
    }
    
    public func getFilterGroup(
        id filterGroupId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.FilterGroup {
        try await KernelDynamicQuery.Fluent.Model.FilterGroup.findOrThrow(
            filterGroupId,
            on: selectDB(db)
        ) { FeatureContainer.TypedError(.filterGroupNotFound) }
    }
    
    public func listFilterGroups(
        forStructuredQuery structuredQueryId: UUID? = nil,
        forParentGroup parentGroupId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelDynamicQuery.Fluent.Model.FilterGroup> {
        let queryBuilder = KernelDynamicQuery.Fluent.Model.FilterGroup.makeQuery(on: try selectDB(db))
        
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
    
    public func updateFilterGroup(
        id filterGroupId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.FilterGroup.UpdateFilterGroupRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.FilterGroup {
        try platformActor.systemOrAdmin()
        return try await .update(
            id: filterGroupId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteFilterGroup(
        id filterGroupId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let filterGroup = try await getFilterGroup(id: filterGroupId, on: db, as: platformActor)
        try await KernelDynamicQuery.Fluent.Model.FilterGroup.delete(
            force: force,
            id: filterGroup.requireID(),
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}
