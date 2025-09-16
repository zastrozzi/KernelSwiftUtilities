//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension KernelValidation.Validations {
    public func validate(request: Request) throws -> KernelValidation.ValidationsResult {
        guard let contentType = request.headers.contentType else {
            throw Abort(.unprocessableEntity, reason: "Missing \"Content-Type\" header")
        }
        guard let body = request.body.data else {
            throw Abort(.unprocessableEntity, reason: "Empty Body")
        }
        let contentDecoder = try ContentConfiguration.global.requireDecoder(for: contentType)
        return try contentDecoder.decode(
            KernelValidation.ValidationsExecutor.self,
            from: body,
            headers: request.headers,
            userInfo: [.pendingValidations: self]
        ).results
    }

    public func validate(query: URI) throws -> KernelValidation.ValidationsResult {
        let urlDecoder = try ContentConfiguration.global.requireURLDecoder()
        return try urlDecoder.decode(
            KernelValidation.ValidationsExecutor.self,
            from: query,
            userInfo: [.pendingValidations: self]
        ).results
    }
}
