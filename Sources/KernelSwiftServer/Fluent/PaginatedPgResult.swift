//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/10/2022.
//

import Foundation
import Vapor
import Fluent

public struct PaginatedPgResult<PgModelType: Model>: Sendable {
    public var results: [PgModelType]
    public var total: Int
    
    public init(results: [PgModelType], total: Int) {
        self.results = results
        self.total = total
    }
    
    public init(results: [PgModelType]) {
        self.results = results
        self.total = results.count
    }
}

extension PaginatedPgResult where
    PgModelType: CRUDModel,
    PgModelType.ResponseDTO: OpenAPIEncodableSampleable & Codable & Equatable & Content
{
    public func paginatedResponse(
        withOptions options: PgModelType.ResponseOptions? = nil
    ) throws -> KPPaginatedResponse<PgModelType.ResponseDTO> {
        .init(results: try results.map { try $0.response(withOptions: options) }, total: total)
    }
    
    public func paginatedResponse(
        onDB db: @escaping CRUDModel.DBAccessor,
        withOptions options: PgModelType.ResponseOptions? = nil
    ) async throws -> KPPaginatedResponse<PgModelType.ResponseDTO> {
        await .init(results: try results.asyncMap { try await $0.response(onDB: db, withOptions: options) }, total: total)
    }
    
    public func encodeResponse<Context: RouteContext>(
        for request: TypedRequest<Context>,
        _ contextPath: KeyPath<Context, ResponseContext<KPPaginatedResponse<PgModelType.ResponseDTO>>>,
        withOptions options: PgModelType.ResponseOptions? = nil
    ) async throws -> Response {
        try await request.response.makeEncoder(path: contextPath)
            .encode(try self.paginatedResponse(withOptions: options))
    }
    
    public func encodeAsyncResponse<Context: RouteContext>(
        for request: TypedRequest<Context>,
        _ contextPath: KeyPath<Context, ResponseContext<KPPaginatedResponse<PgModelType.ResponseDTO>>>,
        onDB db: @escaping CRUDModel.DBAccessor,
        withOptions options: PgModelType.ResponseOptions? = nil
    ) async throws -> Response {
        try await request.response.makeEncoder(path: contextPath)
            .encode(try self.paginatedResponse(onDB: db, withOptions: options))
    }
}

public enum KernelFluentUpsertStatus {
    case create
    case update
}

public struct KernelFluentUpsertResult<Result> {
    public var status: KernelFluentUpsertStatus
    public var result: Result
    
    public init(status: KernelFluentUpsertStatus, result: Result) {
        self.status = status
        self.result = result
    }
}
