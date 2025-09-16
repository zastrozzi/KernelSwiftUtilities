//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent
@preconcurrency import Storage

extension KernelGoogleCloud.Services {
    public struct CloudStorageService: DBAccessible, Sendable {
        @KernelDI.Injected(\.vapor) public var app
        public typealias FeatureContainer = KernelGoogleCloud
        
        public init() {
            Self.logInit()
        }
        
        private struct CloudStorageHTTPClientKey: StorageKey, LockKey {
            typealias Value = HTTPClient
        }
        
        public var configuration: GoogleCloudStorageConfiguration = .default()
        
        public var client: GoogleCloudStorageClient {
            do {
                let newClient = try GoogleCloudStorageClient(
                    credentials: featureContainer.cloudStorageCredentials,
                    storageConfig: self.configuration,
                    httpClient: self.http,
                    eventLoop: app.eventLoopGroup.next()
                )
                return newClient
            } catch {
                fatalError("\(error.localizedDescription)")
            }
        }
        
        public var http: HTTPClient {
            if let existing = app.storage[CloudStorageHTTPClientKey.self] {
                return existing
            } else {
                let lock = app.locks.lock(for: CloudStorageHTTPClientKey.self)
                lock.lock()
                defer { lock.unlock() }
                if let existing = app.storage[CloudStorageHTTPClientKey.self] {
                    return existing
                }
                let new = HTTPClient(
                    eventLoopGroupProvider: .shared(app.eventLoopGroup),
                    configuration: HTTPClient.Configuration(ignoreUncleanSSLShutdown: true)
                )
                app.storage.set(CloudStorageHTTPClientKey.self, to: new) {
                    try $0.syncShutdown()
                }
                return new
            }
        }
    }
}

// MARK: - Bucket Methods
extension KernelGoogleCloud.Services.CloudStorageService {
    // FIXME: Needs to actually implement all properties to create.
    public func createBucket(
        from requestBody: KernelGoogleCloud.Core.ServerAPIModel.StorageBucket.CreateStorageBucketRequest
    ) async throws -> KernelGoogleCloud.Core.ClientAPIModel.GCStorageBucketResponse {
        try await client.buckets.insert(
            name: requestBody.name,
            location: requestBody.location
        )
    }
    
    public func getBucket(
        bucketName: String
    ) async throws -> KernelGoogleCloud.Core.ClientAPIModel.GCStorageBucketResponse {
        try await client.buckets.get(bucket: bucketName)
    }
    
    public func listBuckets(
        pageToken: String? = nil
    ) async throws -> KernelGoogleCloud.Core.ClientAPIModel.GCStorageBucketListResponse {
        let queryParameters: [String: String]?
        if let pageToken { queryParameters = ["pageToken": pageToken] } else { queryParameters = nil }
        return try await client.buckets.list(queryParameters: queryParameters)
    }
    
    // FIXME: Needs to actually implement properties to patch.
    public func patchBucket(
        bucketName: String
    ) async throws -> KernelGoogleCloud.Core.ClientAPIModel.GCStorageBucketResponse {
        try await client.buckets.patch(bucket: bucketName)
    }
    
    // FIXME: Needs to actually implement properties to update.
    public func updateBucket(
        bucketName: String,
        acl: [[String: Any]] = []
    ) async throws -> KernelGoogleCloud.Core.ClientAPIModel.GCStorageBucketResponse {
        try await client.buckets.update(bucket: bucketName, acl: acl)
    }
    
    public func deleteBucket(bucketName: String) async throws {
        try await client.buckets.delete(bucket: bucketName)
    }
}

// MARK: - Object Methods
extension KernelGoogleCloud.Services.CloudStorageService {
    public func uploadObject(
        bucketName: String,
        data: Data,
        name: String,
        contentType: String,
        queryParameters: [String: String]? = nil
    ) async throws -> KernelGoogleCloud.Core.ClientAPIModel.GCStorageObjectResponse {
        try await client.object.createSimpleUpload(
            bucket: bucketName,
            data: data,
            name: name,
            contentType: contentType,
            queryParameters: queryParameters
        )
    }
    
    public func uploadObject(
        bucketName: String,
        body: HTTPClient.Body,
        name: String,
        contentType: String,
        queryParameters: [String: String]? = nil
    ) async throws -> KernelGoogleCloud.Core.ClientAPIModel.GCStorageObjectResponse {
        try await client.object.createSimpleUpload(
            bucket: bucketName,
            body: body,
            name: name,
            contentType: contentType,
            queryParameters: queryParameters
        )
    }
    
    public func getObject(
        bucketName: String,
        objectName: String,
        queryParameters: [String: String]? = nil
    ) async throws -> KernelGoogleCloud.Core.ClientAPIModel.GCStorageObjectResponse {
        try await client.object.get(
            bucket: bucketName,
            object: objectName,
            queryParameters: queryParameters
        )
    }
    
    public func listObjects(
        bucketName: String,
        pageToken: String? = nil
    ) async throws -> KernelGoogleCloud.Core.ClientAPIModel.GCStorageObjectListResponse {
        let queryParameters: [String: String]?
        if let pageToken { queryParameters = ["pageToken": pageToken] } else { queryParameters = nil }
        return try await client.object.list(
            bucket: bucketName,
            queryParameters: queryParameters
        )
    }
    
    // FIXME: Needs to actually implement properties to patch.
    public func patchObject(
        bucketName: String,
        objectName: String,
        metadata: [String: Any],
        queryParameters: [String: String]? = nil
    ) async throws -> KernelGoogleCloud.Core.ClientAPIModel.GCStorageObjectResponse {
        try await client.object.patch(
            bucket: bucketName,
            object: objectName,
            metadata: metadata,
            queryParameters: queryParameters
        )
    }
    
    // FIXME: Needs to actually implement properties to update.
    public func updateObject(
        bucketName: String,
        objectName: String,
        acl: [[String: Any]] = [],
        queryParameters: [String: String]? = nil
    ) async throws -> KernelGoogleCloud.Core.ClientAPIModel.GCStorageObjectResponse {
        try await client.object.update(
            bucket: bucketName,
            object: objectName,
            acl: acl,
            queryParameters: queryParameters
        )
    }
    
    public func deleteObject(
        bucketName: String,
        objectName: String
    ) async throws {
        try await client.object.delete(bucket: bucketName, object: objectName)
    }
}
