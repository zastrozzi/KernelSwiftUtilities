//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import Vapor
import KernelSwiftCommon
import Fluent
@preconcurrency import Core


public struct KernelGoogleCloud: KernelServerPlatform.FeatureContainer, Sendable {
    @KernelDI.Injected(\.vapor) public var app: Application
    
    public var services: Services
    private var credentialsCache: KernelServerPlatform.SimpleMemoryCache<APIType, GoogleCloudCredentialsConfiguration>
    
    public var cloudStorageCredentials: GoogleCloudCredentialsConfiguration {
        if let credentials = credentialsCache.get(.storage) { return credentials }
        do {
            return try makeGoogleCloudStorageCredentialsConfiguration()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
    
    public init() async {
        Self.logInit()
        services = .init()
        credentialsCache = .init()
    }
    
    public func postInit() async throws {
        guard let databaseId = config.get(.defaultDatabaseID, as: DatabaseID.self) else {
            throw Abort(.internalServerError, reason: "No default database ID found")
        }
        try await Fluent.Migrations.prepareAndMigrate(on: app, for: databaseId)
        try Routes.configureRoutes(for: app)
        try await Fluent.Model.registerSchemas(for: app)
        try makeGoogleCloudStorageCredentialsConfiguration()
    }
    
    @discardableResult
    private func makeGoogleCloudStorageCredentialsConfiguration() throws -> GoogleCloudCredentialsConfiguration {
        guard let googleCloudProjectId = config.get(.googleCloudProjectID, as: String.self),
              let googleCloudStorageCredentialsPath = config.get(.googleCloudStorageCredentialsPath, as: String.self)
        else {
            throw Abort(.internalServerError, reason: "Missing required Google Cloud Storage Configuration")
        }
        return credentialsCache.set(
            .storage,
            value: try .init(
                projectId: googleCloudProjectId,
                credentialsFile: googleCloudStorageCredentialsPath
            )
        )
    }
}

extension KernelGoogleCloud {
    public enum APIType: String, Sendable {
        case storage
    }
    
    public enum ConfigKeys: LabelRepresentable {
        case defaultDatabaseID
        case googleCloudProjectID
        case googleCloudStorageCredentialsPath
        
        public var label: String {
            switch self {
            case .defaultDatabaseID: "defaultDatabaseID"
            case .googleCloudProjectID: "googleCloudProjectID"
            case .googleCloudStorageCredentialsPath: "googleCloudStorageCredentialsPath"
            }
        }
    }
}
