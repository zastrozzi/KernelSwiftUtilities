//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//

import Vapor

extension KernelCryptography.RSA {
    public struct ReplenishRSACaches: AsyncConfigurableScheduledJob {
        public init() {} // add protocol req to require empty init on AsncCOnfigurableJob
        
        public func run(context: KernelTaskScheduler.AsyncQueueContext) async throws {
            try await context.application.kernelDI(KernelCryptography.self).rsa.replenishCaches(as: .system)
        }
    }
}
