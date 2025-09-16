//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation {
    public struct ValidationsResult: Sendable {
        public let results: [ValidationResult]
        
        public var error: TypedError? {
            let failures = results.filter { $0.result.isFailure }
            return if !failures.isEmpty { .validationFailed(failures: failures) }
            else { nil }
        }
        
        public func assert() throws {
            if let error = error { throw error }
        }
    }
}
