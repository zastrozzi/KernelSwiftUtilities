//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation.Validator where T: Comparable & Strideable {
    public static func range(_ range: Swift.Range<T>) -> KernelValidation.Validator<T> {
        .range(min: range.lowerBound, max: range.upperBound.advanced(by: -1))
    }
}

extension KernelValidation.Validator where T: Comparable {
    public static func range(_ range: ClosedRange<T>) -> KernelValidation.Validator<T> {
        .range(min: range.lowerBound, max: range.upperBound)
    }
    
    public static func range(_ range: PartialRangeThrough<T>) -> KernelValidation.Validator<T> {
        .range(min: nil, max: range.upperBound)
    }
    
    public static func range(_ range: PartialRangeFrom<T>) -> KernelValidation.Validator<T> {
        .range(min: range.lowerBound, max: nil)
    }
    
    static func range(min: T?, max: T?) -> KernelValidation.Validator<T> {
        .range(min: min, max: max, \.self)
    }
}

extension KernelValidation.Validator where T: Comparable & SignedInteger {
    public static func range(_ range: PartialRangeUpTo<T>) -> KernelValidation.Validator<T> {
        .range(min: nil, max: range.upperBound.advanced(by: -1))
    }
}

extension KernelValidation.Validator {
    static func range<U>(
        min: U?, max: U?, _ keyPath: KeyPath<T, U> & Sendable,
        _ suffix: String? = nil
    ) -> KernelValidation.Validator<T>
    where U: Comparable & Sendable
    {
        return .init { data in
            if let result = try? KernelValidation.RangeResult.init(min: min, max: max, value: data[keyPath: keyPath]) {
                return KernelValidation.ValidatorResults.Range(
                    result: result,
                    suffix: suffix
                )
            }
            return KernelValidation.ValidatorResults.Invalid(reason: "Value in Range is not comparable")
        }
    }
}

extension KernelValidation {
    @usableFromInline
    final class UnsafeMutableTransferBox<Wrapped> {
        @usableFromInline
        var wrappedValue: Wrapped
        
        @inlinable
        init(_ wrappedValue: Wrapped) {
            self.wrappedValue = wrappedValue
        }
    }
}

extension KernelValidation.UnsafeMutableTransferBox: @unchecked Sendable {}

extension KernelValidation.ValidatorResults {
    public struct Range<T> where T: Comparable & Sendable {
        public let result: KernelValidation.RangeResult<T>
        internal let suffix: String?
    }
}

extension KernelValidation.ValidatorResults.Range: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        !self.result.isWithinRange
    }
    
    public var successDescription: String? {
        self.description
    }
    
    public var failureDescription: String? {
        self.description
    }
    
    private var description: String {
        if let suffix = self.suffix {
            return "is \(self.result.description) \(suffix)(s)"
        } else {
            return "is \(self.result.description)"
        }
    }
}
