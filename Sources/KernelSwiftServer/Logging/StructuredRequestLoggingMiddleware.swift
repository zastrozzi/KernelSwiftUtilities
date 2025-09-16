//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/09/2024.
//

import Vapor

public struct StructuredRequestLoggingMiddleware: AsyncMiddleware, Sendable {
    public let logLevel: Logger.Level
    
    public init(logLevel: Logger.Level = .info) {
        self.logLevel = logLevel
    }
    
    public func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        let startTime = ProcessInfo.processInfo.systemUptime
        let response = try await next.respond(to: request)
        let endTime = ProcessInfo.processInfo.systemUptime
        request.logger.log(
            level: self.logLevel,
            "\(request.method) \(request.url.path.removingPercentEncoding ?? request.url.path)",
            metadata: [
                "status": .string("\(response.status.code)"),
                "request-headers": .dictionary(
                    .init(
                        request.headers.map { key, value in
                            (key, .string(value))
                        }
                    ) { $1 }
                ),
                "duration": .string("\(endTime - startTime)s")
            ]
        )
        return response
    }
}
