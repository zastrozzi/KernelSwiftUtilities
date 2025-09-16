//
//  File.swift
//
//
//  Created by Jonathan Forbes on 04/07/2023.
//

import Vapor
import KernelSwiftCommon

extension KernelTaskScheduler.Routes {
    
    public struct TaskSchedulerAdmin_v1_0<J: AsyncConfigurableScheduledJob>: ContextSwitchingRouteCollection, FeatureRouteCollection {
        public typealias Feature = KernelTaskScheduler.Routes
        public static var openAPITag: String { "Admin V1.0" }
        
        public enum RouteCollectionContext: Equatable {
            case root
            case other(_ contextTag: String)
        }
        
        public let routeCollectionContext: RouteCollectionContext

        public init(forContext routeCollectionContext: RouteCollectionContext = .root, jobType: J.Type = KernelTaskScheduler.EmptyAsyncJob.self) {
            self.routeCollectionContext = routeCollectionContext
            guard routeCollectionContext == .root || jobType != KernelTaskScheduler.EmptyAsyncJob.self else {
                fatalError("You must specify a non-EmptyJob typed Job when outside the root RouteCollectionContext.")
            }
        }
                
         public init(forContext routeCollectionContext: RouteCollectionContext = .root) {
            self.routeCollectionContext = routeCollectionContext
         }
        
         public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .root:
                routeGroup = routes.versioned("1.0", "task-scheduler").typeGrouped("admin").tags(Self.resolvedOpenAPITag)
                let jobsGroup = routeGroup.typeGrouped("jobs")
                jobsGroup.get("list", use: listJobsHandler).summary("List TaskScheduler Jobs")
                routeGroup.get("status", use: queryJobStatusHandler).summary("Query Status for TaskScheduler Job")
                routeGroup.post("all", "stop", use: stopAllJobsHandler).summary("Stop All TaskScheduler Jobs")
                routeGroup.delete("all", "remove", use: removeAllJobsHandler).summary("Remove All TaskScheduler Jobs")
                routeGroup.post("all", "resume", use: resumeAllJobsHandler).summary("Resume All TaskScheduler Jobs")
                
            case let .other(contextTag):
                routeGroup = routes.typeGrouped("task-scheduler").tags(contextTag)
                routeGroup.post("create", use: createJobHandler).summary("Create \(J.name)")
                routeGroup.post("stop", use: stopJobHandler).summary("Stop \(J.name)")
                routeGroup.post("resume", use: resumeJobHandler).summary("Resume \(J.name)")
                routeGroup.delete("remove", use: removeJobHandler).summary("Remove \(J.name)")
                routeGroup.get("status", use: getContextualJobStatusHandler).summary("Get Status for \(J.name)")
            }
        }
    }
}

// Route Handlers
extension KernelTaskScheduler.Routes.TaskSchedulerAdmin_v1_0 {
    
    public func listJobsHandler(_ req: TypedRequest<ListJobsContext>) async throws -> Response {
        let jobs = try req.kernelDI(KernelTaskScheduler.self).scheduleWorker.listAll(
            as: req.platformActor
        ).map { $0.toAPIResponse() }
        return try await req.response.success.encode(.init(results: jobs, total: jobs.count))
    }
    
    public func stopAllJobsHandler(_ req: TypedRequest<StopAllJobsContext>) async throws -> Response {
        let jobs = try req.kernelDI(KernelTaskScheduler.self).scheduleWorker.stopAll(
            as: req.platformActor
        )
        return try await req.response.success.encode(.init(results: jobs.map { $0.toAPIResponse() }, total: jobs.count))
    }
    
    public func resumeAllJobsHandler(_ req: TypedRequest<ResumeAllJobsContext>) async throws -> Response {
        let jobs = try req.kernelDI(KernelTaskScheduler.self).scheduleWorker.resumeAll(
            as: req.platformActor
        )
        return try await req.response.success.encode(.init(results: jobs.map { $0.toAPIResponse() }, total: jobs.count))
    }
    
    public func removeAllJobsHandler(_ req: TypedRequest<RemoveAllJobsContext>) async throws -> Response {
        try req.kernelDI(KernelTaskScheduler.self).scheduleWorker.removeAll(
            as: req.platformActor
        )
        return try await req.response.success.encode(.init())
    }
    
