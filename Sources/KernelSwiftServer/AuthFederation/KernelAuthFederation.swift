//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 3/4/24.
//

import Vapor
import KernelSwiftCommon
import Fluent

public struct KernelAuthFederation: KernelServerPlatform.FeatureContainer, Sendable {
//    public static let logger = makeLogger()
    @KernelDI.Injected(\.vapor) public var app: Application
    
    public init() async {
        Self.logInit()
        do {
            try Routes.configureRoutes(for: app)
        } catch let error {
            KernelAuthFederation.logger.error("Failed KernelAuthFederation Init")
            KernelAuthFederation.logger.report(error: error)
        }
    }
}

extension KernelAuthFederation {
    public enum ConfigKeys: LabelRepresentable {
        case defaultOAuthProvider
        
        public var label: String {
            switch self {
            case .defaultOAuthProvider: "defaultOAuthProvider"
            }
        }
    }
}

