//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/10/2022.
//

import Foundation
import Vapor
import Fluent

extension QueryBuilder {
    @discardableResult
    public func firstOrThrow(
        error: () -> Error
    ) async throws -> Model {
        guard let result = try await self.first() else {
            throw error()
        }
        return result
    }
}
