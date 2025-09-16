//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelGoogleCloud.Routes.StorageBucket_v1_0 {
    public func bootStorageBucketRoutes(routes: TypedRoutesBuilder) throws {
        routes.post(use: createStorageBucketHandler).summary("Create Storage Bucket")
        routes.get(":bucketId".parameterType(UUID.self).description("Bucket ID"), use: getStorageBucketHandler).summary("Get Storage Bucket")
        routes.get(use: listStorageBucketsHandler).summary("List Storage Buckets")
        routes.put(":bucketId".parameterType(UUID.self).description("Bucket ID"), use: updateStorageBucketHandler).summary("Update Storage Bucket")
        routes.get("refresh", use: refreshStorageBucketsHandler).summary("Refresh Storage Buckets")
        routes.delete(":bucketId".parameterType(UUID.self).description("Bucket ID"), use: deleteStorageBucketHandler).summary("Delete Storage Bucket")
        
        let storageBucketSubroutes = routes.typeGrouped(":bucketId".parameterType(UUID.self).description("Bucket ID"))
        try storageBucketSubroutes.register(collection: Feature.StorageObject_v1_0(forContext: .storageBucket))
    }
}

extension KernelGoogleCloud.Routes.StorageBucket_v1_0 {
    public func createStorageBucketHandler(_ req: TypedRequest<CreateStorageBucketContext>) async throws -> Response {
        let bucket = try await featureContainer.services.storageBucket.createStorageBucket(
            from: try req.decodeBody(),
            as: req.platformActor
        )
        return try await bucket.encodeResponse(for: req, \.success)
    }
    
    public func getStorageBucketHandler(_ req: TypedRequest<GetStorageBucketContext>) async throws -> Response {
        let bucketId = try req.parameters.require("bucketId", as: UUID.self)
        let bucket = try await featureContainer.services.storageBucket.getStorageBucket(
            .id(bucketId),
            as: req.platformActor
        )
        return try await bucket.encodeResponse(for: req, \.success)
    }
    
    public func listStorageBucketsHandler(_ req: TypedRequest<ListStorageBucketsContext>) async throws -> Response {
        let pagedStorageBuckets = try await featureContainer.services.storageBucket.listStorageBuckets(
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            nameFilters: req.query.name,
            as: req.platformActor
        )
        return try await pagedStorageBuckets.encodeResponse(for: req, \.success)
    }
    
    public func refreshStorageBucketsHandler(_ req: TypedRequest<RefreshStorageBucketsContext>) async throws -> Response {
        let refreshedStorageBuckets = try await featureContainer.services.storageBucket.refreshStorageBuckets(
            limit: req.query.withDefault(\.limit),
            as: req.platformActor
        )
        return try await refreshedStorageBuckets.encodeResponse(for: req, \.success)
    }
    
    public func updateStorageBucketHandler(_ req: TypedRequest<UpdateStorageBucketContext>) async throws -> Response {
        let bucketId = try req.parameters.require("bucketId", as: UUID.self)
        let bucket = try await featureContainer.services.storageBucket.updateStorageBucket(
            id: bucketId,
            from: try req.decodeBody(),
            as: req.platformActor
        )
        return try await bucket.encodeResponse(for: req, \.success)
    }
    
    public func deleteStorageBucketHandler(_ req: TypedRequest<DeleteStorageBucketContext>) async throws -> Response {
        let bucketId = try req.parameters.require("bucketId", as: UUID.self)
        try await featureContainer.services.storageBucket.deleteStorageBucket(
            id: bucketId,
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.response.success.encode(.init())
    }
}

extension KernelGoogleCloud.Routes.StorageBucket_v1_0 {
    public typealias CreateStorageBucketContext = PostRouteContext<
        KernelGoogleCloud.Core.ServerAPIModel.StorageBucket.CreateStorageBucketRequest,
        KernelGoogleCloud.Core.ServerAPIModel.StorageBucket.StorageBucketResponse
    >
    
    public typealias GetStorageBucketContext = GetRouteContext<KernelGoogleCloud.Core.ServerAPIModel.StorageBucket.StorageBucketResponse>
    
    public struct ListStorageBucketsContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<KernelGoogleCloud.Core.ServerAPIModel.StorageBucket.StorageBucketResponse>> = .success(.ok)
        
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
    
    public typealias UpdateStorageBucketContext = UpdateRouteContext<
        KernelGoogleCloud.Core.ServerAPIModel.StorageBucket.UpdateStorageBucketRequest,
        KernelGoogleCloud.Core.ServerAPIModel.StorageBucket.StorageBucketResponse
    >
    
    public struct RefreshStorageBucketsContext: RouteContext {
        public init() {}
        
        public let success: ResponseContext<
            KPPaginatedResponse<KernelGoogleCloud.Core.ServerAPIModel.StorageBucket.StorageBucketResponse>
        > = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
    }
    
    public struct DeleteStorageBucketContext: RouteContext {
        public init() {}
        public let success: ResponseContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse> = .success(.ok)
        public let force: QueryParam<Bool> = .init(name: "force", defaultValue: false)
    }
}
