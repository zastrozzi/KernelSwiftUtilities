//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/06/2025.
//

import Vapor
import Fluent
import KernelSwiftCommon

public struct KernelDocumentation: KernelServerPlatform.FeatureContainer, Sendable {
    @KernelDI.Injected(\.vapor) public var app: Application
    
    public var services: Services
    
    public init() async {
        Self.logInit()
        services = .init()
    }
    
    public func postInit() async throws {
        try services.openAPI.initialiseCaches()
//        try Routes.configureRoutes(for: app)
    }
}

extension KernelDocumentation {
    public enum ConfigKeys: LabelRepresentable {
        case defaultDatabaseID
        
        public var label: String {
            switch self {
            case .defaultDatabaseID: "defaultDatabaseID"
            }
        }
    }
}
