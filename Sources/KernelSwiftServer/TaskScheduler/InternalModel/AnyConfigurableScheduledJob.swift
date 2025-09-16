//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//
import Vapor

extension KernelTaskScheduler {
    public class AnyConfigurableScheduledJob: @unchecked Sendable {
        let job: AsyncConfigurableScheduledJob
        let id: String
        var scheduleBuilder: ScheduleBuilder
        var active: Bool
        
        public init(
            job: AsyncConfigurableScheduledJob,
            id: String? = nil,
            scheduleBuilder: ScheduleBuilder,
            active: Bool = true
        ) {
            self.job = job
            self.id = id ?? job.name
            self.scheduleBuilder = scheduleBuilder
            self.active = active
        }
        
        public func withScheduler(_ scheduleBuild: ScheduleBuilder) -> Void {
            self.scheduleBuilder = scheduleBuild
        }
    }
}

extension KernelTaskScheduler.AnyConfigurableScheduledJob {
    public func schedule(context: KernelTaskScheduler.AsyncQueueContext) -> KernelTaskScheduler.SchedulerTask {
        let done = AsyncPromise(Bool.self)
        let spawned = AsyncPromise(Bool.self)
        let nextDate = self.scheduleBuilder.nextDate()
        let task: Task<Void, Swift.Error> = .init {
            if #available(macOS 13, iOS 16.0, *) {
                try await Task.sleep(until: .now.advanced(by: .seconds(Date.now.distance(to: nextDate))), tolerance: .seconds(0), clock: .continuous)
            } else {
                let diff = Date.now.distance(to: nextDate)
                try await Task.sleep(nanoseconds: .init(diff * 1_000_000_000))
            }
            do { try Task.checkCancellation() }
            catch let error {
                spawned.fail(with: error)
                done.fail(with: error)
                return
            }
            do {
                spawned.fulfill(with: true)
                try await job.run(context)
                done.fulfill(with: true)
            } catch let error {
                done.fail(with: error)
                return
            }
        }
        return .init(task: task, done: done, spawned: spawned, queuedAt: .now, scheduledFor: nextDate)
    }
}

extension KernelTaskScheduler.AnyConfigurableScheduledJob {
    public func toAPIResponse() -> APIResponse {
        return .init(id: id, schedule: scheduleBuilder.toAPIResponse(), name: job.name, active: active)
    }
    
    public struct APIResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public let id: String
        public let schedule: KernelTaskScheduler.ScheduleBuilder.APIResponse
        public let name: String
        public let active: Bool
    }
}

extension KernelTaskScheduler.AnyConfigurableScheduledJob.APIResponse {
    public static let sample: KernelTaskScheduler.AnyConfigurableScheduledJob.APIResponse = .init(
        id: "SampleScheduledJob",
        schedule: .sample,
        name: "SampleScheduledJob",
        active: true
    )
}
