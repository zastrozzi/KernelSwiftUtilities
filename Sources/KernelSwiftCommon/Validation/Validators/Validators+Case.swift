//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation.Validator {
    public static func `case`<E>(of enum: E.Type) -> KernelValidation.Validator<T>
    where E: RawRepresentable & CaseIterable & Sendable, E.RawValue == T, T: CustomStringConvertible
    {
        .init {
            KernelValidation.ValidatorResults.Case(enumType: E.self, rawValue: $0)
        }
    }
    
}

extension KernelValidation.ValidatorResults {
    public struct Case<T, E>
    where E: RawRepresentable & CaseIterable & Sendable, E.RawValue == T, T: CustomStringConvertible & Sendable
    {
        public let enumType: E.Type
        public let rawValue: T
    }
}

extension KernelValidation.ValidatorResults.Case: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        return enumType.init(rawValue: rawValue) == nil
    }
    
    public var successDescription: String? {
        makeDescription(not: false)
    }
    
    public var failureDescription: String? {
        makeDescription(not: true)
    }
    
    func makeDescription(not: Bool) -> String {
        let items = E.allCases.map { "\($0.rawValue)" }
        let description: String
        switch items.count {
        case 1:
            description = items[0].description
        case 2:
            description = "\(items[0].description) or \(items[1].description)"
        default:
            let first = items[0..<(items.count - 1)]
                .map { $0.description }.joined(separator: ", ")
            let last = items[items.count - 1].description
            description = "\(first), or \(last)"
        }
        return "is\(not ? " not" : "") \(description)"
    }
}
