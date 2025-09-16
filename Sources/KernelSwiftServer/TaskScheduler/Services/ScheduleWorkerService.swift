//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon
import NIOConcurrencyHelpers

extension KernelTaskScheduler {
    public struct ScheduleWorkerService: Sendable {

        private let taskCache: KernelServerPlatform.SimpleMemoryCache<String, [SchedulerTask]>
        private let jobCache: KernelServerPlatform.SimpleMemoryCache<String, AnyConfigurableScheduledJob>

        @KernelDI.Injected(\.vapor) var app: Application
        
        public init() {
            self.taskCache = .init()
            self.jobCache = .init()
        }

        func schedule(
            _ job: AnyConfigurableScheduledJob,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws {
            try platformActor.systemOrAdmin()
            guard job.active else {
                KernelTaskScheduler.logger.debug("Job should not be scheduled - not active \(job.id)")
                return
            }
            let context: AsyncQueueContext = .init(queueName: .init(string: "scheduled"), application: app)
            let task = job.schedule(context: context)
            
            task.done.future(for: app.eventLoopGroup.next()).whenComplete { res in
                switch res {
                case .failure(let error):
                    KernelTaskScheduler.logger.error("\(job.job.name) failed to complete: \(error)")
                    break
                case .success(let successful):
                    if !successful {
                        KernelTaskScheduler.logger.error("\(job.job.name) failed to complete with unknown error")
                    }
                }
                if var jobSet = self.taskCache.get(job.id) {
                    jobSet.removeAll { task.id == $0.id }
                    self.taskCache.set(job.id, value: jobSet)
                }
            }
            
            task.spawned.future(for: app.eventLoopGroup.next()).whenComplete { res in
                switch res {
                case .failure(let error):
                    KernelTaskScheduler.logger.error("\(job.job.name) failed to spawn: \(error)")
                    break
                case .success(let successful):
                    if !successful {
                        KernelTaskScheduler.logger.error("\(job.job.name) failed to spawn with unknown error")
                    }
                }
                if let job = self.jobCache.get(job.id), job.active == true {
                    Task.detached { try self.schedule(job, as: platformActor) }
                }
            }
            
            if var jobSet = taskCache.get(job.id) {
                jobSet.append(task)
                taskCache.set(job.id, value: jobSet)
            } else {
                taskCache.set(job.id, value: [task])
            }
        }
        
        public func getJob(
            _ jobIdentifier: String,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws -> AnyConfigurableScheduledJob {
            try platformActor.systemOrAdmin()
            guard let job = jobCache.get(jobIdentifier) else { throw TypedError(.jobNotFound, httpStatus: .notFound) }
            return job
        }
        
        @discardableResult
        public func create<J: AsyncConfigurableScheduledJob>(
            _ job: J.Type,
            withCustomIdentifier jobIdentifier: String? = nil,
            active: Bool = true,
            withBuilder: () -> KernelTaskScheduler.ScheduleBuilder,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws -> AnyConfigurableScheduledJob {
            try platformActor.systemOrAdmin()
            let job = AnyConfigurableScheduledJob(
                job: J.init() as AsyncConfigurableScheduledJob,
                id: jobIdentifier,
                scheduleBuilder: withBuilder(),
                active: active
            )
            guard !jobCache.has(job.id) else { throw TypedError(.jobAlreadyExists, httpStatus: .conflict) }
            jobCache.set(job.id, value: job)
            if active { try schedule(job, as: platformActor) }
            return job
        }
        
        @discardableResult
        public func update(
            _ jobIdentifier: String,
            withBuilder builder: () -> KernelTaskScheduler.ScheduleBuilder,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws -> AnyConfigurableScheduledJob {
            try platformActor.systemOrAdmin()
            guard let job = jobCache.get(jobIdentifier) else { throw TypedError(.jobNotFound, httpStatus: .notFound) }
            job.scheduleBuilder = builder()
            jobCache.set(jobIdentifier, value: job)
            if job.active { try schedule(job, as: platformActor) }
            return job
        }
        
        public func remove(
            _ jobIdentifier: String,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws {
            try platformActor.systemOrAdmin()
            jobCache.unset(jobIdentifier)
            taskCache.get(jobIdentifier)?.forEach { $0.cancel() }
            taskCache.unset(jobIdentifier)
        }
        
        @discardableResult
        public func stop(
            _ jobIdentifier: String,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws -> AnyConfigurableScheduledJob {
            try platformActor.systemOrAdmin()
            guard let job = jobCache.get(jobIdentifier) else { throw TypedError(.jobNotFound, httpStatus: .notFound) }
            job.active = false
            jobCache.set(jobIdentifier, value: job)
            taskCache.get(jobIdentifier)?.forEach { $0.cancel() }
            taskCache.unset(jobIdentifier)
            return job
        }
        
        @discardableResult
        public func resume(
            _ jobIdentifier: String,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws -> AnyConfigurableScheduledJob {
            try platformActor.systemOrAdmin()
            guard let job = jobCache.get(jobIdentifier) else { throw TypedError(.jobNotFound, httpStatus: .notFound) }
            job.active = true
            jobCache.set(jobIdentifier, value: job)
            try schedule(job, as: platformActor)
            return job
        }
        
        public func listAll(
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws -> [AnyConfigurableScheduledJob] {
            try platformActor.systemOrAdmin()
            return jobCache.all()
        }
        
        public func removeAll(
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws {
            try platformActor.systemOrAdmin()
            for job in jobCache.all() {
                try remove(job.id, as: platformActor)
            }
        }
        
        @discardableResult
        public func stopAll(
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws -> [AnyConfigurableScheduledJob] {
            try platformActor.systemOrAdmin()
            return try jobCache.all().map {
                try stop(
                    $0.id,
                    as: platformActor
                )
            }
        }
        
        @discardableResult
        public func resumeAll(
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws -> [AnyConfigurableScheduledJob] {
            try platformActor.systemOrAdmin()
            return try jobCache.all().map {
                try resume(
                    $0.id,
                    as: platformActor
                )
            }
        }
    }
    
}
