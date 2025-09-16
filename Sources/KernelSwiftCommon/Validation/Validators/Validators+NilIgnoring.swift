//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

public func ||<T> (
    lhs: KernelValidation.Validator<T?>,
    rhs: KernelValidation.Validator<T>
) -> KernelValidation.Validator<T?> {
    lhs || .init {
        KernelValidation.ValidatorResults.NilIgnoring(result: $0.flatMap(rhs.validate))
    }
}

public func ||<T> (
    lhs: KernelValidation.Validator<T>,
    rhs: KernelValidation.Validator<T?>
) -> KernelValidation.Validator<T?> {
    .init {
        KernelValidation.ValidatorResults.NilIgnoring(result: $0.flatMap(lhs.validate))
    } || rhs
}

public func &&<T> (
    lhs: KernelValidation.Validator<T?>,
    rhs: KernelValidation.Validator<T>
) -> KernelValidation.Validator<T?> {
    lhs && .init {
        KernelValidation.ValidatorResults.NilIgnoring(result: $0.flatMap(rhs.validate))
    }
}

public func &&<T> (
    lhs: KernelValidation.Validator<T>,
    rhs: KernelValidation.Validator<T?>
) -> KernelValidation.Validator<T?> {
    .init {
        KernelValidation.ValidatorResults.NilIgnoring(result: $0.flatMap(lhs.validate))
    } && rhs
}

extension KernelValidation.ValidatorResults {
    public struct NilIgnoring {
        public let result: KernelValidation.ValidatorResult?
    }
}

extension KernelValidation.ValidatorResults.NilIgnoring: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        result?.isFailure == true
    }
    
    public var successDescription: String? {
        self.result?.successDescription
    }
    
    public var failureDescription: String? {
        self.result?.failureDescription
    }
}
