//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import Vapor

extension KernelGoogleCloud.Fluent {
    public enum Model: KernelServerPlatform.FluentModel {}
}

extension KernelGoogleCloud.Fluent.Model {
    public typealias SchemaName = KernelGoogleCloud.Fluent.SchemaName
    
    public static func registerSchemas(for app: Application) async throws {
//        try await app.kernelDI(KernelDynamicQuery.self).registerSchema(CloudStorageObject.self, as: "CloudStorageObject")
    }
}
