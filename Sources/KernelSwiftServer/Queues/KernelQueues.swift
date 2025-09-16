//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 28/01/2025.
//

import Vapor
import Queues
import KernelSwiftCommon

public struct KernelQueues: KernelServerPlatform.FeatureContainer, Sendable {
//    public static let logger = makeLogger()
    @KernelDI.Injected(\.vapor) public var app: Application
    
    public let jobManager: JobManager
    
    public init() {
        Self.logInit()
        self.jobManager = .init()
        app.queues.add(jobManager)
        self.app.lifecycle.use(jobManager)
    }
}

extension KernelQueues {
    public enum ConfigKeys: LabelRepresentable {
        case clearOnShutdown
        
        public var label: String {
            switch self {
            case .clearOnShutdown: "clearOnShutdown"
            }
        }
    }
}


extension KernelQueues {
    public enum JobStatus: Sendable, Hashable, CaseIterable, Equatable {
        case dispatched
        case dequeued
        case success
        case error
    }
}
