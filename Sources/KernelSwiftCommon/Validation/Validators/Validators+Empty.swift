//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation.Validator where T: Collection {
    public static var empty: KernelValidation.Validator<T> {
        .init {
            KernelValidation.ValidatorResults.Empty(isEmpty: $0.isEmpty)
        }
    }
}

extension KernelValidation.ValidatorResults {
    public struct Empty {
        public let isEmpty: Bool
    }
}

extension KernelValidation.ValidatorResults.Empty: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        !self.isEmpty
    }
    
    public var successDescription: String? {
        "is empty"
    }
    
    public var failureDescription: String? {
        "is not empty"
    }
}
