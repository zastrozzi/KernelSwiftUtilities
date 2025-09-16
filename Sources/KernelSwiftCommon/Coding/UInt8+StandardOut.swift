//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/11/2023.
//

import Foundation

extension UInt8 {
    public typealias standardOutPrefixByte = StandardOut.PrefixByte
    public typealias standardOutTwoByte = StandardOut.TwoByte
    public typealias standardOutThreeByte = StandardOut.ThreeByte
    public typealias standardOutFourByte = StandardOut.FourByte
    public typealias standardOutFiveByte = StandardOut.FiveByte
    
    public enum StandardOut: CustomDebugStringConvertible, Equatable, Sendable {
        case oneByte(_ grapheme: UInt8)
        case twoByte(_ grapheme: StandardOut.TwoByte)
        case threeByte(_ grapheme: StandardOut.ThreeByte)
        case fourByte(_ grapheme: StandardOut.FourByte)
        case fiveByte(_ grapheme: StandardOut.FiveByte)
        indirect case escaped(_ seq: StandardOut)
        
        
        public init?(bytes: [UInt8]) {
            let base: Self? = switch bytes.count {
            case 1: .oneByte(bytes[0])
            case 2: .twoByte(.init(bytes[0], bytes[1]))
            case 3: .threeByte(.init(bytes[0], bytes[1], bytes[2]))
            case 4: .fourByte(.init(bytes[0], bytes[1], bytes[2], bytes[3]))
            case 5: .fiveByte(.init(bytes[0], bytes[1], bytes[2], bytes[3], bytes[4]))
            default: nil
            }
            guard let base else { return nil }
            if bytes[0] == .ascii.escape && bytes.count > 1 { self = .escaped(base) }
            else { self = base }
        }
        
        public var debugDescription: String {
            switch self {
            case let .oneByte(b): "STD_OUT: " + [b].toHexString()
            case let .twoByte(b): "STD_OUT: " + b.bytes.toHexString()
            case let .threeByte(b): "STD_OUT: " + b.bytes.toHexString()
            case let .fourByte(b): "STD_OUT: " + b.bytes.toHexString()
            case let .fiveByte(b): "STD_OUT: " + b.bytes.toHexString()
            case let .escaped(seq): "ESC|" + seq.debugDescription
            }
        }
        
        public struct TwoByte: Codable, Equatable, Sendable {
            public init(_ prefix: UInt8, _ suffix: UInt8) {
                self.prefix = prefix
                self.suffix = suffix
            }
            
            public let prefix: UInt8
            public let suffix: UInt8
            
            public var bytes: [UInt8] { [prefix, suffix] }
        }
        
        public struct ThreeByte: Codable, Equatable, Sendable {
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
            
            public var bytes: [UInt8] { [prefix, continuation, suffix] }
        }
        
        public struct FourByte: Codable, Equatable, Sendable {
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
            
            public var bytes: [UInt8] { [prefix, continuation1, continuation2, suffix] }
        }
        
        public struct FiveByte: Codable, Equatable, Sendable {
            public init(
                _ prefix: UInt8,
                _ continuation1: UInt8,
                _ continuation2: UInt8,
                _ continuation3: UInt8,
                _ suffix: UInt8
            ) {
                self.prefix = prefix
                self.continuation1 = continuation1
                self.continuation2 = continuation2
                self.continuation3 = continuation3
                self.suffix = suffix
            }
            
            public let prefix: UInt8
            public let continuation1: UInt8
            public let continuation2: UInt8
            public let continuation3: UInt8
            public let suffix: UInt8
            
            public var bytes: [UInt8] { [prefix, continuation1, continuation2, continuation3, suffix] }
        }
        
        public enum PrefixByte: UInt8, Equatable, ExpressibleByIntegerLiteral {
            public typealias IntegerLiteralType = UInt8
            
            public init(integerLiteral value: UInt8) {
                self = .init(rawValue: value) ?? .null
            }
            
            public static func == (lhs: Self, rhs: UInt8) -> Bool {
                return lhs.rawValue == rhs
            }
            
            public static func == (lhs: UInt8, rhs: Self) -> Bool {
                return lhs == rhs.rawValue
            }
            
            public static func != (lhs: Self, rhs: UInt8) -> Bool {
                return lhs.rawValue != rhs
            }
            
            public static func != (lhs: UInt8, rhs: Self) -> Bool {
                return lhs != rhs.rawValue
            }
            
            public static func isEscapedContinuation(_ byte: UInt8) -> Bool { (0x31...0x39).contains(byte) }
            public static func isTwoBytePrefix(_ byte: UInt8) -> Bool { (0xc0...0xdf).contains(byte) }
            public static func isThreeBytePrefix(_ byte: UInt8) -> Bool { (0xe0...0xef).contains(byte) }
            public static func isFourBytePrefix(_ byte: UInt8) -> Bool { (0xf0...0xff).contains(byte) }
            
            case null = 0x00
            
            case escaped = 0x1b
            
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
            
            // MARK: - Four Byte Prefixes
            case f0 = 0xf0
            case f1 = 0xf1
            case f2 = 0xf2
            case f3 = 0xf3
            case f4 = 0xf4
            case f5 = 0xf5
            case f6 = 0xf6
            case f7 = 0xf7
            case f8 = 0xf8
            case f9 = 0xf9
            case fa = 0xfa
            case fb = 0xfb
            case fc = 0xfc
            case fd = 0xfd
            case fe = 0xfe
            case ff = 0xff
        }
    }
}
