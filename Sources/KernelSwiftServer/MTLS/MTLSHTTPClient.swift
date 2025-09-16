//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/10/2022.
//

import Foundation
import Vapor

public struct MTLSHTTPClient: Client {
    var http: HTTPClient
    public let eventLoop: EventLoop
    var logger: Logger?
    public var byteBufferAllocator: ByteBufferAllocator
    var configuration: HTTPClient.Configuration
    
    public init(application: Application, httpClientConfiguration: HTTPClient.Configuration) {
        self.http = HTTPClient(eventLoopGroupProvider: .shared(application.eventLoopGroup), configuration: httpClientConfiguration, backgroundActivityLogger: application.logger)
        self.configuration = httpClientConfiguration
        self.eventLoop = application.eventLoopGroup.next()
        self.logger = application.logger
        self.byteBufferAllocator = application.allocator
    }
    
    internal init(http: HTTPClient, configuration: HTTPClient.Configuration, eventLoop: EventLoop, logger: Logger? = nil, byteBufferAllocator: ByteBufferAllocator) {
        self.http = http
        self.configuration = configuration
        self.eventLoop = eventLoop
        self.logger = logger
        self.byteBufferAllocator = byteBufferAllocator
    }
    
    public func send(
        _ client: ClientRequest
    ) -> EventLoopFuture<ClientResponse> {
        let urlString = client.url.string
        guard let url = URL(string: urlString) else {
            self.logger?.debug("\(urlString) is an invalid URL")
            return self.eventLoop.makeFailedFuture(Abort(.internalServerError, reason: "\(urlString) is an invalid URL"))
        }
        do {
            let request = try HTTPClient.Request(
                url: url,
                method: client.method,
                headers: client.headers,
                body: client.body.map { .byteBuffer($0) }
            )
            return self.http.execute(
                request: request,
                eventLoop: .delegate(on: self.eventLoop)
            ).map { response in
                let client = ClientResponse(
                    status: response.status,
                    headers: response.headers,
                    body: response.body,
                    byteBufferAllocator: self.byteBufferAllocator
                )
                return client
            }
        } catch {
            return self.eventLoop.makeFailedFuture(error)
        }
    }
    
    public func delegating(to eventLoop: EventLoop) -> Client {
        MTLSHTTPClient(http: self.http, configuration: self.configuration, eventLoop: eventLoop, logger: self.logger, byteBufferAllocator: self.byteBufferAllocator)
    }

    public func logging(to logger: Logger) -> Client {
        MTLSHTTPClient(http: self.http, configuration: self.configuration, eventLoop: self.eventLoop, logger: logger, byteBufferAllocator: self.byteBufferAllocator)
    }

    public func allocating(to byteBufferAllocator: ByteBufferAllocator) -> Client {
        MTLSHTTPClient(http: self.http, configuration: self.configuration, eventLoop: self.eventLoop, logger: self.logger, byteBufferAllocator: byteBufferAllocator)
    }
}
