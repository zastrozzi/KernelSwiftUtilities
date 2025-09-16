//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation {
    public struct ValidationResult: Sendable {
        public let key: ValidationKey
        public let result: ValidatorResult
        public let customFailureDescription: String?
        
        init(key: ValidationKey, result: ValidatorResult, customFailureDescription: String? = nil) {
            self.key = key
            self.result = result
            self.customFailureDescription = customFailureDescription
        }
    }
}


extension KernelValidation.ValidationResult: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        self.result.isFailure
    }
    
    public var successDescription: String? {
        self.result.successDescription
            .map { "\(self.key) \($0)" }
    }
    
    public var failureDescription: String? {
        self.result.failureDescription
            .map { "\(self.key) \($0)" }
    }
}
