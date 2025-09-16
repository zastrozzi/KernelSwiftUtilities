//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 9/25/23.
//

import Vapor

extension KernelCryptography.EC {
    public struct ReplenishECCaches: AsyncConfigurableScheduledJob {
        public init() {} // add protocol req to require empty init on AsncCOnfigurableJob
        
        public func run(context: KernelTaskScheduler.AsyncQueueContext) async throws {
            try await context.application.kernelDI(KernelCryptography.self).ec.replenishCaches(as: .system)
        }
    }
}

