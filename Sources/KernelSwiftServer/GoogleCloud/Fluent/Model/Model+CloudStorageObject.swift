//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelGoogleCloud.Fluent.Model {
    public final class CloudStorageObject: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.storageObject
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @OptionalField(key: "kind") public var kind: String?
        @OptionalField(key: "g_id") public var googleId: String?
        @OptionalField(key: "self_link") public var selfLink: String?
        @OptionalField(key: "name") public var name: String?
        @OptionalField(key: "bucket") public var bucket: String?
        @OptionalField(key: "generation") public var generation: String?
        @OptionalField(key: "metageneration") public var metageneration: String?
        @OptionalField(key: "content_type") public var contentType: String?
        @OptionalField(key: "time_created") public var timeCreated: Date?
        @OptionalField(key: "updated") public var updated: Date?
        @OptionalField(key: "time_deleted") public var timeDeleted: Date?
        @OptionalField(key: "storage_class") public var storageClass: String?
        @OptionalField(key: "time_storage_class_updated") public var timeStorageClassUpdated: Date?
        @OptionalField(key: "size") public var size: String?
        @OptionalField(key: "md5_hash") public var md5Hash: String?
        @OptionalField(key: "media_link") public var mediaLink: String?
        @OptionalField(key: "content_encoding") public var contentEncoding: String?
        @OptionalField(key: "content_disposition") public var contentDisposition: String?
        @OptionalField(key: "content_language") public var contentLanguage: String?
        @OptionalField(key: "cache_control") public var cacheControl: String?
        @OptionalField(key: "metadata") public var metadata: [String: String]?
        @OptionalField(key: "acl") public var acl: [KernelGoogleCloud.Core.Common.ObjectAccessControls]?
        @OptionalGroup(key: "owner") public var owner: Fields.Owner?
        @OptionalField(key: "crc32c") public var crc32c: String?
        @OptionalField(key: "component_count") public var componentCount: Int?
        @OptionalField(key: "etag") public var etag: String?
        @OptionalGroup(key: "customer_encryption") public var customerEncryption: Fields.CustomerEncryption?
        @OptionalField(key: "kms_key_name") public var kmsKeyName: String?
        
        @Parent(key: "bucket_id") public var storageBucket: CloudStorageBucket
        
        public init() {}
    }
}

extension KernelGoogleCloud.Fluent.Model.CloudStorageObject: CRUDModel {
    public typealias CreateDTO = KernelGoogleCloud.Core.ClientAPIModel.GCStorageObjectResponse
    public typealias UpdateDTO = KernelGoogleCloud.Core.ClientAPIModel.GCStorageObjectResponse
    public typealias ResponseDTO = KernelGoogleCloud.Core.ServerAPIModel.StorageObject.StorageObjectResponse
    
    public struct CreateOptions: Sendable {
        public var bucketId: UUID
        
        public init(
            bucketId: UUID
        ) {
            self.bucketId = bucketId
        }
    }
    
    public struct UpdateOptions: Sendable {
        public var bucketId: UUID?
        
        public init(
            bucketId: UUID? = nil
        ) {
            self.bucketId = bucketId
        }
    }
    
