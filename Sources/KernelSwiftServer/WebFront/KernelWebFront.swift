//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/4/24.
//

import Vapor
import KernelSwiftCommon
import Fluent

public struct KernelWebFront: KernelServerPlatform.FeatureContainer, Sendable {
    @KernelDI.Injected(\.vapor) public var app: Application
    public let flows: Services.FlowService
//    public static let logger = makeLogger()
    
    public init() async {
        Self.logInit()
        self.flows = .init()
        do {
            try Routes.configureRoutes(for: app)
        } catch let error {
            KernelWebFront.logger.error("Failed KernelWebFront Init")
            KernelWebFront.logger.report(error: error)
        }
    }
    
    public func postInit() async throws {
        guard let databaseId = config.get(.defaultDatabaseID, as: DatabaseID.self) else {
            throw KernelFluentModel.TypedError(.databaseIdNotConfigured)
        }
        try await Fluent.Migrations.prepareAndMigrate(on: app, for: databaseId)
    }
    
    internal func defaultDB() throws -> CRUDModel.DBAccessor {
        try app.withDBLock(config.get(.defaultDatabaseID, as: DatabaseID.self)!)
    }
    
    internal func defaultDB() throws -> Database {
        try app.withDBLock(config.get(.defaultDatabaseID, as: DatabaseID.self)!)
    }
}

extension KernelWebFront {
    public enum ConfigKeys: LabelRepresentable {
        case defaultDatabaseID
        
        public var label: String {
            switch self {
            case .defaultDatabaseID: "defaultDatabaseID"
            }
        }
    }
}
