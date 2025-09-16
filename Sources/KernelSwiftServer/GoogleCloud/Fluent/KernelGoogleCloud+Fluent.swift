//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

extension KernelGoogleCloud {
    public enum Fluent: KernelServerPlatform.FluentContainer {}
}

extension KernelGoogleCloud.Fluent {
    public enum SchemaName: String, KernelFluentNamespacedSchemaName {
        public static let namespace: String = "k_gc"
        
        case iamPolicy = "iam_policy"
        case storageBucket = "storage_bucket"
        case storageObject = "storage_object"
    }
}
