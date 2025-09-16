//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2024.
//

import Vapor

extension KernelLocation.Fluent {
    public enum Model: KernelServerPlatform.FluentModel {}
}

extension KernelLocation.Fluent.Model {
    public typealias SchemaName = KernelLocation.Fluent.SchemaName
    
    public static func registerSchemas(for app: Application) async throws {
        try await app.kernelDI(KernelDynamicQuery.self).registerSchema(GeoLocation.self, as: "GeoLocation")
    }
}
