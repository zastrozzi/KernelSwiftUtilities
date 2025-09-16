//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelGoogleCloud.Routes.StorageObject_v1_0 {
    public func bootStorageObjectRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":objectId".parameterType(UUID.self), use: getStorageObjectHandler).summary("Get Storage Object")
        routes.get(use: listStorageObjectsHandler).summary("List Storage Objects")
        routes.put(":objectId".parameterType(UUID.self), use: updateStorageObjectHandler).summary("Update Storage Object")
        routes.delete(":objectId".parameterType(UUID.self), use: deleteStorageObjectHandler).summary("Delete Storage Object")
        routes.delete(use: deleteManyStorageObjectsHandler).summary("Delete Many Storage Objects")
    }
    
    public func bootStorageObjectRoutesForStorageBucket(routes: TypedRoutesBuilder, tag: String) throws {
        routes.post(body: .collect(maxSize: 100_000_000), use: uploadStorageObjectHandler)
            .contentTypes(.multipartForm).summary("Upload Storage Object to Bucket").tags(tag)
        routes.get(use: listStorageObjectsHandler).summary("List Storage Objects for Bucket").tags(tag)
        routes.get("refresh", use: refreshStorageObjectsHandler).summary("Refresh Storage Objects for Bucket").tags(tag)
    }
    
}

extension KernelGoogleCloud.Routes.StorageObject_v1_0 {
    public func uploadStorageObjectHandler(_ req: TypedRequest<UploadStorageObjectContext>) async throws -> Response {
        let object = try await featureContainer.services.storageObject.uploadStorageObject(
            forBucket: req.parameters.require("bucketId"),
            from: try req.decodeBody(),
            as: req.platformActor
        )
        return try await object.encodeResponse(for: req, \.success)
    }
    
    public func getStorageObjectHandler(_ req: TypedRequest<GetStorageObjectContext>) async throws -> Response {
        let objectId = try req.parameters.require("objectId", as: UUID.self)
        let object = try await featureContainer.services.storageObject.getStorageObject(
            .id(objectId),
            as: req.platformActor
        )
        return try await object.encodeResponse(for: req, \.success)
    }
    
    public func listStorageObjectsHandler(_ req: TypedRequest<ListStorageObjectsContext>) async throws -> Response {
        let pagedStorageObjects = try await featureContainer.services.storageObject.listStorageObjects(
            forBucket: req.parameters.get("bucketId"),
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            nameFilters: req.query.name,
            as: req.platformActor
        )
        return try await pagedStorageObjects.encodeResponse(for: req, \.success)
    }
    
    public func refreshStorageObjectsHandler(_ req: TypedRequest<RefreshStorageObjectsContext>) async throws -> Response {
        let refreshedStorageObjects = try await featureContainer.services.storageObject.refreshStorageObjects(
            forBucket: req.parameters.require("bucketId"),
            limit: req.query.withDefault(\.limit),
            as: req.platformActor
        )
        return try await refreshedStorageObjects.encodeResponse(for: req, \.success)
    }
    
    public func updateStorageObjectHandler(_ req: TypedRequest<UpdateStorageObjectContext>) async throws -> Response {
        let objectId = try req.parameters.require("objectId", as: UUID.self)
        let object = try await featureContainer.services.storageObject.updateStorageObject(
            id: objectId,
            from: try req.decodeBody(),
            as: req.platformActor
        )
        return try await object.encodeResponse(for: req, \.success)
    }
    
    public func deleteStorageObjectHandler(_ req: TypedRequest<DeleteStorageObjectContext>) async throws -> Response {
        let objectId = try req.parameters.require("objectId", as: UUID.self)
        try await featureContainer.services.storageObject.deleteStorageObject(
            id: objectId,
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.response.success.encode(.init())
    }
    
    public func deleteManyStorageObjectsHandler(_ req: TypedRequest<DeleteManyStorageObjectsContext>) async throws -> Response {
        try await featureContainer.services.storageObject.deleteManyStorageObjects(
            from: try req.decodeBody(),
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.response.success.encode(.init())
    }
    
    
}

extension KernelGoogleCloud.Routes.StorageObject_v1_0 {
    public typealias UploadStorageObjectContext = PostRouteContext<
        KernelGoogleCloud.Core.ServerAPIModel.StorageObject.UploadStorageObjectRequest,
        KernelGoogleCloud.Core.ServerAPIModel.StorageObject.StorageObjectResponse
    >
    
    public typealias GetStorageObjectContext = GetRouteContext<KernelGoogleCloud.Core.ServerAPIModel.StorageObject.StorageObjectResponse>
    
    public struct ListStorageObjectsContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<KernelGoogleCloud.Core.ServerAPIModel.StorageObject.StorageObjectResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
        public let name: StringFilterQueryParam = .init(name: "name")
    }
    
    public typealias UpdateStorageObjectContext = UpdateRouteContext<
        KernelGoogleCloud.Core.ServerAPIModel.StorageObject.UpdateStorageObjectRequest,
        KernelGoogleCloud.Core.ServerAPIModel.StorageObject.StorageObjectResponse
    >
    
    public struct RefreshStorageObjectsContext: RouteContext {
        public init() {}
        
        public let success: ResponseContext<
            KPPaginatedResponse<KernelGoogleCloud.Core.ServerAPIModel.StorageObject.StorageObjectResponse>
        > = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
    }
    
    public struct DeleteStorageObjectContext: RouteContext {
        public init() {}
        public let success: ResponseContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse> = .success(.ok)
        public let force: QueryParam<Bool> = .init(name: "force", defaultValue: false)
    }
    
    public struct DeleteManyStorageObjectsContext: RouteContext {
        public typealias RequestBodyType = KernelGoogleCloud.Core.ServerAPIModel.StorageObject.DeleteManyStorageObjectsRequest
        
        public init() {}
        public let success: ResponseContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse> = .success(.ok)
        public let force: QueryParam<Bool> = .init(name: "force", defaultValue: false)
    }
}
