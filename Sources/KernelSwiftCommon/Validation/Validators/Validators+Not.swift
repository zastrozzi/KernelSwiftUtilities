//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

public prefix func ! <T>(
    validator: KernelValidation.Validator<T>
) -> KernelValidation.Validator<T> {
    .init {
        KernelValidation.ValidatorResults.Not(result: validator.validate($0))
    }
}

extension KernelValidation.ValidatorResults {
    public struct Not {
        public let result: KernelValidation.ValidatorResult
    }
}

extension KernelValidation.ValidatorResults.Not: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        !self.result.isFailure
    }
    
    public var successDescription: String? {
        self.result.failureDescription
    }
    
    public var failureDescription: String? {
        return self.result.successDescription
    }
}
