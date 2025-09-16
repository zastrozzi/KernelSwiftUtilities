//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

import Queues
import NIOConcurrencyHelpers
import Vapor
import Fluent
import KernelSwiftCommon

public struct KernelCryptography: KernelServerPlatform.FeatureContainer, Sendable {
//    public static let logger = makeLogger()
    @KernelDI.Injected(\.vapor) public var app: Application
    public let rsa: Services.RSAService
    public let ec: Services.ECService
    public let otp: Services.OTPService
    
    public init() async {
        Self.logInit()
        self.rsa = .init()
        self.ec = .init()
        self.otp = .init()
//        do {
//            
//        } catch let error {
//            KernelCryptography.logger.error("Failed KernelCryptography Init")
//            KernelCryptography.logger.report(error: error)
//        }
    }
    
    public func postInit() async throws {
        guard let databaseId = config.get(.defaultDatabaseID, as: DatabaseID.self) else {
            throw KernelFluentModel.TypedError(.databaseIdNotConfigured)
        }
        try await Fluent.Migrations.prepareAndMigrate(on: app, for: databaseId)
        Task {
            try await Task.sleep(for: .seconds(2))
            try Routes.configureRoutes(for: app)
        }
    }
}
