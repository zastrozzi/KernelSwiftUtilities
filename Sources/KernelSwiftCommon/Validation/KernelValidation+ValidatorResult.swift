//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 25/03/2025.
//

public protocol _KernelValidation_ValidatorResult: Sendable {
    var isFailure: Bool { get }
    var successDescription: String? { get }
    var failureDescription: String? { get }
}

extension KernelValidation {
    public typealias ValidatorResult = _KernelValidation_ValidatorResult
}
