//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/11/2023.
//

import Foundation

extension UInt8.StandardIn {
    public enum FunctionKey: RawRepresentable, CaseIterable, Sendable, CustomStringConvertible, Hashable, Equatable {
        public typealias RawValue = UInt8.StandardIn
        
        case fn1
        case fn2
        case fn3
        case fn4
        case fn5
        case fn6
        case fn7
        case fn8
        case fn9
        case fn10
        case fn11
        case fn12
        case fn13
        case fn14
        case fn15
        case fn16
        case fn17
        case fn18
        case fn19
        case fn20
        
        case none
        
        public init(rawValue: UInt8.StandardIn) {
            switch rawValue {
            case EscapedSequence.fn1  : self = .fn1
            case EscapedSequence.fn2  : self = .fn2
            case EscapedSequence.fn3  : self = .fn3
            case EscapedSequence.fn4  : self = .fn4
            case EscapedSequence.fn5  : self = .fn5
            case EscapedSequence.fn6  : self = .fn6
            case EscapedSequence.fn7  : self = .fn7
            case EscapedSequence.fn8  : self = .fn8
            case EscapedSequence.fn9  : self = .fn9
            case EscapedSequence.fn10 : self = .fn10
            case EscapedSequence.fn11 : self = .fn11
            case EscapedSequence.fn12 : self = .fn12
            case EscapedSequence.fn13 : self = .fn13
            case EscapedSequence.fn14 : self = .fn14
            case EscapedSequence.fn15 : self = .fn15
            case EscapedSequence.fn16 : self = .fn16
            case EscapedSequence.fn17 : self = .fn17
            case EscapedSequence.fn18 : self = .fn18
            case EscapedSequence.fn19 : self = .fn19
            case EscapedSequence.fn20 : self = .fn20
            default                   : self = .none
            }
        }
        
        public var rawValue: UInt8.StandardIn {
            switch self {
            case .fn1   : EscapedSequence.fn1
            case .fn2   : EscapedSequence.fn2
            case .fn3   : EscapedSequence.fn3
            case .fn4   : EscapedSequence.fn4
            case .fn5   : EscapedSequence.fn5
            case .fn6   : EscapedSequence.fn6
            case .fn7   : EscapedSequence.fn7
            case .fn8   : EscapedSequence.fn8
            case .fn9   : EscapedSequence.fn9
            case .fn10  : EscapedSequence.fn10
            case .fn11  : EscapedSequence.fn11
            case .fn12  : EscapedSequence.fn12
            case .fn13  : EscapedSequence.fn13
            case .fn14  : EscapedSequence.fn14
            case .fn15  : EscapedSequence.fn15
            case .fn16  : EscapedSequence.fn16
            case .fn17  : EscapedSequence.fn17
            case .fn18  : EscapedSequence.fn18
            case .fn19  : EscapedSequence.fn19
            case .fn20  : EscapedSequence.fn20
            case .none  : .oneByte(.ascii.null)
            }
        }
        
        public var description: String {
            switch self {
            case .fn1   : "FN1"
            case .fn2   : "FN2"
            case .fn3   : "FN3"
            case .fn4   : "FN4"
            case .fn5   : "FN5"
            case .fn6   : "FN6"
            case .fn7   : "FN7"
            case .fn8   : "FN8"
            case .fn9   : "FN9"
            case .fn10  : "FN10"
            case .fn11  : "FN11"
            case .fn12  : "FN12"
            case .fn13  : "FN13"
            case .fn14  : "FN14"
            case .fn15  : "FN15"
            case .fn16  : "FN16"
            case .fn17  : "FN17"
            case .fn18  : "FN18"
            case .fn19  : "FN19"
            case .fn20  : "FN20"
            case .none  : ""
            }
        }
    }
}
