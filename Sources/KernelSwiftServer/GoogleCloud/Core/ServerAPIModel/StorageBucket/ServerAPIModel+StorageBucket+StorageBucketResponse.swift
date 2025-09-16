//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelGoogleCloud.Core.ServerAPIModel.StorageBucket {
    public struct StorageBucketResponse: OpenAPIContent {
        public var id: UUID
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var acl: [KernelGoogleCloud.Core.Common.BucketAccessControls]?
        public var billing: KernelGoogleCloud.Core.Common.Billing?
        public var cors: [KernelGoogleCloud.Core.Common.CORS]?
        public var defaultEventBasedHold: Bool?
        public var defaultObjectAcl: [KernelGoogleCloud.Core.Common.ObjectAccessControls]?
        public var encryption: KernelGoogleCloud.Core.Common.Encryption?
        public var etag: String?
        public var googleId: String?
        public var kind: String?
        public var labels: [String: String]?
        public var lifecycle: KernelGoogleCloud.Core.Common.Lifecycle?
        public var location: String?
        public var logging: KernelGoogleCloud.Core.Common.Logging?
        public var metageneration: String?
        public var name: String?
        public var owner: KernelGoogleCloud.Core.Common.Owner?
        public var projectNumber: String?
        public var selfLink: String?
        public var retentionPolicy: KernelGoogleCloud.Core.Common.RetentionPolicy?
        public var storageClass: String?
        public var timeCreated: Date?
        public var updated: Date?
        public var versioning: KernelGoogleCloud.Core.Common.Versioning?
        public var website: KernelGoogleCloud.Core.Common.Website?
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            acl: [KernelGoogleCloud.Core.Common.BucketAccessControls]? = nil,
            billing: KernelGoogleCloud.Core.Common.Billing? = nil,
            cors: [KernelGoogleCloud.Core.Common.CORS]? = nil,
            defaultEventBasedHold: Bool? = nil,
            defaultObjectAcl: [KernelGoogleCloud.Core.Common.ObjectAccessControls]? = nil,
            encryption: KernelGoogleCloud.Core.Common.Encryption? = nil,
            etag: String? = nil,
            googleId: String? = nil,
            kind: String? = nil,
            labels: [String : String]? = nil,
            lifecycle: KernelGoogleCloud.Core.Common.Lifecycle? = nil,
            location: String? = nil,
            logging: KernelGoogleCloud.Core.Common.Logging? = nil,
            metageneration: String? = nil,
            name: String? = nil,
            owner: KernelGoogleCloud.Core.Common.Owner? = nil,
            projectNumber: String? = nil,
            selfLink: String? = nil,
            retentionPolicy: KernelGoogleCloud.Core.Common.RetentionPolicy? = nil,
            storageClass: String? = nil,
            timeCreated: Date? = nil,
            updated: Date? = nil,
            versioning: KernelGoogleCloud.Core.Common.Versioning? = nil,
            website: KernelGoogleCloud.Core.Common.Website? = nil
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.acl = acl
            self.billing = billing
            self.cors = cors
            self.defaultEventBasedHold = defaultEventBasedHold
            self.defaultObjectAcl = defaultObjectAcl
            self.encryption = encryption
            self.etag = etag
            self.googleId = googleId
            self.kind = kind
            self.labels = labels
            self.lifecycle = lifecycle
            self.location = location
            self.logging = logging
            self.metageneration = metageneration
            self.name = name
            self.owner = owner
            self.projectNumber = projectNumber
            self.selfLink = selfLink
            self.retentionPolicy = retentionPolicy
            self.storageClass = storageClass
            self.timeCreated = timeCreated
            self.updated = updated
            self.versioning = versioning
            self.website = website
        }
    }
}
