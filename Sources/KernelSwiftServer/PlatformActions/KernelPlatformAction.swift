//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/10/2022.
//

import Foundation
import Vapor
import Fluent
import Queues
import OpenAPIKit30
import KernelSwiftCommon


public protocol KernelPlatformAction: Codable, Sendable {
    associatedtype KPActionPathParams: Content
    associatedtype KPActionQueryParams: Content
    associatedtype KPActionRequestBody: Content
    associatedtype KPActionResponseBody: Content
    associatedtype KernelPlatformActionJob: Job
    
    var method: HTTPMethod { get set }
    var pathParams: KPActionPathParams { get set }
    var queryParams: KPActionQueryParams { get set }
    var requestBody: KPActionRequestBody { get set }
    var partialPath: String { get }
    var activePlatformApplicationId: UUID? { get set }
    
    func execute(on application: Application) async throws -> KPActionResponseBody
    init(pathParams: KPActionPathParams, queryParams: KPActionQueryParams, requestBody: KPActionRequestBody, activePlatformApplicationId: UUID?)
}

extension KernelPlatformAction {
    static var emptyPath: KernelSwiftCommon.Networking.HTTP.EmptyPath { .init() }
    static var emptyQuery: KernelSwiftCommon.Networking.HTTP.EmptyQuery { .init() }
    static var emptyRequest: KernelSwiftCommon.Networking.HTTP.EmptyRequest { .init() }
    
    static func mySelf() -> Self.Type {
        return self
    }
//    public init(pathParams: KPActionPathParams, queryParams: KPActionQueryParams, requestBody: KPActionRequestBody) { fatalError() }
}

extension KernelPlatformAction where
    KPActionPathParams == KernelSwiftCommon.Networking.HTTP.EmptyPath,
    KPActionQueryParams == KernelSwiftCommon.Networking.HTTP.EmptyQuery,
    KPActionRequestBody == KernelSwiftCommon.Networking.HTTP.EmptyRequest
{
    public init(activePlatformApplicationId: UUID? = nil) {
        self.init(pathParams: .init(), queryParams: .init(), requestBody: .init(), activePlatformApplicationId: activePlatformApplicationId)
    }
}

extension KernelPlatformAction where KPActionPathParams == KernelSwiftCommon.Networking.HTTP.EmptyPath, KPActionQueryParams == KernelSwiftCommon.Networking.HTTP.EmptyQuery {
    public init(requestBody: KPActionRequestBody, activePlatformApplicationId: UUID? = nil) {
        self.init(pathParams: .init(), queryParams: .init(), requestBody: requestBody, activePlatformApplicationId: activePlatformApplicationId)
    }
}

extension KernelPlatformAction where KPActionPathParams == KernelSwiftCommon.Networking.HTTP.EmptyPath, KPActionRequestBody == KernelSwiftCommon.Networking.HTTP.EmptyRequest {
    public init(queryParams: KPActionQueryParams, activePlatformApplicationId: UUID? = nil) {
        self.init(pathParams: .init(), queryParams: queryParams, requestBody: .init(), activePlatformApplicationId: activePlatformApplicationId)
    }
}

extension KernelPlatformAction where KPActionQueryParams == KernelSwiftCommon.Networking.HTTP.EmptyQuery, KPActionRequestBody == KernelSwiftCommon.Networking.HTTP.EmptyRequest {
    public init(pathParams: KPActionPathParams, activePlatformApplicationId: UUID? = nil) {
        self.init(pathParams: pathParams, queryParams: .init(), requestBody: .init(), activePlatformApplicationId: activePlatformApplicationId)
    }
}

extension KernelPlatformAction where KPActionPathParams == KernelSwiftCommon.Networking.HTTP.EmptyPath {
    public init(queryParams: KPActionQueryParams, requestBody: KPActionRequestBody, activePlatformApplicationId: UUID? = nil) {
        self.init(pathParams: .init(), queryParams: queryParams, requestBody: requestBody, activePlatformApplicationId: activePlatformApplicationId)
    }
}

