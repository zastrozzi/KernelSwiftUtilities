//
//  File.swift
//
//
//  Created by Jonathan Forbes on 30/4/24.
//

import Vapor
import KernelSwiftCommon
import Fluent

public struct KernelIdentity: KernelServerPlatform.FeatureContainer, Sendable {
//    public static let logger = makeLogger()
    @KernelDI.Injected(\.vapor) public var app: Application
    public let enduser: Services.EnduserService
    public let adminUser: Services.AdminUserService
    public var auth: Services.AuthService
    
    public init() async {
        Self.logInit()
        self.enduser = .init()
        self.adminUser = .init()
        self.auth = .init()
        
    }
    
    public func postInit() async throws {
        guard let databaseId = config.get(.defaultDatabaseID, as: DatabaseID.self) else {
            throw Abort(.internalServerError, reason: "No default database ID found")
        }
        try await Fluent.Migrations.prepareAndMigrate(on: app, for: databaseId)
        let storedKeyId = try config.require(.storedKeyID, as: UUID.self)
        print("KERNEL IDENTITY STORED KEY ID:", storedKeyId)
        try await auth.initialise(storedKeyId: storedKeyId, as: .system)
        try Routes.configureRoutes(for: app)
        Task {
            try await Task.sleep(for: .seconds(2))
            try await Fluent.Model.registerSchemas(for: app)
        }
    }
    
//    internal func defaultDB() throws -> CRUDModel.DBAccessor {
//        try app.withDBLock(config.get(.defaultDatabaseID, as: DatabaseID.self)!)
//    }
//    
//    internal func defaultDB() -> Database {
//        app.withDBLock(config.get(.defaultDatabaseID, as: DatabaseID.self)!)
//    }
}

extension KernelIdentity {
    public enum ConfigKeys: LabelRepresentable {
        case defaultDatabaseID
        case storedKeyID
        case cryptographyKeyID
        
        public var label: String {
            switch self {
            case .cryptographyKeyID: "cryptographyKeyID"
            case .storedKeyID: "storedKeyID"
            case .defaultDatabaseID: "defaultDatabaseID"
            }
        }
    }
}
