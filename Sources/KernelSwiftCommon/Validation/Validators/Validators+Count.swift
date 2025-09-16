//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation.Validator where T: Collection {
    public static func count(_ range: ClosedRange<Int>) -> KernelValidation.Validator<T> {
        .count(min: range.lowerBound, max: range.upperBound)
    }
    
    public static func count(_ range: PartialRangeThrough<Int>) -> KernelValidation.Validator<T> {
        .count(min: nil, max: range.upperBound)
    }
    
    public static func count(_ range: PartialRangeUpTo<Int>) -> KernelValidation.Validator<T> {
        .count(min: nil, max: range.upperBound.advanced(by: -1))
    }
    
    public static func count(_ range: PartialRangeFrom<Int>) -> KernelValidation.Validator<T> {
        .count(min: range.lowerBound, max: nil)
    }
    
    public static func count(_ range: Swift.Range<Int>) -> KernelValidation.Validator<T> {
        .count(min: range.lowerBound, max: range.upperBound.advanced(by: -1))
    }
    
    static func count(min: Int?, max: Int?) -> KernelValidation.Validator<T> {
        let suffix: String
        if T.self is String.Type {
            suffix = "character"
        } else {
            suffix = "item"
        }
        return .range(min: min, max: max, \.count, suffix)
    }
}
