//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import Vapor
import Fluent
import Queues
import KernelSwiftCommon
import SQLKit

public struct KernelSignals: KernelServerPlatform.FeatureContainer, Sendable, FeatureContainerAPIModelAccessible {
    public typealias APIModel = Core.APIModel
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
        try await Fluent.Model.registerSchemas(for: app)
        
        //        try Actions.setup(for: app)
        //        try await runTestTask()
        
        
    }
}

extension KernelSignals {
    public enum ConfigKeys: LabelRepresentable {
        case defaultDatabaseID
        
        public var label: String {
            switch self {
            case .defaultDatabaseID: "defaultDatabaseID"
            }
        }
    }
}
