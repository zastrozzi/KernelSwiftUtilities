//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/05/2023.
//

import Foundation



extension UInt8 {
    public typealias utf8Prefix = UTF8UnicodePrefixByte
    public typealias utf8TwoByte = UTF8UnicodeTwoByteSequence
    public typealias utf8ThreeByte = UTF8UnicodeThreeByteSequence
    public typealias utf8FourByte = UTF8UnicodeFourByteSequence
    
    public enum UTF8Grapheme: Sendable {
        case oneByte(_ grapheme: UInt8)
        case twoByte(_ grapheme: UTF8UnicodeTwoByteSequence)
        case threeByte(_ grapheme: UTF8UnicodeThreeByteSequence)
        case fourByte(_ grapheme: UTF8UnicodeFourByteSequence)
        
        public var byteLength: Int {
            switch self {
            case .oneByte: return 1
            case .twoByte: return 2
            case .threeByte: return 3
            case .fourByte: return 4
            }
        }
    }
    
    public struct UTF8UnicodeTwoByteSequence: Codable, Equatable, Sendable {
        public init(_ prefix: UInt8, _ suffix: UInt8) {
            self.prefix = prefix
            self.suffix = suffix
        }
        
        public let prefix: UInt8
        public let suffix: UInt8
    }
    
    public struct UTF8UnicodeThreeByteSequence: Codable, Equatable, Sendable {
        public init(
            _ prefix: UInt8,
            _ continuation: UInt8,
            _ suffix: UInt8
        ) {
            self.prefix = prefix
            self.continuation = continuation
            self.suffix = suffix
        }
        
        public let prefix: UInt8
        public let continuation: UInt8
        public let suffix: UInt8
    }
    
    public struct UTF8UnicodeFourByteSequence: Codable, Equatable, Sendable {
        public init(
            _ prefix: UInt8,
            _ continuation1: UInt8,
            _ continuation2: UInt8,
            _ suffix: UInt8
        ) {
            self.prefix = prefix
            self.continuation1 = continuation1
            self.continuation2 = continuation2
            self.suffix = suffix
        }
        
        public let prefix: UInt8
        public let continuation1: UInt8
        public let continuation2: UInt8
        public let suffix: UInt8
    }
    
    public enum UTF8UnicodePrefixByte: UInt8, Equatable, ExpressibleByIntegerLiteral {
        public typealias IntegerLiteralType = UInt8
        
        public init(integerLiteral value: UInt8) {
            self = .init(rawValue: value) ?? .null
        }
        
        public static func == (lhs: UTF8UnicodePrefixByte, rhs: UInt8) -> Bool {
            return lhs.rawValue == rhs
        }
        
        public static func == (lhs: UInt8, rhs: UTF8UnicodePrefixByte) -> Bool {
            return lhs == rhs.rawValue
        }
        
        public static func != (lhs: UTF8UnicodePrefixByte, rhs: UInt8) -> Bool {
            return lhs.rawValue != rhs
        }
        
        public static func != (lhs: UInt8, rhs: UTF8UnicodePrefixByte) -> Bool {
            return lhs != rhs.rawValue
        }
        
        case null = 0x00
        
        // MARK: - Two Byte Prefixes
        case c0 = 0xc0
        case c1 = 0xc1
        case c2 = 0xc2
        case c3 = 0xc3
        case c4 = 0xc4
        case c5 = 0xc5
        case c6 = 0xc6
        case c7 = 0xc7
        case c8 = 0xc8
        case c9 = 0xc9
        case ca = 0xca
        case cb = 0xcb
        case cc = 0xcc
        case cd = 0xcd
        case ce = 0xce
        case cf = 0xcf
        case d0 = 0xd0
        case d1 = 0xd1
        case d2 = 0xd2
        case d3 = 0xd3
        case d4 = 0xd4
        case d5 = 0xd5
        case d6 = 0xd6
        case d7 = 0xd7
        case d8 = 0xd8
        case d9 = 0xd9
        case da = 0xda
        case db = 0xdb
        case dc = 0xdc
        case dd = 0xdd
        case de = 0xde
        case df = 0xdf
        
        // MARK: - Three Byte Prefixes
        case e0 = 0xe0
        case e1 = 0xe1
        case e2 = 0xe2
        case e3 = 0xe3
        case e4 = 0xe4
        case e5 = 0xe5
        case e6 = 0xe6
        case e7 = 0xe7
        case e8 = 0xe8
        case e9 = 0xe9
        case ea = 0xea
        case eb = 0xeb
        case ec = 0xec
        case ed = 0xed
        case ee = 0xee
        case ef = 0xef
    }
}

extension UInt8.utf8TwoByte {
    public static let carriageReturnLineFeed: Self = .init(.ascii.carriageReturn, .ascii.lineFeed)
    
    public static let euroSign: Self = .init(0xc2, 0x80)
    // empty
    public static let breakPermittedHere: Self = .init(0xc2, 0x82)
    public static let noBreakHere: Self = .init(0xc2, 0x83)
    public static let index: Self = .init(0xc2, 0x84)
    public static let nextLine: Self = .init(0xc2, 0x85)
}

extension UInt8.utf8ThreeByte {
    public static let lineSeparator: Self = .init(0xe2, 0x80, 0xa8)
    public static let paragraphSeparator: Self = .init(0xe2, 0x80, 0xa9)
}


extension UInt8 {
    public static func == (lhs: UTF8UnicodePrefixByte, rhs: UInt8) -> Bool {
        return lhs.rawValue == rhs
    }
    
    public static func == (lhs: UInt8, rhs: UTF8UnicodePrefixByte) -> Bool {
        return lhs == rhs.rawValue
    }
    
    public static func != (lhs: UTF8UnicodePrefixByte, rhs: UInt8) -> Bool {
        return lhs.rawValue != rhs
    }
    
    public static func != (lhs: UInt8, rhs: UTF8UnicodePrefixByte) -> Bool {
        return lhs != rhs.rawValue
    }
}
