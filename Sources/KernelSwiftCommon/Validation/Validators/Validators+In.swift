//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation.Validator where T: Equatable & CustomStringConvertible {
    public static func `in`(_ array: T...) -> KernelValidation.Validator<T> {
        .in(array)
    }
    
    public static func `in`<S>(_ sequence: S) -> KernelValidation.Validator<T>
    where S: Sequence & Sendable, S.Element == T
    {
        .init {
            KernelValidation.ValidatorResults.In(item: $0, items: .init(sequence))
        }
    }
}

extension KernelValidation.ValidatorResults {
    public struct In<T> where T: Equatable & CustomStringConvertible & Sendable {
        public let item: T
        public let items: [T]
    }
    
}

extension KernelValidation.ValidatorResults.In: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        !self.items.contains(self.item)
    }
    
    public var successDescription: String? {
        self.makeDescription(not: false)
    }
    
    public var failureDescription: String? {
        self.makeDescription(not: true)
    }
    
    func makeDescription(not: Bool) -> String {
        let description: String
        switch self.items.count {
        case 1:
            description = self.items[0].description
        case 2:
            description = "\(self.items[0].description) or \(self.items[1].description)"
        default:
            let first = self.items[0..<(self.items.count - 1)]
                .map { $0.description }.joined(separator: ", ")
            let last = self.items[self.items.count - 1].description
            description = "\(first), or \(last)"
        }
        return "is\(not ? " not" : " ") \(description)"
    }
}