    public func createJobHandler(_ req: TypedRequest<CreateJobContext>) async throws -> Response {
        let body = try req.decodeBody()
        guard body.seconds > 0 else { throw Abort(.badRequest, reason: "Seconds must be greater than 0") }
        let job = try req.kernelDI(KernelTaskScheduler.self)
            .scheduleWorker
            .create(
                J.self,
                withBuilder: {
                    .each(.seconds(.init(integerLiteral: body.seconds)))
                },
                as: req.platformActor
            )
        return try await req.response.success.encode(job.toAPIResponse())
    }
    
    public func updateJobHandler(_ req: TypedRequest<UpdateJobContext>) async throws -> Response {
        let body = try req.decodeBody()
        let job = try req.kernelDI(KernelTaskScheduler.self)
            .scheduleWorker
            .update(
                J.name,
                withBuilder: {
                    .each(.seconds(.init(integerLiteral: body.seconds)))
                },
                as: req.platformActor
            )
        return try await req.response.success.encode(job.toAPIResponse())
    }
   
    public func stopJobHandler(_ req: TypedRequest<StopJobContext>) async throws -> Response {
        let job = try req.kernelDI(KernelTaskScheduler.self).scheduleWorker.stop(
            J.name,
            as: req.platformActor
        )
        return try await req.response.success.encode(job.toAPIResponse())
    }
    
    public func resumeJobHandler(_ req: TypedRequest<ResumeJobContext>) async throws -> Response {
        let job = try req.kernelDI(KernelTaskScheduler.self).scheduleWorker.resume(
            J.name,
            as: req.platformActor
        )
        return try await req.response.success.encode(job.toAPIResponse())
    }

    public func removeJobHandler(_ req: TypedRequest<RemoveJobContext>) async throws -> Response {
        try req.kernelDI(KernelTaskScheduler.self).scheduleWorker.remove(
            J.name,
            as: req.platformActor
        )
        return try await req.response.success.encode(.init())
    }
    
    /// when is ID used and when is name used?
    /// feels name would not be unique and would be like a kind
    public func queryJobStatusHandler(_ req: TypedRequest<QueryJobStatusContext>) async throws -> Response {
        guard let jobName = req.query.jobName else { throw Abort(.badRequest, reason: "Missing job name") }
        let job = try req.kernelDI(KernelTaskScheduler.self).scheduleWorker.getJob(
            jobName,
            as: req.platformActor
        )
        return try await req.response.success.encode(job.toAPIResponse())
    }
    
    public func getContextualJobStatusHandler(_ req: TypedRequest<GetContextualJobStatusContext>) async throws -> Response {
        let job = try req.kernelDI(KernelTaskScheduler.self).scheduleWorker.getJob(
            J.name,
            as: req.platformActor
        )
        return try await req.response.success.encode(job.toAPIResponse())
    }
}

extension KernelTaskScheduler.Routes.TaskSchedulerAdmin_v1_0 {
    public typealias JobResponse = KernelTaskScheduler.AnyConfigurableScheduledJob.APIResponse
    
    public typealias ListJobsContext = PaginatedGetRouteContext<JobResponse>
    public typealias CreateJobContext = PostRouteContext<KernelTaskScheduler.Model.CreateJobRequest, JobResponse>
    public typealias UpdateJobContext = UpdateRouteContext<KernelTaskScheduler.Model.UpdateJobRequest, JobResponse>
    public typealias GetContextualJobStatusContext = GetRouteContext<JobResponse>
    public typealias StopJobContext = PostRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyRequest, JobResponse>.WithStatus<HTTPStatus.Accepted>
    public typealias RemoveJobContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
    public typealias ResumeJobContext = PostRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyRequest, JobResponse>.WithStatus<HTTPStatus.Accepted>
    public typealias StopAllJobsContext = PostRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyRequest, KPPaginatedResponse<JobResponse>>.WithStatus<HTTPStatus.Accepted>
    public typealias RemoveAllJobsContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
    public typealias ResumeAllJobsContext = PostRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyRequest, KPPaginatedResponse<JobResponse>>.WithStatus<HTTPStatus.Accepted>
}


/// Contexts
extension KernelTaskScheduler.Routes.TaskSchedulerAdmin_v1_0 {
    public struct QueryJobStatusContext: RouteContext {
        public let jobName: QueryParam<String> = .init(name: "job_name", defaultValue: "")
        
        public init() {}
        let success: ResponseContext<JobResponse> = .success(.ok)
    }
    
    
    
    
    
    
}

