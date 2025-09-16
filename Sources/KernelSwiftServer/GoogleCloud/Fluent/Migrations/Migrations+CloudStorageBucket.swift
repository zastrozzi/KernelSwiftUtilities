//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelGoogleCloud.Fluent.Migrations {
    public struct CloudStorageBucket_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.storageBucket)
                .id()
                .timestamps()
                .field("acl", .array(of: .json))//: [BucketAccessControls]?
                .optionalGroup("billing", billingFields)//: Billing?
                .field("cors", .array(of: .json))//: [Cors]?
                .field("def_event_based_hold", .bool)//: Bool?
                .field("def_object_acl", .array(of: .json))//: [ObjectAccessControls]?
                .optionalGroup("encryption", encryptionFields)//: Encryption?
                .field("etag", .string)//: String?
                .field("g_id", .string)//: String?
                .field("kind", .string)//: String?
                .field("labels", .dictionary(of: .string))//: [String: String]?
                .optionalGroup("lifecycle", lifecycleFields)//: Lifecycle?
                .field("location", .string)//: String?
                .optionalGroup("logging", loggingFields)//: Logging?
                .field("metageneration", .string)//: String?
                .field("name", .string)//: String?
                .optionalGroup("owner", ownerFields)//: Owner?
                .field("project_number", .string)//: String?
                .field("self_link", .string)//: String?
                .optionalGroup("retention_policy", retentionPolicyFields)//: RetentionPolicy?
                .field("storage_class", .string)//: String?
                .field("time_created", .datetime)//: Date?
                .field("updated", .datetime)//: Date?
                .optionalGroup("versioning", versioningFields)//: Versioning?
                .optionalGroup("website", websiteFields)//: Website?
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.storageBucket).delete()
        }
    }
}
