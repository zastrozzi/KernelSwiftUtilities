//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/04/2025.
//

import Foundation
@preconcurrency import Storage
import Vapor

extension StorageObjectAPI {
    public func createSimpleUpload(
        bucket: String,
        body: HTTPClient.Body,
        name: String,
        contentType: String,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageObject {
        try await createSimpleUpload(
            bucket: bucket,
            body: body,
            name: name,
            contentType: contentType,
            queryParameters: queryParameters
        ).get()
    }
    
    public func createSimpleUpload(
        bucket: String,
        data: Data,
        name: String,
        contentType: String,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageObject {
        try await createSimpleUpload(
            bucket: bucket,
            body: .data(data),
            name: name,
            contentType: contentType,
            queryParameters: queryParameters
        ).get()
    }
    
    public func compose(
        bucket: String,
        destinationObject: String,
        kind: String,
        destination: [String: Any],
        sourceObjects: [[String: Any]],
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageObject {
        try await compose(
            bucket: bucket,
            destinationObject: destinationObject,
            kind: kind,
            destination: destination,
            sourceObjects: sourceObjects,
            queryParameters: queryParameters
        ).get()
    }
    
    public func copy(
        destinationBucket: String,
        destinationObject: String,
        sourceBucket: String,
        sourceObject: String,
        object: [String: Any],
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageObject {
        try await copy(
            destinationBucket: destinationBucket,
            destinationObject: destinationObject,
            sourceBucket: sourceBucket,
            sourceObject: sourceObject,
            object: object,
            queryParameters: queryParameters
        ).get()
    }
    
    @discardableResult
    public func delete(
        bucket: String,
        object: String,
        queryParameters: [String: String]? = nil
    ) async throws -> EmptyResponse {
        try await delete(
            bucket: bucket,
            object: object,
            queryParameters: queryParameters
        ).get()
    }
    
    public func get(
        bucket: String,
        object: String,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageObject {
        try await get(
            bucket: bucket,
            object: object,
            queryParameters: queryParameters
        ).get()
    }
    
    public func getMedia(
        bucket: String,
        object: String,
        range: ClosedRange<Int>? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorgeDataResponse {
        try await getMedia(
            bucket: bucket,
            object: object,
            range: range,
            queryParameters: queryParameters
        ).get()
    }
    
    public func list(
        bucket: String,
        queryParameters: [String: String]? = nil
    ) async throws -> StorageObjectList {
        try await list(
            bucket: bucket,
            queryParameters: queryParameters
        ).get()
    }
    
    public func patch(
        bucket: String,
        object: String,
        metadata: [String: Any],
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageObject {
        try await patch(
            bucket: bucket,
            object: object,
            metadata: metadata,
            queryParameters: queryParameters
        ).get()
    }
    
    public func rewrite(
        destinationBucket: String,
        destinationObject: String,
        sourceBucket: String,
        sourceObject: String,
        metadata: [String: Any],
        queryParameters: [String: String]? = nil
    ) async throws -> StorageRewriteObject {
        try await rewrite(
            destinationBucket: destinationBucket,
            destinationObject: destinationObject,
            sourceBucket: sourceBucket,
            sourceObject: sourceObject,
            metadata: metadata,
            queryParameters: queryParameters
        ).get()
    }
    
    public func update(
        bucket: String,
        object: String,
        acl: [[String: Any]],
        cacheControl: String? = nil,
        contentDisposition: String? = nil,
        contentEncoding: String? = nil,
        contentLanguage: String? = nil,
        contentType: String? = nil,
        eventBasedHold: Bool? = nil,
        metadata: [String: String]? = nil,
        temporaryHold: Bool? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> GoogleCloudStorageObject {
        try await update(
            bucket: bucket,
            object: object,
            acl: acl,
            cacheControl: cacheControl,
            contentDisposition: contentDisposition,
            contentEncoding: contentEncoding,
            contentLanguage: contentLanguage,
            contentType: contentType,
            eventBasedHold: eventBasedHold,
            metadata: metadata,
            temporaryHold: temporaryHold,
            queryParameters: queryParameters
        ).get()
    }
    
    public func watchAll(
        bucket: String,
        kind: String,
        id: String,
        resourceId: String,
        resourceUri: String,
        token: String? = nil,
        expiration: Date? = nil,
        type: String,
        address: String,
        params: [String: String]? = nil,
        payload: Bool? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> StorageNotificationChannel {
        try await watchAll(
            bucket: bucket,
            kind: kind,
            id: id,
            resourceId: resourceId,
            resourceUri: resourceUri,
            token: token,
            expiration: expiration,
            type: type,
            address: address,
            params: params,
            payload: payload,
            queryParameters: queryParameters
        ).get()
    }
}
