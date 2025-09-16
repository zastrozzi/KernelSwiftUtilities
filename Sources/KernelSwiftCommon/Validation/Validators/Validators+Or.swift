//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

public func ||<T> (
    lhs: KernelValidation.Validator<T>,
    rhs: KernelValidation.Validator<T>
) -> KernelValidation.Validator<T> {
    .init {
        KernelValidation.ValidatorResults.Or(left: lhs.validate($0), right: rhs.validate($0))
    }
}

extension KernelValidation.ValidatorResults {
    public struct Or {
        public let left: KernelValidation.ValidatorResult
        public let right: KernelValidation.ValidatorResult
    }
}

extension KernelValidation.ValidatorResults.Or: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        self.left.isFailure && self.right.isFailure
    }
    
    public var successDescription: String? {
        switch (self.left.isFailure, self.right.isFailure) {
        case (false, false):
            return self.left.successDescription.flatMap { left in
                self.right.successDescription.map { right in
                    "\(left) and \(right)"
                }
            }
        case (true, false):
            return self.right.successDescription
        case (false, true):
            return self.left.successDescription
        default:
            return nil
        }
    }
    
    public var failureDescription: String? {
        switch (left.isFailure, right.isFailure) {
        case (true, true):
            return left.failureDescription.flatMap { left in
                right.failureDescription.map { right in
                    "\(left) and \(right)"
                }
            }
        default:
            return nil
        }
    }
}
