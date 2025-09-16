//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import Vapor

public struct ResponseStatusMetricsServiceStorageKey: StorageKey {
    public typealias Value = ResponseStatusMetricsService
}

extension Application {
    public var responseStatusMetricsService: ResponseStatusMetricsService {
        get {
            guard let _responseStatusMetricsService = self.storage[ResponseStatusMetricsServiceStorageKey.self] else {
                fatalError("ResponseStatusMetricsServiceStorageKey not initialised")
            }
            return _responseStatusMetricsService
        }
        
        set {
            self.storage[ResponseStatusMetricsServiceStorageKey.self] = newValue
        }
    }
    
    public func registerResponseStatusMetricsService(
        loggingPath: [PathComponent] = [.constant("logs"), .constant("1.0"), .constant("response-status")]
    ) {
        responseStatusMetricsService = .init(logger: self.logger, loggingPath: loggingPath)
        middleware.use(responseStatusMetricsService)
        @Sendable
        func loggingHandler(_ req: Request) async throws -> Response {
            await req.application.responseStatusMetricsService.logMetrics()
            return .init(status: .ok, body: .init(string: "See logs for response metrics"))
        }
        developmentSecretProtectedRoutes().get(loggingPath, use: loggingHandler)
            .tags("[Logging]").summary("Log Response Status Metrics")
    }
}

public struct ResponseStatusMetrics: Content {
    public var allResponses: [HTTPResponseStatus: Int]
    public var emptyResponses: [HTTPResponseStatus: Int]
    public var nonEmptyResponses: [HTTPResponseStatus: Int]
}

public actor ResponseStatusMetricsService: AsyncMiddleware {
    let logger: Logger
    let loggingPath: [PathComponent]
    
    public var allStatusMetrics: [HTTPResponseStatus: Int] = [:]
    public var emptyStatusMetrics: [HTTPResponseStatus: Int] = [:]
    public var nonEmptyStatusMetrics: [HTTPResponseStatus: Int] = [:]
    
    public init(logger: Logger, loggingPath: [PathComponent]) {
        self.logger = logger
        self.loggingPath = loggingPath
    }
    
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let response = try await next.respond(to: request)
        guard request.route?.path != self.loggingPath else { return response }
        allStatusMetrics[response.status, default: 0] += 1
        
        if
            let contentLengthStr = response.headers.first(name: .contentLength),
            let contentLength = Int(contentLengthStr),
            contentLength > 0,
            !(response.body.string == "" || response.body.string == "{}")
        {
            nonEmptyStatusMetrics[response.status, default: 0] += 1
        } else {
            emptyStatusMetrics[response.status, default: 0] += 1
        }
        
        return response
    }
    
    
    
    
    public func logMetrics() {
        self.logger.info("All Responses", metadata: ["metrics": .dictionary(.init(allStatusMetrics.map { ("\($0.code)", .stringConvertible($1)) }) {$1})])
        self.logger.info("Empty Responses", metadata: [
            "metrics": .dictionary(
                .init(emptyStatusMetrics.map {
                    ("\($0.code)", .stringConvertible($1))
                }) {$1})
        ])
        self.logger.info("Non-Empty Responses", metadata: ["metrics": .dictionary(.init(nonEmptyStatusMetrics.map { ("\($0.code)", .stringConvertible($1)) }) {$1})])
    }
}
