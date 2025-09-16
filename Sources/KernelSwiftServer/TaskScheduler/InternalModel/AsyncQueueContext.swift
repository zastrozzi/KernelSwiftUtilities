//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/06/2023.
//

import Queues
import Vapor
import Logging

extension KernelTaskScheduler {
    public struct AsyncQueueContext: Sendable {
        public init(queueName: QueueName, application: Application) {
            self.queueName = queueName
            self.application = application
            self.logger = application.logger
        }
        
        public let queueName: QueueName
        public let application: Application
        public let logger: Logger
    }
}
