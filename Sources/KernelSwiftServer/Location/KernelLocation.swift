//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2024.
//

import Vapor
import KernelSwiftCommon
import Fluent


public struct KernelLocation: KernelServerPlatform.FeatureContainer, Sendable {
    @KernelDI.Injected(\.vapor) public var app: Application
    
    public var services: Services
    
    public init() async {
        Self.logInit()
        services = .init()
        do {
            
            try Routes.configureRoutes(for: app)
        } catch let error {
            KernelLocation.logger.error("Failed KernelLocation Init")
            KernelLocation.logger.report(error: error)
        }
    }
    
    public func postInit() async throws {
        guard let databaseId = config.get(.defaultDatabaseID, as: DatabaseID.self) else {
            throw Abort(.internalServerError, reason: "No default database ID found")
        }
        try await Fluent.Migrations.prepareAndMigrate(on: app, for: databaseId)
        try await Fluent.Model.registerSchemas(for: app)
    }
}

extension KernelLocation {
    public enum ConfigKeys: LabelRepresentable {
        case defaultDatabaseID
        
        public var label: String {
            switch self {
            case .defaultDatabaseID: "defaultDatabaseID"
            }
        }
    }
}