    public static func createFields(
        from dto: CreateDTO,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        guard let options else { throw Abort(.badRequest, reason: "Missing required parameters") }
        let model = self.init()
        model.kind = dto.kind
        model.googleId = dto.id
        model.selfLink = dto.selfLink
        model.name = dto.name
        model.bucket = dto.bucket
        model.generation = dto.generation
        model.metageneration = dto.metageneration
        model.contentType = dto.contentType
        model.timeCreated = dto.timeCreated
        model.updated = dto.updated
        model.timeDeleted = dto.timeDeleted
        model.storageClass = dto.storageClass
        model.timeStorageClassUpdated = dto.timeStorageClassUpdated
        model.size = dto.size
        model.md5Hash = dto.md5Hash
        model.mediaLink = dto.mediaLink
        model.contentEncoding = dto.contentEncoding
        model.contentDisposition = dto.contentDisposition
        model.contentLanguage = dto.contentLanguage
        model.cacheControl = dto.cacheControl
        model.metadata = dto.metadata
        model.acl = dto.acl?.map { $0.toKernelGoogleCloud() }
        model.owner = try .createFields(from: dto.owner?.toKernelGoogleCloud())
        model.crc32c = dto.crc32c
        model.componentCount = dto.componentCount
        model.etag = dto.etag
        model.customerEncryption = try .createFields(from: dto.customerEncryption?.toKernelGoogleCloud())
        model.kmsKeyName = dto.kmsKeyName
        model.$storageBucket.id = options.bucketId
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.kind, from: dto.kind)
        try model.updateIfChanged(\.googleId, from: dto.id)
        try model.updateIfChanged(\.selfLink, from: dto.selfLink)
        try model.updateIfChanged(\.name, from: dto.name)
        try model.updateIfChanged(\.bucket, from: dto.bucket)
        try model.updateIfChanged(\.generation, from: dto.generation)
        try model.updateIfChanged(\.metageneration, from: dto.metageneration)
        try model.updateIfChanged(\.contentType, from: dto.contentType)
        try model.updateIfChanged(\.timeCreated, from: dto.timeCreated)
        try model.updateIfChanged(\.updated, from: dto.updated)
        try model.updateIfChanged(\.timeDeleted, from: dto.timeDeleted)
        try model.updateIfChanged(\.storageClass, from: dto.storageClass)
        try model.updateIfChanged(\.timeStorageClassUpdated, from: dto.timeStorageClassUpdated)
        try model.updateIfChanged(\.size, from: dto.size)
        try model.updateIfChanged(\.md5Hash, from: dto.md5Hash)
        try model.updateIfChanged(\.mediaLink, from: dto.mediaLink)
        try model.updateIfChanged(\.contentEncoding, from: dto.contentEncoding)
        try model.updateIfChanged(\.contentDisposition, from: dto.contentDisposition)
        try model.updateIfChanged(\.contentLanguage, from: dto.contentLanguage)
        try model.updateIfChanged(\.cacheControl, from: dto.cacheControl)
        try model.updateIfChanged(\.metadata, from: dto.metadata)
        try model.updateIfChanged(\.acl, from: dto.acl?.map { $0.toKernelGoogleCloud() })
        try model.updateIfChanged(\.$owner, from: dto.owner?.toKernelGoogleCloud())
        try model.updateIfChanged(\.crc32c, from: dto.crc32c)
        try model.updateIfChanged(\.componentCount, from: dto.componentCount)
        try model.updateIfChanged(\.etag, from: dto.etag)
        try model.updateIfChanged(\.$customerEncryption, from: dto.customerEncryption?.toKernelGoogleCloud())
        try model.updateIfChanged(\.kmsKeyName, from: dto.kmsKeyName)
        if let bucketId = options?.bucketId {
            try model.updateIfChanged(\.$storageBucket.id, from: bucketId)
        }
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            kind: kind,
            googleId: googleId,
            selfLink: selfLink,
            name: name,
            bucket: bucket,
            generation: generation,
            metageneration: metageneration,
            contentType: contentType,
            timeCreated: timeCreated,
            updated: updated,
            timeDeleted: timeDeleted,
            storageClass: storageClass,
            timeStorageClassUpdated: timeStorageClassUpdated,
            size: size,
            md5Hash: md5Hash,
            mediaLink: mediaLink,
            contentEncoding: contentEncoding,
            contentDisposition: contentDisposition,
            contentLanguage: contentLanguage,
            cacheControl: cacheControl,
            metadata: metadata,
            acl: acl,
            owner: try $owner.response(),
            crc32c: crc32c,
            componentCount: componentCount,
            etag: etag,
            customerEncryption: try $customerEncryption.response(),
            kmsKeyName: kmsKeyName,
            storageBucketId: $storageBucket.id
        )
    }
}
