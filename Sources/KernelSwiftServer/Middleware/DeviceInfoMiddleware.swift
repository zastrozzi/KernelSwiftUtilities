//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/05/2024.
//

import Foundation
import Fluent
import Vapor

public final class DeviceInfoMiddleware: AsyncMiddleware {
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
//        guard let applicationId = request.headers.platformApplicationId else {
//            throw Abort(.badRequest, reason: "Missing Platform Application Header")
//        }
        
//        let activePlatformApplication = try await request.application.platformApplicationService.getPlatformApplicationDetails(applicationId: applicationId)
//        request.activePlatformApplicationId = activePlatformApplication.id
        return try await next.respond(to: request)
    }
}
