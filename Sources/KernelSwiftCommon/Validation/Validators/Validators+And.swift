//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

public func && <T: Decodable>(lhs: KernelValidation.Validator<T>, rhs: KernelValidation.Validator<T>) -> KernelValidation.Validator<T> {
    .init {
        KernelValidation.ValidatorResults.And(left: lhs.validate($0), right: rhs.validate($0))
    }
}

extension KernelValidation.ValidatorResults {
    public struct And {
        public let left: ValidatorResult
        public let right: ValidatorResult
    }
}

extension KernelValidation.ValidatorResults.And: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        self.left.isFailure || self.right.isFailure
    }
    
    public var successDescription: String? {
        switch (self.left.isFailure, self.right.isFailure) {
        case (false, false):
            return self.left.successDescription.flatMap { left in
                self.right.successDescription.map { right in
                    "\(left) and \(right)"
                }
            }
        default:
            return nil
        }
    }
    
    public var failureDescription: String? {
        switch (self.left.isFailure, self.right.isFailure) {
        case (true, true):
            return self.left.failureDescription.flatMap { left in
                self.right.failureDescription.map { right in
                    "\(left) and \(right)"
                }
            }
        case (true, false):
            return self.left.failureDescription
        case (false, true):
            return self.right.failureDescription
        default:
            return nil
        }
    }
}
