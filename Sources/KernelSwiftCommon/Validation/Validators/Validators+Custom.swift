//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation.Validator where T: Decodable & Sendable {
    public static func custom(
        _ validationDescription: String,
        validationClosure: @Sendable @escaping (T) -> Bool
    ) -> KernelValidation.Validator<T> {
        return .init {
            let result = validationClosure($0)
            
            return KernelValidation.ValidatorResults.Custom(
                isSuccess: result,
                validationDescription: validationDescription
            )
        }
    }
}

extension KernelValidation.ValidatorResults {
    public struct Custom {
        public let isSuccess: Bool
        public let validationDescription: String
    }
}

extension KernelValidation.ValidatorResults.Custom: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        !self.isSuccess
    }
    
    public var successDescription: String? {
        "is successfully validated for custom validation '\(validationDescription)'."
    }
    
    public var failureDescription: String? {
        "is not successfully validated for custom validation '\(validationDescription)'."
    }
}
