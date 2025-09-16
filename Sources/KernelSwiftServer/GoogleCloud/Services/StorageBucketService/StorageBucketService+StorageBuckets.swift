//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelGoogleCloud.Services.StorageBucketService {
    public func createStorageBucket(
        from requestBody: KernelGoogleCloud.Core.ServerAPIModel.StorageBucket.CreateStorageBucketRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelGoogleCloud.Fluent.Model.CloudStorageBucket {
        try platformActor.systemOrAdmin()
        let googleResponse = try await featureContainer.services.cloudStorage.createBucket(
            from: requestBody
        )
        return try await storeStorageBucket(from: googleResponse, on: db, as: platformActor)
    }
    
    public func getStorageBucket(
        _ field: QueryField<KernelGoogleCloud.Fluent.Model.CloudStorageBucket, some QueryableProperty>,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelGoogleCloud.Fluent.Model.CloudStorageBucket {
        try await .findOrThrow(field, on: selectDB(db)) {
            Abort(.notFound, reason: "Storage Bucket not found")
        }
    }
    
    public func listStorageBuckets(
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        nameFilters: StringFilterQueryParamObject? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelGoogleCloud.Fluent.Model.CloudStorageBucket> {
        let queryBuilder = KernelGoogleCloud.Fluent.Model.CloudStorageBucket.makeQuery(on: try selectDB(db))
        
        let dateFilters = queryBuilder()
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
        
        let stringFilters = queryBuilder()
            .filterIfPresent(\.$name, stringFilters: nameFilters)
        
        let enumFilters = queryBuilder()
        
        let relationFilters = queryBuilder()
        
        let total = try await queryBuilder()
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, stringFilters, enumFilters, relationFilters)
            .count()
        
        let results = try await queryBuilder()
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, stringFilters, enumFilters, relationFilters)
            .paginatedSort(pagination)
            .all()
        
        return .init(results: results, total: total)
    }
    
    public func updateStorageBucket(
        id bucketId: UUID,
        from requestBody: KernelGoogleCloud.Core.ServerAPIModel.StorageBucket.UpdateStorageBucketRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelGoogleCloud.Fluent.Model.CloudStorageBucket {
        try platformActor.systemOrAdmin()
        let bucket = try await getStorageBucket(.id(bucketId), on: db, as: platformActor)
        guard let bucketName = bucket.name else { throw Abort(.badRequest, reason: "Bucket name is missing") }
        let googleResponse = try await featureContainer.services.cloudStorage.patchBucket(
            bucketName: bucketName
        )
        return try await storeStorageBucket(id: bucketId, from: googleResponse, on: db, as: platformActor)
    }
    
    public func deleteStorageBucket(
        id bucketId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let bucket = try await getStorageBucket(.id(bucketId), on: db, as: platformActor)
        guard let bucketName = bucket.name else { throw Abort(.badRequest, reason: "Bucket name is missing") }
        try await featureContainer.services.cloudStorage.deleteBucket(
            bucketName: bucketName
        )
        try await KernelGoogleCloud.Fluent.Model.CloudStorageBucket.delete(
            force: force,
            id: bucketId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func refreshStorageBucket(
        id bucketId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelGoogleCloud.Fluent.Model.CloudStorageBucket {
        try platformActor.systemOrAdmin()
        let bucketToRefresh = try await getStorageBucket(.id(bucketId), on: db, as: platformActor)
        guard let bucketName = bucketToRefresh.name else { throw Abort(.badRequest, reason: "Bucket name is missing") }
        let googleResponse = try await featureContainer.services.cloudStorage.getBucket(bucketName: bucketName)
        return try await storeStorageBucket(id: bucketId, from: googleResponse, on: db, as: platformActor)
    }
    
    public func refreshStorageBuckets(
        limit: Int = 100,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelGoogleCloud.Fluent.Model.CloudStorageBucket> {
        try platformActor.systemOrAdmin()
        var storedBuckets: [KernelGoogleCloud.Fluent.Model.CloudStorageBucket] = []
        var nextPageToken: String? = nil
        let googleResponse = try await featureContainer.services.cloudStorage.listBuckets()
        storedBuckets.append(
            contentsOf: try await storeStorageBuckets(from: googleResponse, on: db, as: platformActor)
                .prefix(limit)
        )
        nextPageToken = googleResponse.nextPageToken
        while nextPageToken != nil, storedBuckets.count < limit {
            let nextGoogleResponse = try await featureContainer.services.cloudStorage.listBuckets(pageToken: nextPageToken)
            storedBuckets.append(
                contentsOf: try await storeStorageBuckets(from: nextGoogleResponse, on: db, as: platformActor)
                    .prefix(limit - storedBuckets.count)
            )
            nextPageToken = nextGoogleResponse.nextPageToken
        }
        return .init(results: storedBuckets)
    }
    
    public func storeStorageBucket(
        id bucketId: UUID? = nil,
        from googleResponse: KernelGoogleCloud.Core.ClientAPIModel.GCStorageBucketResponse,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelGoogleCloud.Fluent.Model.CloudStorageBucket {
        try platformActor.systemOrAdmin()
        if let bucketId {
            return try await .update(
                id: bucketId,
                from: googleResponse,
                onDB: selectDB(db),
                withAudit: true,
                as: platformActor
            )
        } else {
            if let existingBucket = try? await getStorageBucket(
                .field(\.$googleId, googleResponse.id),
                on: db,
                as: platformActor
            ) {
                return try await .update(
                    id: existingBucket.requireID(),
                    from: googleResponse,
                    onDB: selectDB(db),
                    withAudit: true,
                    as: platformActor
                )
            } else {
                return try await .create(
                    from: googleResponse,
                    onDB: selectDB(db),
                    withAudit: true,
                    as: platformActor
                )
            }
        }
    }
    
    @discardableResult
    public func storeStorageBuckets(
        from googleResponse: KernelGoogleCloud.Core.ClientAPIModel.GCStorageBucketListResponse,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> [KernelGoogleCloud.Fluent.Model.CloudStorageBucket] {
        try platformActor.systemOrAdmin()
        return try await googleResponse.items?.asyncMap { storageBucket in
            try await storeStorageBucket(from: storageBucket, on: db, as: platformActor)
        } ?? []
    }
}