extension KernelPlatformAction where KPActionQueryParams == KernelSwiftCommon.Networking.HTTP.EmptyQuery {
    public init(pathParams: KPActionPathParams, requestBody: KPActionRequestBody, activePlatformApplicationId: UUID? = nil) {
        self.init(pathParams: pathParams, queryParams: .init(), requestBody: requestBody, activePlatformApplicationId: activePlatformApplicationId)
    }
}

extension KernelPlatformAction where KPActionRequestBody == KernelSwiftCommon.Networking.HTTP.EmptyRequest {
    public init(pathParams: KPActionPathParams, queryParams: KPActionQueryParams, activePlatformApplicationId: UUID? = nil) {
        self.init(pathParams: pathParams, queryParams: queryParams, requestBody: .init(), activePlatformApplicationId: activePlatformApplicationId)
    }
}

//extension KernelPlatformAction {
//    public static func fromMagic(magic: ActionMagicVariables, encoder: JSONEncoder, decoder: JSONDecoder, activePlatformApplicationId: UUID? = nil) throws -> Self {
//        let magicPath = try Self.KPActionPathParams.decode(from: magic, encoder: encoder, decoder: decoder)
//        let magicQuery = try Self.KPActionQueryParams.decode(from: magic, encoder: encoder, decoder: decoder)
//        let magicRequest = try Self.KPActionRequestBody.decode(from: magic, encoder: encoder, decoder: decoder)
//        return .init(pathParams: magicPath, queryParams: magicQuery, requestBody: magicRequest, activePlatformApplicationId: activePlatformApplicationId)
//    }
//}


public protocol KernelPlatformActionJob: AsyncJob {
    associatedtype Payload = KernelPlatformAction
}

//extension KernelPlatformActionJob {
//    public func dequeueDefault<P: KernelPlatformAction>(_ context: QueueContext, _ payload: P) async throws {
//        let response = try await payload.execute(on: context.application)
//        guard let jobId = context.logger[metadataKey: "job_id"]?.description else { return }
//        return try await EventQueueRecordPgModel.setResponseData(jobId: jobId, data: response, on: context.application.db, applicationId: payload.activePlatformApplicationId)
//    }
//
//    public func errorDefault(_ context: QueueContext, _ error: Error, _ payload: Payload) async throws {
//        return
//    }
//}

public struct EmptyKernelPlatformAction: KernelPlatformAction {
    public typealias KernelPlatformActionJob = EmptyKernelPlatformActionJob
    public typealias KPActionResponseBody = KernelSwiftCommon.Networking.HTTP.EmptyResponse
    
    public var method: HTTPMethod = .GET
    public var pathParams = emptyPath
    public var queryParams = emptyQuery
    public var requestBody = emptyRequest
    public var activePlatformApplicationId: UUID?
    
    public var partialPath: String {
        return ""
    }
    
    public init(pathParams: KernelSwiftCommon.Networking.HTTP.EmptyPath, queryParams: KernelSwiftCommon.Networking.HTTP.EmptyQuery, requestBody: KernelSwiftCommon.Networking.HTTP.EmptyRequest, activePlatformApplicationId: UUID? = nil) {
        self.pathParams = pathParams
        self.queryParams = queryParams
        self.requestBody = requestBody
        self.activePlatformApplicationId = activePlatformApplicationId
    }
    
    public func execute(on application: Application) async throws -> KPActionResponseBody {
        throw Abort(.notImplemented, reason: "Action not implemented")
    }
}

public struct EmptyKernelPlatformActionJob: KernelPlatformActionJob {
    public typealias Payload = EmptyKernelPlatformAction
    
    public func dequeue(_ context: QueueContext, _ payload: Payload) async throws {
//        return try await dequeueDefault(context, payload)
    }
    
    public func error(_ context: QueueContext, _ error: Error, _ payload: Payload) async throws {
//        return try await errorDefault(context, error, payload)
    }
}
