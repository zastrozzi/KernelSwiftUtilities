//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation.Validator {
    public static var valid: KernelValidation.Validator<T> {
        .init { _ in
            KernelValidation.ValidatorResults.Valid()
        }
    }
}

extension KernelValidation.ValidatorResults {
    public struct Valid {
        public let isValid: Bool = true
    }
}

extension KernelValidation.ValidatorResults.Valid: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        !self.isValid
    }
    
    public var successDescription: String? {
        "is valid"
    }
    
    public var failureDescription: String? {
        "is not valid"
    }
}
