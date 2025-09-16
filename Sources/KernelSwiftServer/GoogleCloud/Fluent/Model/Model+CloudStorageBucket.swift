//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelGoogleCloud.Fluent.Model {
    public final class CloudStorageBucket: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.storageBucket
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @OptionalField(key: "acl") public var acl: [KernelGoogleCloud.Core.Common.BucketAccessControls]?
        @OptionalGroup(key: "billing") public var billing: Fields.Billing?
        @OptionalField(key: "cors") public var cors: [KernelGoogleCloud.Core.Common.CORS]?
        @OptionalBoolean(key: "def_event_based_hold") public var defaultEventBasedHold: Bool?
        @OptionalField(key: "def_object_acl") public var defaultObjectAcl: [KernelGoogleCloud.Core.Common.ObjectAccessControls]?
        @OptionalGroup(key: "encryption") public var encryption: Fields.Encryption?
        @OptionalField(key: "etag") public var etag: String?
        @OptionalField(key: "g_id") public var googleId: String?
        @OptionalField(key: "kind") public var kind: String?
        @OptionalField(key: "labels") public var labels: [String: String]?
        @OptionalGroup(key: "lifecycle") public var lifecycle: Fields.Lifecycle?
        @OptionalField(key: "location") public var location: String?
        @OptionalGroup(key: "logging") public var logging: Fields.Logging?
        @OptionalField(key: "metageneration") public var metageneration: String?
        @OptionalField(key: "name") public var name: String?
        @OptionalGroup(key: "owner") public var owner: Fields.Owner?
        @OptionalField(key: "project_number") public var projectNumber: String?
        @OptionalField(key: "self_link") public var selfLink: String?
        @OptionalGroup(key: "retention_policy") public var retentionPolicy: Fields.RetentionPolicy?
        @OptionalField(key: "storage_class") public var storageClass: String?
        @OptionalField(key: "time_created") public var timeCreated: Date?
        @OptionalField(key: "updated") public var updated: Date?
        @OptionalGroup(key: "versioning") public var versioning: Fields.Versioning?
        @OptionalGroup(key: "website") public var website: Fields.Website?
        
        public init() {}
    }
}

extension KernelGoogleCloud.Fluent.Model.CloudStorageBucket: CRUDModel {
    public typealias CreateDTO = KernelGoogleCloud.Core.ClientAPIModel.GCStorageBucketResponse
    public typealias UpdateDTO = KernelGoogleCloud.Core.ClientAPIModel.GCStorageBucketResponse
    public typealias ResponseDTO = KernelGoogleCloud.Core.ServerAPIModel.StorageBucket.StorageBucketResponse
    
    public static func createFields(
        from dto: CreateDTO,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        let model = self.init()
        model.acl = dto.acl?.map { $0.toKernelGoogleCloud() }
        model.billing = try .createFields(from: dto.billing?.toKernelGoogleCloud())
        model.cors = dto.cors?.map { $0.toKernelGoogleCloud() }
        model.defaultEventBasedHold = dto.defaultEventBasedHold
        model.defaultObjectAcl = dto.defaultObjectAcl?.map { $0.toKernelGoogleCloud() }
        model.encryption = try .createFields(from: dto.encryption?.toKernelGoogleCloud())
        model.etag = dto.etag
        model.googleId = dto.id
        model.kind = dto.kind
        model.labels = dto.labels
        model.lifecycle = try .createFields(from: dto.lifecycle?.toKernelGoogleCloud())
        model.location = dto.location
        model.logging = try .createFields(from: dto.logging?.toKernelGoogleCloud())
        model.metageneration = dto.metageneration
        model.name = dto.name
        model.owner = try .createFields(from: dto.owner?.toKernelGoogleCloud())
        model.projectNumber = dto.projectNumber
        model.selfLink = dto.selfLink
        model.retentionPolicy = try .createFields(from: dto.retentionPolicy?.toKernelGoogleCloud())
        model.storageClass = dto.storageClass
        model.timeCreated = dto.timeCreated
        model.updated = dto.updated
        model.versioning = try .createFields(from: dto.versioning?.toKernelGoogleCloud())
        model.website = try .createFields(from: dto.website?.toKernelGoogleCloud())
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.acl, from: dto.acl?.map { $0.toKernelGoogleCloud() })
        try model.updateIfChanged(\.$billing, from: dto.billing?.toKernelGoogleCloud())
        try model.updateIfChanged(\.cors, from: dto.cors?.map { $0.toKernelGoogleCloud() })
        try model.updateIfChanged(\.defaultEventBasedHold, from: dto.defaultEventBasedHold)
        try model.updateIfChanged(\.defaultObjectAcl, from: dto.defaultObjectAcl?.map { $0.toKernelGoogleCloud() })
        try model.updateIfChanged(\.$encryption, from: dto.encryption?.toKernelGoogleCloud())
        try model.updateIfChanged(\.etag, from: dto.etag)
        try model.updateIfChanged(\.googleId, from: dto.id)
        try model.updateIfChanged(\.kind, from: dto.kind)
        try model.updateIfChanged(\.labels, from: dto.labels)
        try model.updateIfChanged(\.$lifecycle, from: dto.lifecycle?.toKernelGoogleCloud())
        try model.updateIfChanged(\.location, from: dto.location)
        try model.updateIfChanged(\.$logging, from: dto.logging?.toKernelGoogleCloud())
        try model.updateIfChanged(\.metageneration, from: dto.metageneration)
        try model.updateIfChanged(\.name, from: dto.name)
        try model.updateIfChanged(\.$owner, from: dto.owner?.toKernelGoogleCloud())
        try model.updateIfChanged(\.projectNumber, from: dto.projectNumber)
        try model.updateIfChanged(\.selfLink, from: dto.selfLink)
        try model.updateIfChanged(\.$retentionPolicy, from: dto.retentionPolicy?.toKernelGoogleCloud())
        try model.updateIfChanged(\.storageClass, from: dto.storageClass)
        try model.updateIfChanged(\.timeCreated, from: dto.timeCreated)
        try model.updateIfChanged(\.updated, from: dto.updated)
        try model.updateIfChanged(\.$versioning, from: dto.versioning?.toKernelGoogleCloud())
        try model.updateIfChanged(\.$website, from: dto.website?.toKernelGoogleCloud())
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            acl: acl,
            billing: try $billing.response(),
            cors: cors,
            defaultEventBasedHold: defaultEventBasedHold,
            defaultObjectAcl: defaultObjectAcl,
            encryption: try $encryption.response(),
            etag: etag,
            googleId: googleId,
            kind: kind,
            labels: labels,
            lifecycle: try $lifecycle.response(),
            location: location,
            logging: try $logging.response(),
            metageneration: metageneration,
            name: name,
            owner: try $owner.response(),
            projectNumber: projectNumber,
            selfLink: selfLink,
            retentionPolicy: try $retentionPolicy.response(),
            storageClass: storageClass,
            timeCreated: timeCreated,
            updated: updated,
            versioning: try $versioning.response(),
            website: try $website.response()
        )
    }
}
