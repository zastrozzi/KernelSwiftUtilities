//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import Vapor

@dynamicMemberLookup
public struct ResponseBuilder<Context: RouteContext>: Sendable {
    public let context: Context = .shared
    private unowned let request: Request
    
    public subscript<T>(dynamicMember path: KeyPath<Context, ResponseContext<T>>) -> ResponseEncoder<T> {
        return .init(request: request, modifiers: [context[keyPath: path].configure])
    }
    
    public func makeEncoder<T>(path: KeyPath<Context, ResponseContext<T>>) -> ResponseEncoder<T> {
        return .init(request: request, modifiers: [context[keyPath: path].configure])
    }
    
    public subscript<T>(dynamicMember path: KeyPath<Context, CannedResponse<T>>) -> EventLoopFuture<Response> {
        return request.eventLoop.makeSucceededFuture(context[keyPath: path].response)
    }
    
    public subscript<T>(dynamicMember path: KeyPath<Context, CannedResponse<T>>) -> Response {
        return context[keyPath: path].response
    }
    
    public init(request: Request) {
        self.request = request
    }
    
    public struct ResponseEncoder<ResponseBodyType: ResponseEncodable & AsyncResponseEncodable>: Sendable {
        private unowned let request: Request
        private let modifiers: [@Sendable (inout Response) -> Void]
        
        public func encode(_ response: ResponseBodyType) -> EventLoopFuture<Response> {
            let encodedResponseFuture = response.encodeResponse(for: request)
            
            return encodedResponseFuture.map { encodedResponse in
                self.modifiers.reduce(into: encodedResponse) { resp, mod in mod(&resp) }
            }
        }
        
        public func encode(_ response: ResponseBodyType) async throws -> Response {
            let encodedResponse = try await response.encodeResponse(for: request)
            let reducedResponse = self.modifiers.reduce(into: encodedResponse) { resp, mod in mod(&resp) }
            return reducedResponse
        }
        
        init(request: Request, modifiers: [@Sendable (inout Response) -> Void]) {
            self.request = request
            self.modifiers = modifiers
        }
    }
}
