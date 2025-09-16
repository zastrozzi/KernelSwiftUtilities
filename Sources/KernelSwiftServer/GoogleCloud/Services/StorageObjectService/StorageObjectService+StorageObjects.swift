//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/04/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelGoogleCloud.Services.StorageObjectService {
    public func uploadStorageObject(
        forBucket bucketId: UUID,
        from requestBody: KernelGoogleCloud.Core.ServerAPIModel.StorageObject.UploadStorageObjectRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelGoogleCloud.Fluent.Model.CloudStorageObject {
        try platformActor.systemOrAdmin()
        let bucket = try await featureContainer.services.storageBucket.getStorageBucket(.id(bucketId), on: db, as: platformActor)
        guard let bucketName = bucket.name else { throw Abort(.badRequest, reason: "Bucket name is missing") }
        guard let contentType = requestBody.file.contentType else {
            throw Abort(.badRequest, reason: "Unsupported file extension")
        }
        let queryParameters: [String: String]?
        if let predefinedAcl = requestBody.predefinedAcl {
            queryParameters = ["predefinedAcl": String(predefinedAcl)]
        } else {
            queryParameters = nil
        }
        let googleResponse = try await featureContainer.services.cloudStorage.uploadObject(
            bucketName: bucketName,
            data: .init(buffer: requestBody.file.data),
            name: requestBody.name,
            contentType: contentType.serialize(),
            queryParameters: queryParameters
        )
        return try await storeStorageObject(
            forBucket: bucketId,
            from: googleResponse,
            on: db,
            as: platformActor
        )
    }
    
    public func getStorageObject(
        _ field: QueryField<KernelGoogleCloud.Fluent.Model.CloudStorageObject, some QueryableProperty>,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelGoogleCloud.Fluent.Model.CloudStorageObject {
        try await .findOrThrow(field, on: selectDB(db)) {
            Abort(.notFound, reason: "Storage Object not found")
        }
    }
    
    public func listStorageObjects(
        forBucket bucketId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        nameFilters: StringFilterQueryParamObject? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelGoogleCloud.Fluent.Model.CloudStorageObject> {
        let queryBuilder = KernelGoogleCloud.Fluent.Model.CloudStorageObject.makeQuery(on: try selectDB(db))
        
        let dateFilters = queryBuilder()
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
        
        let stringFilters = queryBuilder()
            .filterIfPresent(\.$name, stringFilters: nameFilters)
        
        let enumFilters = queryBuilder()
        
        let relationFilters = queryBuilder()
            .filterIfPresent(\.$storageBucket.$id, .equal, bucketId)
        
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
    
    public func updateStorageObject(
        id objectId: UUID,
        from requestBody: KernelGoogleCloud.Core.ServerAPIModel.StorageObject.UpdateStorageObjectRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelGoogleCloud.Fluent.Model.CloudStorageObject {
        try platformActor.systemOrAdmin()
        let object = try await getStorageObject(.id(objectId), on: db, as: platformActor)
        guard let objectName = object.name else { throw Abort(.badRequest, reason: "Object name is missing") }
        guard let bucketName = object.bucket else { throw Abort(.badRequest, reason: "Bucket name is missing") }
        let queryParameters: [String: String]?
        if let predefinedAcl = requestBody.predefinedAcl {
            queryParameters = ["predefinedAcl": String(predefinedAcl)]
        } else {
            queryParameters = nil
        }
        let googleResponse = try await featureContainer.services.cloudStorage.updateObject(
            bucketName: bucketName,
            objectName: objectName,
            queryParameters: queryParameters
        )
        return try await storeStorageObject(
            id: objectId,
            forBucket: object.$storageBucket.id,
            from: googleResponse,
            on: db,
            as: platformActor
        )
    }
    
    public func deleteStorageObject(
        id objectId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let object = try await getStorageObject(.id(objectId), on: db, as: platformActor)
        guard let objectName = object.name else { throw Abort(.badRequest, reason: "Object name is missing") }
        guard let bucketName = object.bucket else { throw Abort(.badRequest, reason: "Bucket name is missing") }
        try await featureContainer.services.cloudStorage.deleteObject(
            bucketName: bucketName,
            objectName: objectName
        )
        try await KernelGoogleCloud.Fluent.Model.CloudStorageObject.delete(
            force: force,
            id: objectId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteManyStorageObjects(
        from requestBody: KernelGoogleCloud.Core.ServerAPIModel.StorageObject.DeleteManyStorageObjectsRequest,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        for objectId in requestBody.objectIds {
            let object = try await getStorageObject(.id(objectId), on: db, as: platformActor)
            guard let objectName = object.name else { throw Abort(.badRequest, reason: "Object name is missing") }
            guard let bucketName = object.bucket else { throw Abort(.badRequest, reason: "Bucket name is missing") }
            try await featureContainer.services.cloudStorage.deleteObject(
                bucketName: bucketName,
                objectName: objectName
            )
            try await KernelGoogleCloud.Fluent.Model.CloudStorageObject.delete(
                force: force,
                id: objectId,
                onDB: selectDB(db),
                withAudit: true,
                as: platformActor
            )
        }
    }
    
    public func refreshStorageObject(
        id objectId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelGoogleCloud.Fluent.Model.CloudStorageObject {
        try platformActor.systemOrAdmin()
        let objectToRefresh = try await getStorageObject(.id(objectId), on: db, as: platformActor)
        guard let objectName = objectToRefresh.name else { throw Abort(.badRequest, reason: "Object name is missing") }
        guard let bucketName = objectToRefresh.bucket else { throw Abort(.badRequest, reason: "Bucket name is missing") }
        let googleResponse = try await featureContainer.services.cloudStorage.getObject(
            bucketName: bucketName,
            objectName: objectName
        )
        return try await storeStorageObject(
            id: objectId,
            forBucket: objectToRefresh.$storageBucket.id,
            from: googleResponse,
            on: db,
            as: platformActor
        )
    }
    
    public func refreshStorageObjects(
        forBucket bucketId: UUID,
        limit: Int = 100,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelGoogleCloud.Fluent.Model.CloudStorageObject> {
        try platformActor.systemOrAdmin()
        let bucket = try await featureContainer.services.storageBucket.getStorageBucket(
            .id(bucketId),
            on: db,
            as: platformActor
        )
        guard let bucketName = bucket.name else { throw Abort(.badRequest, reason: "Bucket name is missing") }
        var storedObjects: [KernelGoogleCloud.Fluent.Model.CloudStorageObject] = []
        var nextPageToken: String? = nil
        let googleResponse = try await featureContainer.services.cloudStorage.listObjects(
            bucketName: bucketName
        )
        storedObjects.append(
            contentsOf: try await storeStorageObjects(
                forBucket: bucketId,
                from: googleResponse,
                on: db,
                as: platformActor
            )
                .prefix(limit)
        )
        nextPageToken = googleResponse.nextPageToken
        while nextPageToken != nil, storedObjects.count < limit {
            let nextGoogleResponse = try await featureContainer.services.cloudStorage.listObjects(
                bucketName: bucketName,
                pageToken: nextPageToken
            )
            storedObjects.append(
                contentsOf: try await storeStorageObjects(
                    forBucket: bucketId,
                    from: nextGoogleResponse,
                    on: db,
                    as: platformActor
                )
                    .prefix(limit - storedObjects.count)
            )
            nextPageToken = nextGoogleResponse.nextPageToken
        }
        return .init(results: storedObjects)
    }
    
    public func storeStorageObject(
        id objectId: UUID? = nil,
        forBucket bucketId: UUID,
        from googleResponse: KernelGoogleCloud.Core.ClientAPIModel.GCStorageObjectResponse,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelGoogleCloud.Fluent.Model.CloudStorageObject {
        try platformActor.systemOrAdmin()
        if let objectId {
            return try await .update(
                id: objectId,
                from: googleResponse,
                onDB: selectDB(db),
                withAudit: true,
                as: platformActor,
                withOptions: .init(bucketId: bucketId)
            )
        } else {
            if let existingObject = try? await getStorageObject(
                .field(\.$googleId, googleResponse.id),
                on: db,
                as: platformActor
            ) {
                return try await .update(
                    id: existingObject.requireID(),
                    from: googleResponse,
                    onDB: selectDB(db),
                    withAudit: true,
                    as: platformActor,
                    withOptions: .init(bucketId: bucketId)
                )
            } else {
                return try await .create(
                    from: googleResponse,
                    onDB: selectDB(db),
                    withAudit: true,
                    as: platformActor,
                    withOptions: .init(bucketId: bucketId)
                )
            }
        }
    }
    
    @discardableResult
    public func storeStorageObjects(
        forBucket bucketId: UUID,
        from googleResponse: KernelGoogleCloud.Core.ClientAPIModel.GCStorageObjectListResponse,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> [KernelGoogleCloud.Fluent.Model.CloudStorageObject] {
        try platformActor.systemOrAdmin()
        return try await googleResponse.items?.asyncMap { storageObject in
            try await storeStorageObject(
                forBucket: bucketId,
                from: storageObject,
                on: db,
                as: platformActor
            )
        } ?? []
    }
}
