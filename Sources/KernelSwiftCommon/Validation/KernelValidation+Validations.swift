//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation {
    public struct Validations: Sendable {
        var storage: [Validation]
        
        public init() {
            self.storage = []
        }
        
        public mutating func add<T>(
            _ key: ValidationKey,
            as type: T.Type = T.self,
            is validator: Validator<T> = .valid,
            required: Bool = true,
            customFailureDescription: String? = nil
        ) {
            self.storage.append(
                .init(
                    key: key,
                    required: required,
                    validator: validator,
                    customFailureDescription: customFailureDescription
                )
            )
        }
        
        public mutating func add(
            _ key: ValidationKey,
            result: ValidatorResult,
            customFailureDescription: String? = nil
        ) {
            self.storage.append(
                .init(
                    key: key,
                    result: result,
                    customFailureDescription: customFailureDescription
                )
            )
        }
        
        public mutating func add(
            _ key: ValidationKey,
            required: Bool = true,
            customFailureDescription: String? = nil,
            _ nested: (inout Validations) -> ()
        ) {
            var validations = Validations()
            nested(&validations)
            self.storage.append(
                .init(
                    nested: key,
                    required: required,
                    keyed: validations,
                    customFailureDescription: customFailureDescription
                )
            )
        }
        
        @preconcurrency public mutating func add(
            each key: ValidationKey,
            required: Bool = true,
            customFailureDescription: String? = nil,
            _ handler: @Sendable @escaping (Int, inout Validations) -> ()
        ) {
            self.storage.append(
                .init(
                    nested: key,
                    required: required,
                    unkeyed: handler,
                    customFailureDescription: customFailureDescription
                )
            )
        }
        
        public func validate(json: String) throws -> ValidationsResult {
            guard let jsonData = json.data(using: .utf8) else {
                throw TypedError(.validationFailed, reason: "Could not convert JSON string to Data")
            }
            let decoder = JSONDecoder()
            decoder.userInfo[.pendingValidations] = self
            return try decoder.decode(ValidationsExecutor.self, from: jsonData).results
        }
        
        public func validate(_ decoder: Decoder) throws -> ValidationsResult {
            let container = try decoder.container(keyedBy: ValidationKey.self)
            
            return try .init(results: self.storage.map {
                try .init(
                    key: $0.key,
                    result: {
                        switch (container.contains($0.key), $0.valuelessKeyBehavior) {
                        case (_, .ignore):          return $0.run(decoder)
                        case (false, .missing):     return ValidatorResults.Missing()
                        case (true, .skipAlways) where try container.decodeNil(forKey: $0.key),
                            (false, .skipWhenUnset),
                            (false, .skipAlways):  return ValidatorResults.Skipped()
                        case (true, _):             return try $0.run(container.superDecoder(forKey: $0.key))
                        }
                    }($0),
                    customFailureDescription: $0.customFailureDescription
                )
            })
        }
    }
}
            
extension CodingUserInfoKey {
    public static var pendingValidations: Self { .init(rawValue: "kernel.validation.pendingValidations")! }
}


extension KernelValidation {
    public struct ValidationsExecutor: Decodable {
        public let results: ValidationsResult
        
        public init(from decoder: Decoder) throws {
            guard let pendingValidations = decoder.userInfo[.pendingValidations] as? Validations else {
                throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: [],
                        debugDescription: "Validation executor couldn't find any validations to run (broken Decoder?)"
                    )
                )
            }
            try self.init(from: decoder, explicitValidations: pendingValidations)
        }
        
        public init(from decoder: Decoder, explicitValidations: Validations) throws {
            self.results = try explicitValidations.validate(decoder)
        }
    }
}
