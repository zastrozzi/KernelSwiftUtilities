//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation {
    public struct ValidatorResults {
        public struct Nested {
            public let results: [ValidatorResult]
        }
        
        public struct NestedEach {
            public let results: [[ValidatorResult]]
        }
        
        public struct Skipped {}
        public struct Missing {}
        public struct NotFound {}
        
        public struct Codable {
            public let error: Error
        }
        
        public struct Invalid {
            public let reason: String
        }
        
        public struct TypeMismatch {
            public let type: Any.Type
        }
    }
}

extension KernelValidation.ValidatorResults {
    public typealias ValidatorResult = KernelValidation.ValidatorResult
}

extension KernelValidation.ValidatorResults.Nested: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        !self.results.filter { $0.isFailure }.isEmpty
    }
    
    public var successDescription: String? {
        self.results.filter { !$0.isFailure }
            .compactMap { $0.successDescription }
            .joined(separator: " and ")
    }
    
    public var failureDescription: String? {
        self.results.filter { $0.isFailure }
            .compactMap { $0.failureDescription }
            .joined(separator: " and ")
    }
}

extension KernelValidation.ValidatorResults.NestedEach: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        !self.results.flatMap { $0 }
            .filter { $0.isFailure }.isEmpty
    }
    
    public var successDescription: String? {
        self.results.enumerated().compactMap { (index, results) -> String? in
            let successes = results.filter { !$0.isFailure }
            guard !successes.isEmpty else {
                return nil
            }
            let description = successes.compactMap { $0.successDescription }
                .joined(separator: " and ")
            return "at index \(index) \(description)"
        }.joined(separator: " and ")
    }
    
    public var failureDescription: String? {
        self.results.enumerated().compactMap { (index, results) -> String? in
            let failures = results.filter { $0.isFailure }
            guard !failures.isEmpty else {
                return nil
            }
            let description = failures.compactMap { $0.failureDescription }
                .joined(separator: " and ")
            return "at index \(index) \(description)"
        }.joined(separator: " and ")
    }
}

extension KernelValidation.ValidatorResults.Skipped: KernelValidation.ValidatorResult {
    public var isFailure: Bool { false }
    public var successDescription: String? { nil }
    public var failureDescription: String? { nil }
}

extension KernelValidation.ValidatorResults.Missing: KernelValidation.ValidatorResult {
    public var isFailure: Bool { true }
    public var successDescription: String? { nil }
    public var failureDescription: String? { "is required" }
}

extension KernelValidation.ValidatorResults.Invalid: KernelValidation.ValidatorResult {
    public var isFailure: Bool { true }
    public var successDescription: String? { nil }
    public var failureDescription: String? { "is invalid: \(self.reason)" }
}

extension KernelValidation.ValidatorResults.NotFound: KernelValidation.ValidatorResult {
    public var isFailure: Bool { true }
    public var successDescription: String? { nil }
    public var failureDescription: String? { "cannot be null" }
}


extension KernelValidation.ValidatorResults.TypeMismatch: KernelValidation.ValidatorResult {
    public var isFailure: Bool { true }
    public var successDescription: String? { nil }
    public var failureDescription: String? { "is not a(n) \(self.type)" }
}

extension KernelValidation.ValidatorResults.Codable: KernelValidation.ValidatorResult {
    public var isFailure: Bool { true }
    public var successDescription: String? { nil }
    public var failureDescription: String? { "failed to decode: \(error)" }
}
