//
//  File.swift
//
//
//  Created by Jonathan Forbes on 01/06/2022.
//

import Foundation
import Vapor
import Fluent

extension Optional where Wrapped: Model {
    public func unwrap(orAsync error: @autoclosure @escaping () -> Error) async throws -> Wrapped {
        guard let found = self.wrapped else { throw error() }
        return found
    }
}
