//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import Foundation
@preconcurrency import Storage
import Vapor

extension StorageBucketAPI {
    @discardableResult
    public func delete(
        bucket: String,
        queryParameters: [String: String]? = nil
    ) async throws -> EmptyResponse {
        try await self.delete(bucket: bucket, queryParameters: queryParameters).get()
    }
    
    public func get(
        bucket: String,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        try await self.get(bucket: bucket, queryParameters: queryParameters).get()
    }
    
    public func list(
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucketList {
        try await self.list(queryParameters: queryParameters).get()
    }
    
    public func getIAMPolicy(
        bucket: String,
        queryParameters: [String: String]? = nil
    ) async throws -> IAMPolicy {
        try await self.getIAMPolicy(bucket: bucket, queryParameters: queryParameters).get()
    }
    
    public func insert(
        name: String,
        acl: [[String: Any]]? = nil,
        billing: [String: Any]? = nil,
        cors: [[String: Any]]? = nil,
        defaultEventBasedHold: Bool? = nil,
        defaultObjectAcl: [[String: Any]]? = nil,
        encryption: [String: Any]? = nil,
        iamConfiguration: [String: Any]? = nil,
        labels: [String: String]? = nil,
        lifecycle: [String: Any]? = nil,
        location: String? = nil,
        logging: [String: Any]? = nil,
        rententionPolicy: [String: Any]? = nil,
        storageClass: GoogleCloudStorageClass? = nil,
        versioning: [String: Any]? = nil,
        website: [String: Any]? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        try await self.insert(
            name: name,
            acl: acl,
            billing: billing,
            cors: cors,
            defaultEventBasedHold: defaultEventBasedHold,
            defaultObjectAcl: defaultObjectAcl,
            encryption: encryption,
            iamConfiguration: iamConfiguration,
            labels: labels,
            lifecycle: lifecycle,
            location: location,
            logging: logging,
            rententionPolicy: rententionPolicy,
            storageClass: storageClass,
            versioning: versioning,
            website: website,
            queryParameters: queryParameters
        ).get()
    }
    
    public func patch(
        bucket: String,
        acl: [[String: Any]]? = nil,
        billing: [String: Any]? = nil,
        cors: [[String: Any]]? = nil,
        defaultEventBasedHold: Bool? = nil,
        defaultObjectAcl: [[String: Any]]? = nil,
        encryption: [String: Any]? = nil,
        iamConfiguration: [String: Any]? = nil,
        labels: [String: String]? = nil,
        lifecycle: [String: Any]? = nil,
        logging: [String: Any]? = nil,
        rententionPolicy: [String: Any]? = nil,
        storageClass: GoogleCloudStorageClass? = nil,
        versioning: [String: Any]? = nil,
        website: [String: Any]? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        try await self.patch(
            bucket: bucket,
            acl: acl,
            billing: billing,
            cors: cors,
            defaultEventBasedHold: defaultEventBasedHold,
            defaultObjectAcl: defaultObjectAcl,
            encryption: encryption,
            iamConfiguration: iamConfiguration,
            labels: labels,
            lifecycle: lifecycle,
            logging: logging,
            rententionPolicy: rententionPolicy,
            storageClass: storageClass,
            versioning: versioning,
            website: website,
            queryParameters: queryParameters
        ).get()
    }
    
    public func update(
        bucket: String,
        acl: [[String: Any]],
        billing: [String: Any]? = nil,
        cors: [[String: Any]]? = nil,
        defaultEventBasedHold: Bool? = nil,
        defaultObjectAcl: [[String: Any]]? = nil,
        encryption: [String: Any]? = nil,
        iamConfiguration: [String: Any]? = nil,
        labels: [String: String]? = nil,
        lifecycle: [String: Any]? = nil,
        logging: [String: Any]? = nil,
        rententionPolicy: [String: Any]? = nil,
        storageClass: GoogleCloudStorageClass? = nil,
        versioning: [String: Any]? = nil,
        website: [String: Any]? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageBucket {
        try await self.update(
            bucket: bucket,
            acl: acl,
            billing: billing,
            cors: cors,
            defaultEventBasedHold: defaultEventBasedHold,
            defaultObjectAcl: defaultObjectAcl,
            encryption: encryption,
            iamConfiguration: iamConfiguration,
            labels: labels,
            lifecycle: lifecycle,
            logging: logging,
            rententionPolicy: rententionPolicy,
            storageClass: storageClass,
            versioning: versioning,
            website: website,
            queryParameters: queryParameters
        ).get()
    }
}

