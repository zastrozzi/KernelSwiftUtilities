//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 31/01/2025.
//

import Vapor
import Queues
import AsyncHTTPClient
import KernelSwiftCommon

public protocol ServerAPIPlatformAction: Codable, Sendable {
    associatedtype ServerJob: AsyncJob
}

extension ServerAPIPlatformAction {
    public func dispatch(
        for app: Application,
        to queueName: QueueName,
        maxRetryCount: Int = 0,
        delayUntil: Date? = nil,
        id: JobIdentifier = .init()
    ) async throws where ServerJob.Payload == Self {
        try await app.queues.queue(queueName).dispatch(
            ServerJob.self,
            self,
            maxRetryCount: maxRetryCount,
            delayUntil: delayUntil,
            id: id
        )
    }
    
    public func dispatch(
        to queue: Queue,
        maxRetryCount: Int = 0,
        delayUntil: Date? = nil,
        id: JobIdentifier = .init()
    ) async throws where ServerJob.Payload == Self {
        try await queue.dispatch(
            ServerJob.self,
            self,
            maxRetryCount: maxRetryCount,
            delayUntil: delayUntil,
            id: id
        )
    }
}
