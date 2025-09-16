//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import Vapor
import Queues

public struct JobMetadata: Sendable {
    public var id: String
    public var queueName: String
    public var maxRetryCount: Int
    public var delayUntil: Date?
    public var queuedAt: Date
    public var jobName: String
    
    public init(
        id: String,
        queueName: String,
        maxRetryCount: Int,
        delayUntil: Date? = nil,
        queuedAt: Date,
        jobName: String
    ) {
        self.id = id
        self.queueName = queueName
        self.maxRetryCount = maxRetryCount
        self.delayUntil = delayUntil
        self.queuedAt = queuedAt
        self.jobName = jobName
    }
    
    public init(from jobEventData: JobEventData) {
        self.init(
            id: jobEventData.id,
            queueName: jobEventData.queueName,
            maxRetryCount: jobEventData.maxRetryCount,
            delayUntil: jobEventData.delayUntil,
            queuedAt: jobEventData.queuedAt,
            jobName: jobEventData.jobName
        )
    }
}
