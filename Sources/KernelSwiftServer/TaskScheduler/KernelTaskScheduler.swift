//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 25/06/2023.
//
import Vapor
import KernelSwiftCommon
import Fluent

//public type TaskSchedulerBuilderFunc(_ builder: KernelTaskScheduler.Builder) -> Void {}


public struct KernelTaskScheduler: KernelServerPlatform.FeatureContainer, Sendable {
//    public static let logger = makeLogger()
    @KernelDI.Injected(\.vapor) public var app: Application
    public let scheduleWorker: ScheduleWorkerService
    
    public init() {
        Self.logInit()
        self.scheduleWorker = .init()
    }
    
    public func postInit() async throws {
        Task {
            try await Task.sleep(for: .seconds(2))
            try Routes.configureRoutes(for: app)
        }
    }
}
