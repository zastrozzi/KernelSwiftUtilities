//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//

import Vapor
import KernelSwiftCommon
//import KernelOpenBanking

extension KernelTaskScheduler {
    public enum Routes {}
   
}

extension KernelTaskScheduler.Routes: FeatureRoutes {
    public typealias FeatureContainer = KernelTaskScheduler
    public static var featureTag: String { "TaskScheduler" }
    public static func composed(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes.grouped("task-scheduler")
    }
    
    public static func configureRoutes(for app: Application) throws {
        let accessTokenProtectedRoutes = app.grouped(app.kernelDI(KernelIdentity.self).auth)
            .typeGrouped().security(.bearerJWT, .localDeviceIdentification)
        try accessTokenProtectedRoutes.register(collection: TaskSchedulerAdmin_v1_0<KernelTaskScheduler.EmptyAsyncJob>(forContext: .root))
    }
}

extension KernelTaskScheduler {
    
    public struct EmptyAsyncJob: AsyncConfigurableScheduledJob {
        public init() {}
        
        public func run(context: KernelTaskScheduler.AsyncQueueContext) async throws {
            preconditionFailure("Empty Async Job is a placeholder")
        }
    }
}
