//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 3/4/24.
//

import Vapor
import KernelSwiftCommon
import Fluent

public struct KernelAuthSessions: KernelServerPlatform.FeatureContainer, Sendable {
//    public static let logger = makeLogger()
    @KernelDI.Injected(\.vapor) public var app: Application
    
    public init() async {
        Self.logInit()
        do {
            try Routes.configureRoutes(for: app)
            app.middleware.use(Services.AuthSessionMiddleware())
        } catch let error {
            KernelAuthSessions.logger.error("Failed KernelAuthSessions Init")
            KernelAuthSessions.logger.report(error: error)
        }
    }
}

extension KernelAuthSessions {
    public enum ConfigKeys: LabelRepresentable {
        case defaultOAuthProvider
        
        public var label: String {
            switch self {
            case .defaultOAuthProvider: "defaultOAuthProvider"
            }
        }
    }
}
