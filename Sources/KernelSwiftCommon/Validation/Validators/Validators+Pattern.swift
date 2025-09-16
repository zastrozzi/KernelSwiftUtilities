//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation.Validator where T == String {
    public static func pattern(_ pattern: String) -> KernelValidation.Validator<T> {
        .init {
            guard
                let range = $0.range(of: pattern, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                return KernelValidation.ValidatorResults.Pattern(isValidPattern: false, pattern: pattern)
            }
            return KernelValidation.ValidatorResults.Pattern(isValidPattern: true, pattern: pattern)
        }
    }
}

extension KernelValidation.ValidatorResults {
    public struct Pattern {
        public let isValidPattern: Bool
        public let pattern: String
    }
}

extension KernelValidation.ValidatorResults.Pattern: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        !self.isValidPattern
    }
    
    public var successDescription: String? {
        "is a valid pattern"
    }
    
    public var failureDescription: String? {
        "is not a valid pattern \(self.pattern)"
    }
}
