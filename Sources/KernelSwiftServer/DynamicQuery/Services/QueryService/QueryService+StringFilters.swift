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
    public func createStringFilter(
        forStructuredQuery structuredQueryId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.StringFilter.CreateStringFilterRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.StringFilter {
        try platformActor.systemOrAdmin()
        return try await KernelDynamicQuery.Fluent.Model.StringFilter.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(queryId: structuredQueryId)
        )
    }
    
    public func createStringFilter(
        forParentGroup parentGroupId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.StringFilter.CreateStringFilterRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.StringFilter {
        try platformActor.systemOrAdmin()
        return try await KernelDynamicQuery.Fluent.Model.StringFilter.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(parentId: parentGroupId)
        )
    }
    
    public func getStringFilter(
        id stringFilterId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.StringFilter {
        try await KernelDynamicQuery.Fluent.Model.StringFilter.findOrThrow(
            stringFilterId,
            on: selectDB(db)
        ) { FeatureContainer.TypedError(.stringFilterNotFound) }
    }
    
    public func listStringFilters(
        forStructuredQuery structuredQueryId: UUID? = nil,
        forParentGroup parentGroupId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelDynamicQuery.Fluent.Model.StringFilter> {
        let queryBuilder = KernelDynamicQuery.Fluent.Model.StringFilter.makeQuery(on: try selectDB(db))
        
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
    
    public func updateStringFilter(
        id stringFilterId: UUID,
        from requestBody: KernelDynamicQuery.Core.APIModel.StringFilter.UpdateStringFilterRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelDynamicQuery.Fluent.Model.StringFilter {
        try platformActor.systemOrAdmin()
        return try await .update(
            id: stringFilterId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteStringFilter(
        id stringFilterId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let stringFilter = try await getStringFilter(id: stringFilterId, on: db, as: platformActor)
        try await KernelDynamicQuery.Fluent.Model.StringFilter.delete(
            force: force,
            id: stringFilter.requireID(),
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}
