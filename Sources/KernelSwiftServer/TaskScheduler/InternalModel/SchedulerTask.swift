//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//
import Vapor

extension KernelTaskScheduler {
    public struct SchedulerTask: Equatable, Sendable {
        public init(
            task: Task<Void, Swift.Error>,
            done: AsyncPromise<Bool>,
            spawned: AsyncPromise<Bool>,
            queuedAt: Date,
            scheduledFor: Date
        ) {
            self.task = task
            self.done = done
            self.spawned = spawned
            self.queuedAt = queuedAt
            self.scheduledFor = scheduledFor
            self.id = .timeOrderedUUIDV4()
        }
        
        public let task: Task<Void, Swift.Error>
        public let done: AsyncPromise<Bool>
        public let spawned: AsyncPromise<Bool>
        public let queuedAt: Date
        public let scheduledFor: Date
        public let id: UUID
        
        public func cancel() {
            self.done.fail(with: KernelTaskScheduler.TypedError(.cancelledTask))
            self.spawned.fail(with: KernelTaskScheduler.TypedError(.cancelledTask))
            self.task.cancel()
        }
        
        public static func == (lhs: SchedulerTask, rhs: SchedulerTask) -> Bool {
            lhs.id == rhs.id
        }
    }
}

