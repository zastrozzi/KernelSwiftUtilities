//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import Fluent
import Queues
import KernelSwiftCommon
import SQLKit

public struct KernelDynamicQuery: KernelServerPlatform.FeatureContainer, Sendable, FeatureContainerAPIModelAccessible {
    public typealias APIModel = KernelDynamicQuery.Core.APIModel
    @KernelDI.Injected(\.vapor) public var app: Application
    
    public var services: Services
    
    public init() async {
        Self.logInit()
        services = .init()
    }
    
    public func postInit() async throws {
        guard let databaseId = config.get(.defaultDatabaseID, as: DatabaseID.self) else {
            throw Abort(.internalServerError, reason: "No default database ID found")
        }
        try await Fluent.Migrations.prepareAndMigrate(on: app, for: databaseId)
        try Routes.configureRoutes(for: app)
        
//        try Actions.setup(for: app)
//        try await runTestTask()
        

    }
    
    public func registerSchema<SchemaModel: KernelFluentNamespacedModel>(
        _ modelType: SchemaModel.Type,
        as schemaDisplayName: String,
        on db: DatabaseID? = nil
    ) async throws {
        try await services.schema.registerSchema(modelType, as: schemaDisplayName, on: db)
    }
    
    public func registerSchemas<each SchemaModel: KernelFluentNamespacedModel>(
        _ schemas: repeat ((each SchemaModel).Type, String),
        on db: DatabaseID? = nil
    ) async throws {
        for schema in repeat each schemas {
            try await services.schema.registerSchema(schema.0, as: schema.1, on: db)
        }
    }
        
}

extension KernelDynamicQuery {
    public enum ConfigKeys: LabelRepresentable {
        case defaultDatabaseID
        
        public var label: String {
            switch self {
            case .defaultDatabaseID: "defaultDatabaseID"
            }
        }
    }
}
