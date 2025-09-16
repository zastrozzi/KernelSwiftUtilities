//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2023.
//
import Vapor
import KernelSwiftCommon
import Fluent

public struct KernelX509: KernelServerPlatform.FeatureContainer, Sendable {
    @KernelDI.Injected(\.vapor) public var app: Application
    
    public init() async {
        Self.logInit()
    }
    
    public func postInit() async throws {
        guard let databaseId = config.get(.defaultDatabaseID, as: DatabaseID.self) else {
            throw Abort(.internalServerError, reason: "No default database ID found")
        }
        try await Fluent.Migrations.prepareAndMigrate(on: app, for: databaseId)
        Task {
            try await Task.sleep(for: .seconds(2))
            try Routes.configureRoutes(for: app)
        }
    }
    
    public struct Common {}
    public struct CSR {}
}

extension KernelX509 {
    public enum ConfigKeys: LabelRepresentable {
        case defaultRSAKeySize
        case defaultDatabaseID
        
        public var label: String {
            switch self {
            case .defaultRSAKeySize: "defaultRSAKeySize"
            case .defaultDatabaseID: "defaultDatabaseID"
            }
        }
    }
}
