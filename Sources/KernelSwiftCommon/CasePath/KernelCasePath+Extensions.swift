//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/08/2022.
//

import Foundation

extension KernelCasePath where Root == Value {
    public static var `self`: KernelCasePath {
        .init(embed: { $0 }, extract: Optional.some)
    }
}

extension KernelCasePath where Root == Void {
    public static func constant(_ value: Value) -> KernelCasePath {
        .init(embed: { _ in () }, extract: { .some(value) })
    }
}

extension KernelCasePath where Value == Never {
    public static var never: KernelCasePath {
        func absurd<A>(_ never: Never) -> A {}
        return .init(embed: absurd, extract: { _ in nil })
    }
}

extension KernelCasePath where Value: RawRepresentable, Root == Value.RawValue {
    public static var rawValue: KernelCasePath {
        .init(embed: { $0.rawValue }, extract: Value.init(rawValue:))
    }
}

extension KernelCasePath where Value: LosslessStringConvertible, Root == String {
    public static var description: KernelCasePath {
        .init(embed: { $0.description }, extract: Value.init)
    }
}
