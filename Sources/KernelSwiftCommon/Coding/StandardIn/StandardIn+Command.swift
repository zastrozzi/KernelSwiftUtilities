//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/11/2023.
//

import Foundation

extension UInt8.StandardIn {
    public enum Command: RawRepresentable, CaseIterable, Hashable, Equatable, Sendable {
        public typealias RawValue = UInt8.StandardIn
        
        case arrowKey(ArrowKey)
        case optionModified(OptionSequence)
        case functionKey(FunctionKey)
        case returnKey
        
        public init?(rawValue: UInt8.StandardIn) {
            if rawValue.isArrowKey() { self = .arrowKey(.init(rawValue: rawValue)); return }
            else if rawValue.isFnKey() { self = .functionKey(.init(rawValue: rawValue)); return }
            else if rawValue.isOptKey() { self = .optionModified(.init(rawValue: rawValue)); return }
            else if rawValue.isReturnKey() { self = .returnKey }
            else { return nil }
        }
        
        public var rawValue: UInt8.StandardIn {
            switch self {
            case let .arrowKey(arrowKey): arrowKey.rawValue
            case let .optionModified(optionModified): optionModified.rawValue
            case let .functionKey(functionKey): functionKey.rawValue
            case .returnKey: .oneByte(.ascii.lineFeed)
            }
        }
        
        public static let allCases: [UInt8.StandardIn.Command] = {
            ArrowKey.allCases.map { .arrowKey($0) } +
            OptionSequence.allCases.map { .optionModified($0) } +
            FunctionKey.allCases.map { .functionKey($0) } +
            [.returnKey]
        }()
        
        public func isReturnKey() -> Bool { if case .returnKey = self { true } else { false } }
        
        public func asArrowKey() -> ArrowKey? { if case let .arrowKey(arrowKey) = self { arrowKey } else { nil } }
        public func asOptionMod() -> OptionSequence? { if case let .optionModified(optionModified) = self { optionModified } else { nil } }
        public func asFunctionKey() -> FunctionKey? { if case let .functionKey(functionKey) = self { functionKey } else { nil } }
    }
}
