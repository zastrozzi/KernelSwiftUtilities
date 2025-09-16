//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelGoogleCloud.Core.ServerAPIModel.StorageObject {
    public struct StorageObjectResponse: OpenAPIContent {
        public var id: UUID
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var kind: String?
        public var googleId: String?
        public var selfLink: String?
        public var name: String?
        public var bucket: String?
        public var generation: String?
        public var metageneration: String?
        public var contentType: String?
        public var timeCreated: Date?
        public var updated: Date?
        public var timeDeleted: Date?
        public var storageClass: String?
        public var timeStorageClassUpdated: Date?
        public var size: String?
        public var md5Hash: String?
        public var mediaLink: String?
        public var contentEncoding: String?
        public var contentDisposition: String?
        public var contentLanguage: String?
        public var cacheControl: String?
        public var metadata: [String: String]?
        public var acl: [KernelGoogleCloud.Core.Common.ObjectAccessControls]?
        public var owner: KernelGoogleCloud.Core.Common.Owner?
        public var crc32c: String?
        public var componentCount: Int?
        public var etag: String?
        public var customerEncryption: KernelGoogleCloud.Core.Common.CustomerEncryption?
        public var kmsKeyName: String?
        
        public var storageBucketId: UUID
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            kind: String? = nil,
            googleId: String? = nil,
            selfLink: String? = nil,
            name: String? = nil,
            bucket: String? = nil,
            generation: String? = nil,
            metageneration: String? = nil,
            contentType: String? = nil,
            timeCreated: Date? = nil,
            updated: Date? = nil,
            timeDeleted: Date? = nil,
            storageClass: String? = nil,
            timeStorageClassUpdated: Date? = nil,
            size: String? = nil,
            md5Hash: String? = nil,
            mediaLink: String? = nil,
            contentEncoding: String? = nil,
            contentDisposition: String? = nil,
            contentLanguage: String? = nil,
            cacheControl: String? = nil,
            metadata: [String : String]? = nil,
            acl: [KernelGoogleCloud.Core.Common.ObjectAccessControls]? = nil,
            owner: KernelGoogleCloud.Core.Common.Owner? = nil,
            crc32c: String? = nil,
            componentCount: Int? = nil,
            etag: String? = nil,
            customerEncryption: KernelGoogleCloud.Core.Common.CustomerEncryption? = nil,
            kmsKeyName: String? = nil,
            storageBucketId: UUID
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.kind = kind
            self.googleId = googleId
            self.selfLink = selfLink
            self.name = name
            self.bucket = bucket
            self.generation = generation
            self.metageneration = metageneration
            self.contentType = contentType
            self.timeCreated = timeCreated
            self.updated = updated
            self.timeDeleted = timeDeleted
            self.storageClass = storageClass
            self.timeStorageClassUpdated = timeStorageClassUpdated
            self.size = size
            self.md5Hash = md5Hash
            self.mediaLink = mediaLink
            self.contentEncoding = contentEncoding
            self.contentDisposition = contentDisposition
            self.contentLanguage = contentLanguage
            self.cacheControl = cacheControl
            self.metadata = metadata
            self.acl = acl
            self.owner = owner
            self.crc32c = crc32c
            self.componentCount = componentCount
            self.etag = etag
            self.customerEncryption = customerEncryption
            self.kmsKeyName = kmsKeyName
            self.storageBucketId = storageBucketId
        }
    }
}
