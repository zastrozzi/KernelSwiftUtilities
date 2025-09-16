//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/06/2023.
//

import Vapor
import KernelSwiftCommon
import NIOConcurrencyHelpers
import Fluent

//extension KernelNetworking: KernelServerPlatform.FeatureContainer {
//    private(set) var resolvedHost: ResolvedHostService
//    public var app: Application
//
//    public init(for app: Application) {
//        self.app = app
//        Self.logger.info("Initialising KernelNetworking")
//        self.resolvedHost = .init()
//        app.middleware.use(self.resolvedHost)
//    }
//}

public struct KernelNetworking: KernelServerPlatform.FeatureContainer, Sendable {
//    public static let logger = makeLogger()
    private(set) var resolvedHost: ResolvedHostService
    @KernelDI.Injected(\.vapor) public var app: Application
    
    public init() {
//        self.app = app
        Self.logInit()
        self.resolvedHost = .init()
        app.middleware.use(self.resolvedHost)
    }
}

extension KernelNetworking {
    public enum ConfigKeys: LabelRepresentable {
        case defaultRSAKeySize
        
        public var label: String {
            switch self {
            case .defaultRSAKeySize: "defaultRSAKeySize"
            }
        }
    }
}
