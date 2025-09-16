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
    public static let billingFields = SchemaBuilder.GroupedFieldBuilder
        .field("req_pays", .bool)
        .create()
    
    public static let encryptionFields = SchemaBuilder.GroupedFieldBuilder
        .field("def_kms_key_name", .string)
        .create()
    
    public static let lifecycleFields = SchemaBuilder.GroupedFieldBuilder
        .field("rule", .array(of: .json))
        .create()
    
    public static let loggingFields = SchemaBuilder.GroupedFieldBuilder
        .field("log_bucket", .string)
        .field("log_object_prefix", .string)
        .create()
    
    public static let retentionPolicyFields = SchemaBuilder.GroupedFieldBuilder
        .field("eff_time", .datetime)
        .field("is_locked", .bool)
        .field("period", .int)
        .create()
    
    public static let versioningFields = SchemaBuilder.GroupedFieldBuilder
        .field("enabled", .bool)
        .create()
    
    public static let websiteFields = SchemaBuilder.GroupedFieldBuilder
        .field("main_page_suffix", .string)
        .field("not_found_page", .string)
        .create()
    
    public static let ownerFields = SchemaBuilder.GroupedFieldBuilder
        .field("entity", .string)
        .field("entity_id", .string)
        .create()
    
    public static let customerEncryptionFields = SchemaBuilder.GroupedFieldBuilder
        .field("alg", .string)
        .field("key_sha256", .string)
        .create()
    
}
