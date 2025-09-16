//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import Vapor

extension KernelSignals.Fluent {
    public enum Model: KernelServerPlatform.FluentModel {}
}


extension KernelSignals.Fluent.Model {
    public typealias SchemaName = KernelSignals.Fluent.SchemaName
    
    public static func registerSchemas(for app: Application) async throws {
        try await app.kernelDI(KernelDynamicQuery.self).registerSchema(Event.self, as: "Event")
        try await app.kernelDI(KernelDynamicQuery.self).registerSchema(EventType.self, as: "EventType")
    }
}

extension KernelSignals.Fluent.Model {
    @_documentation(visibility: private)
    public typealias APIModel = KernelSignals.Core.APIModel
}

