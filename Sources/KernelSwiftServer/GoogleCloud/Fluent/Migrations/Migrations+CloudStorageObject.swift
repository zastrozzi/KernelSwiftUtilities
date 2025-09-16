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
    public struct CloudStorageObject_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.storageObject)
                .id()
                .timestamps()
                .field("kind", .string)
                .field("g_id", .string)
                .field("self_link", .string)
                .field("name", .string)
                .field("bucket", .string)
                .field("generation", .string)
                .field("metageneration", .string)
                .field("content_type", .string)
                .field("time_created", .datetime)
                .field("updated", .datetime)
                .field("time_deleted", .datetime)
                .field("storage_class", .string)
                .field("time_storage_class_updated", .datetime)
                .field("size", .string)
                .field("md5_hash", .string)
                .field("media_link", .string)
                .field("content_encoding", .string)
                .field("content_disposition", .string)
                .field("content_language", .string)
                .field("cache_control", .string)
                .field("metadata", .dictionary(of: .string))
                .field("acl", .array(of: .json))
                .optionalGroup("owner", ownerFields)//: Owner?
                .field("crc32c", .string)
                .field("component_count", .int)
                .field("etag", .string)
                .optionalGroup("customer_encryption", customerEncryptionFields)
                .field("kms_key_name", .string)
                .field("bucket_id", .uuid, .required, .references(SchemaName.storageBucket, .id, onDelete: .cascade, onUpdate: .cascade))
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.storageObject).delete()
        }
    }
}
