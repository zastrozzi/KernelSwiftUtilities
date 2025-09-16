//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 28/01/2025.
//

import Vapor
import Queues
import KernelSwiftCommon

public protocol KernelAsyncJob: AsyncJob {
    init()
}

extension KernelAsyncJob {
    public static var name: String {
        typeName(Self.self)
    }
}

extension KernelQueues {
    public typealias JobName = String
    public typealias JobPayloadName = String
    
    public struct JobManager: AsyncJobEventDelegate, LifecycleHandler {
        @KernelDI.Injected(\.vapor) public var app
        
        private let jobCache: KernelServerPlatform.TaggedMemoryCache<JobStatus, String, JobMetadata>
        private let jobNameCache: KernelServerPlatform.SimpleMemoryCache<JobName, JobPayloadName>
        
        public init() {
            self.jobCache = .init()
            self.jobNameCache = .init()
        }
    }
}

extension KernelQueues.JobManager {
    public func add<J: Job>(_ job: J) throws {
        let payloadName = typeName(J.Payload.self)
        guard !jobNameCache.has(J.name) else {
            throw Abort(.conflict, reason: "Job with name \(J.name) already exists. Cannot register two jobs with the same name.")
        }
        app.queues.add(job)
        jobNameCache.set(J.name, value: payloadName)
    }
    
    public func add<J: KernelAsyncJob>(_ job: J.Type = J.self, logging: Bool = true) throws {
        let payloadName = typeName(J.Payload.self)
        guard !jobNameCache.has(J.name) else {
            throw Abort(.conflict, reason: "Job with name \(J.name) already exists. Cannot register two jobs with the same name.")
        }
        app.queues.add(job.init())
        jobNameCache.set(J.name, value: payloadName)
        if logging {
            KernelQueues.logger.info("JobManager - Registered \(J.name) with payload \(payloadName)")
        }
    }
    
    public func addMany<each J: KernelAsyncJob>(_ job: repeat (each J).Type) throws {
        repeat try add(each job, logging: false)
        let namesString = "\((repeat "*" + (each J).name))"
            .removingCharacters(in: .quotationMarks, .parentheses, .commas)
            .replacingOccurrences(of: "*", with: "\(String.tabbedNewLine())- ")
        
        KernelQueues.logger.info("JobManager - Registered \(namesString)")
    }
}

extension Application.Queues {
    public var jobManager: KernelQueues.JobManager {
        application.kernelDI(KernelQueues.self).jobManager
    }
}

extension KernelQueues.JobManager {
    public func dispatched(job: JobEventData) async throws {
        KernelQueues.logger.info("JobManager - Dispatched \(job.jobName) to \(job.queueName) [\(job.id)]")
        jobCache.set(job.id, tag: .dispatched, value: .init(from: job))
    }
    
    public func didDequeue(jobId: String) async throws {
        if let job = jobCache.value(jobId) {
            KernelQueues.logger.info("JobManager - Dequeued \(job.jobName) from \(job.queueName) [\(job.id)]")
            jobCache.replaceTag(jobId, tag: .dequeued)
        }
    }
    
    public func success(jobId: String) async throws {
        if let job = jobCache.value(jobId) {
            KernelQueues.logger.info("JobManager - Completed \(job.jobName) from \(job.queueName) [\(job.id)]")
            jobCache.replaceTag(jobId, tag: .success)
        }
    }
    
    public func error(jobId: String, error: any Error) async throws {
        if let job = jobCache.value(jobId) {
            KernelQueues.logger.info("JobManager - Failed \(job.jobName) from \(job.queueName) [\(job.id)]")
            jobCache.replaceTag(jobId, tag: .error)
        }
    }
}

extension KernelQueues.JobManager {
    public func shutdownAsync(_ application: Application) async {
        KernelQueues.logger.info("Shutting Down Job Manager")
        let jobsToClear = jobCache.values(for: [.dispatched])
        KernelQueues.logger.info("\(jobsToClear.count) Jobs To Clear")
        do {
            try await jobsToClear.asyncForEach { job in
                try await application.queues.queue(.init(string: job.queueName)).clear(.init(string: job.id)).get()
                let jobIdent = try? await application.queues.queue(.init(string: job.queueName)).pop().get()
                if let jobIdent {
                    try await application.queues.queue(.init(string: job.queueName)).clear(jobIdent).get()
                }
                
            }
            
        } catch {
            KernelQueues.logger.error("Error Clearing Jobs: \(error)")
        }
        KernelQueues.logger.info("Job Manager Cleared")
    }
}
