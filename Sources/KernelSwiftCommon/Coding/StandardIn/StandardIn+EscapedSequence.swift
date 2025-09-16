//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/11/2023.
//

import Foundation

extension UInt8.StandardIn {
    public enum EscapedSequence: CaseIterable, Hashable, Equatable, Sendable {
        indirect case std_in(UInt8.StandardIn)
        
        public static let fn1: UInt8.StandardIn           = .escaped(.twoByte(.init(.ascii.O, .ascii.P)))
        public static let fn2: UInt8.StandardIn           = .escaped(.twoByte(.init(.ascii.O, .ascii.Q)))
        public static let fn3: UInt8.StandardIn           = .escaped(.twoByte(.init(.ascii.O, .ascii.R)))
        public static let fn4: UInt8.StandardIn           = .escaped(.twoByte(.init(.ascii.O, .ascii.S)))
        public static let fn5: UInt8.StandardIn           = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.one, .ascii.five, .ascii.tilde)))
        public static let fn6: UInt8.StandardIn           = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.one, .ascii.seven, .ascii.tilde)))
        public static let fn7: UInt8.StandardIn           = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.one, .ascii.eight, .ascii.tilde)))
        public static let fn8: UInt8.StandardIn           = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.one, .ascii.nine, .ascii.tilde)))
        public static let fn9: UInt8.StandardIn           = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.two, .ascii.zero, .ascii.tilde)))
        public static let fn10: UInt8.StandardIn          = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.two, .ascii.one, .ascii.tilde)))
        public static let fn11: UInt8.StandardIn          = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.two, .ascii.three, .ascii.tilde)))
        public static let fn12: UInt8.StandardIn          = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.two, .ascii.four, .ascii.tilde)))
        public static let fn13: UInt8.StandardIn          = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.two, .ascii.five, .ascii.tilde)))
        public static let fn14: UInt8.StandardIn          = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.two, .ascii.six, .ascii.tilde)))
        public static let fn15: UInt8.StandardIn          = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.two, .ascii.eight, .ascii.tilde)))
        public static let fn16: UInt8.StandardIn          = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.two, .ascii.nine, .ascii.tilde)))
        public static let fn17: UInt8.StandardIn          = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.three, .ascii.one, .ascii.tilde)))
        public static let fn18: UInt8.StandardIn          = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.three, .ascii.two, .ascii.tilde)))
        public static let fn19: UInt8.StandardIn          = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.three, .ascii.three, .ascii.tilde)))
        public static let fn20: UInt8.StandardIn          = .escaped(.fourByte(.init(.ascii.leftBracket, .ascii.three, .ascii.four, .ascii.tilde)))
        public static let arrowUp: UInt8.StandardIn       = .escaped(.twoByte(.init(.ascii.leftBracket, .ascii.A)))
        public static let arrowDown: UInt8.StandardIn     = .escaped(.twoByte(.init(.ascii.leftBracket, .ascii.B)))
        public static let arrowRight: UInt8.StandardIn    = .escaped(.twoByte(.init(.ascii.leftBracket, .ascii.C)))
        public static let arrowLeft: UInt8.StandardIn     = .escaped(.twoByte(.init(.ascii.leftBracket, .ascii.D)))
        
        public func hash(into hasher: inout Hasher) {
            if case let .std_in(val) = self { hasher.combine(val) }
        }
        
        var underlying: UInt8.StandardIn {
            guard case let .std_in(standardIn) = self else { preconditionFailure("Bad Escaped Sequence") }
            return standardIn
        }
        
        public static let allArrowKeysStdIn: [UInt8.StandardIn] = [
            arrowUp, arrowDown, arrowRight, arrowLeft
        ]
        
        public static let allFnKeysStdIn: [UInt8.StandardIn] = [
            fn1,    fn2,    fn3,    fn4,    fn5,    fn6,    fn7,    fn8,    fn9,    fn10,
            fn11,   fn12,   fn13,   fn14,   fn15,   fn16,   fn17,   fn18,   fn19,   fn20
        ]
        
        public static var allCasesStdIn: [UInt8.StandardIn] { allArrowKeysStdIn + allFnKeysStdIn }
        
        public static let allArrowKeys: [Self] = allArrowKeysStdIn.map { .std_in($0) }
        public static let allFnKeys: [Self] = allFnKeysStdIn.map { .std_in($0) }
        public static var allCases: [Self] { allArrowKeys + allFnKeys }
        
        public static func ==(lhs: Self, rhs: UInt8.StandardIn) -> Bool { lhs.underlying == rhs }
        public static func ==(lhs: UInt8.StandardIn, rhs: Self) -> Bool { lhs == rhs.underlying }
        public static func ==(lhs: Self, rhs: Self) -> Bool { lhs.underlying == rhs.underlying }
    }
}
