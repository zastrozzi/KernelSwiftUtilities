//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 25/03/2025.
//

extension KernelValidation {
    public struct Validator<T: Decodable & Sendable>: Sendable {
        public let validate: @Sendable (_ data: T) -> ValidatorResult
        @preconcurrency public init(validate: @Sendable @escaping (_ data: T) -> ValidatorResult) {
            self.validate = validate
        }
    }
}
