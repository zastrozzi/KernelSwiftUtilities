//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation.Validator where T: _Optional {
    public static var `nil`: KernelValidation.Validator<T> {
        .init { KernelValidation.ValidatorResults.Nil(isNil: $0.wrapped == nil) }
    }
}

extension KernelValidation.ValidatorResults {
    public struct Nil {
        public let isNil: Bool
    }
}

extension KernelValidation.ValidatorResults.Nil: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        !self.isNil
    }
    
    public var successDescription: String? {
        switch self.isNil {
        case true:
            return "is not null"
        case false:
            return "is null"
        }
    }
    
    public var failureDescription: String? {
        switch self.isNil {
        case true:
            return "is null"
        case false:
            return "is not null"
        }
    }
}
