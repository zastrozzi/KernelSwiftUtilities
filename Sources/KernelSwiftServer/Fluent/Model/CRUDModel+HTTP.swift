//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 20/01/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension CRUDModel {
    public func encodeResponse<Context: RouteContext>(
        for request: TypedRequest<Context>,
        _ contextPath: KeyPath<Context, ResponseContext<ResponseDTO>>,
        withOptions options: ResponseOptions? = nil
    ) async throws -> Response {
        try await request.response.makeEncoder(path: contextPath)
            .encode(try self.response(withOptions: options))
    }
    
    public func encodeAsyncResponse<Context: RouteContext>(
        for request: TypedRequest<Context>,
        _ contextPath: KeyPath<Context, ResponseContext<ResponseDTO>>,
        onDB db: @escaping DBAccessor,
        withOptions options: ResponseOptions? = nil
    ) async throws -> Response {
        try await request.response.makeEncoder(path: contextPath)
            .encode(try await self.response(onDB: db, withOptions: options))
    }
}
