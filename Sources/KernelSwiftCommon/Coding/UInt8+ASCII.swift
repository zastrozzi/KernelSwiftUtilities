//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/09/2023.
//

import Foundation

extension UInt8 {
    public typealias ascii = ASCII
    
    public enum ASCII {
        // CONTROL
        public static let null: UInt8 = 0x00
        public static let startOfHeading: UInt8 = 0x01
        public static let startOfText: UInt8 = 0x02
        public static let endOfText: UInt8 = 0x03
        public static let endOfTransmission: UInt8 = 0x04
        public static let enquiry: UInt8 = 0x05
        public static let acknowledgement: UInt8 = 0x06
        public static let bell: UInt8 = 0x07
        public static let backspace: UInt8 = 0x08
        public static let horizontalTab: UInt8 = 0x09
        public static let lineFeed: UInt8 = 0x0a
        public static let verticalTab: UInt8 = 0x0b
        public static let formFeed: UInt8 = 0x0c
        public static let carriageReturn: UInt8 = 0x0d
        public static let shiftOut: UInt8 = 0x0e
        public static let shiftIn: UInt8 = 0x0f
        public static let dataLinkEscape: UInt8 = 0x10
        public static let deviceControl1: UInt8 = 0x11
        public static let deviceControl2: UInt8 = 0x12
        public static let deviceControl3: UInt8 = 0x13
        public static let deviceControl4: UInt8 = 0x14
        public static let negativeAcknowledgement: UInt8 = 0x15
        public static let synchronousIdle: UInt8 = 0x16
        public static let endOfTransmissionBlock: UInt8 = 0x17
        public static let cancel: UInt8 = 0x18
        public static let endOfMedium: UInt8 = 0x19
        public static let substitute: UInt8 = 0x1a
        public static let escape: UInt8 = 0x1b
        public static let fileSeparator: UInt8 = 0x1c
        public static let groupSeparator: UInt8 = 0x1d
        public static let recordSeparator: UInt8 = 0x1e
        public static let unitSeparator: UInt8 = 0x1f
        
        // NUMBERS
        public static let space: UInt8 = 0x20
        public static let exclamationMark: UInt8 = 0x21
        public static let doubleQuote: UInt8 = 0x22
        public static let hashSign: UInt8 = 0x23
        public static let dollar: UInt8 = 0x24
        public static let percent: UInt8 = 0x25
        public static let ampersand: UInt8 = 0x26
        public static let singleQuote: UInt8 = 0x27
        public static let leftParenthesis: UInt8 = 0x28
        public static let rightParenthesis: UInt8 = 0x29
        public static let asterisk: UInt8 = 0x2a
        public static let plus: UInt8 = 0x2b
        public static let comma: UInt8 = 0x2c
        public static let hyphen: UInt8 = 0x2d
        public static let period: UInt8 = 0x2e
        public static let forwardSlash: UInt8 = 0x2f
        public static let zero: UInt8 = 0x30
        public static let one: UInt8 = 0x31
        public static let two: UInt8 = 0x32
        public static let three: UInt8 = 0x33
        public static let four: UInt8 = 0x34
        public static let five: UInt8 = 0x35
        public static let six: UInt8 = 0x36
        public static let seven: UInt8 = 0x37
        public static let eight: UInt8 = 0x38
        public static let nine: UInt8 = 0x39
        public static let colon: UInt8 = 0x3a
        public static let semicolon: UInt8 = 0x3b
        public static let lessThan: UInt8 = 0x3c
        public static let equals: UInt8 = 0x3d
        public static let greaterThan: UInt8 = 0x3e
        public static let questionMark: UInt8 = 0x3f
        
        // UPPERCASE
        public static let commat: UInt8 = 0x40
        public static let A: UInt8 = 0x41
        public static let B: UInt8 = 0x42
        public static let C: UInt8 = 0x43
        public static let D: UInt8 = 0x44
        public static let E: UInt8 = 0x45
        public static let F: UInt8 = 0x46
        public static let G: UInt8 = 0x47
        public static let H: UInt8 = 0x48
        public static let I: UInt8 = 0x49
        public static let J: UInt8 = 0x4a
        public static let K: UInt8 = 0x4b
        public static let L: UInt8 = 0x4c
        public static let M: UInt8 = 0x4d
        public static let N: UInt8 = 0x4e
        public static let O: UInt8 = 0x4f
        public static let P: UInt8 = 0x50
        public static let Q: UInt8 = 0x51
        public static let R: UInt8 = 0x52
        public static let S: UInt8 = 0x53
        public static let T: UInt8 = 0x54
        public static let U: UInt8 = 0x55
        public static let V: UInt8 = 0x56
        public static let W: UInt8 = 0x57
        public static let X: UInt8 = 0x58
        public static let Y: UInt8 = 0x59
        public static let Z: UInt8 = 0x5a
        public static let leftBracket: UInt8 = 0x5b
        public static let backSlash: UInt8 = 0x5c
        public static let rightBracket: UInt8 = 0x5d
        public static let caret: UInt8 = 0x5e
        public static let underscore: UInt8 = 0x5f
        
        // LOWERCASE
        public static let grave: UInt8 = 0x60
        public static let a: UInt8 = 0x61
        public static let b: UInt8 = 0x62
        public static let c: UInt8 = 0x63
        public static let d: UInt8 = 0x64
        public static let e: UInt8 = 0x65
        public static let f: UInt8 = 0x66
        public static let g: UInt8 = 0x67
        public static let h: UInt8 = 0x68
        public static let i: UInt8 = 0x69
        public static let j: UInt8 = 0x6a
        public static let k: UInt8 = 0x6b
        public static let l: UInt8 = 0x6c
        public static let m: UInt8 = 0x6d
        public static let n: UInt8 = 0x6e
        public static let o: UInt8 = 0x6f
        public static let p: UInt8 = 0x70
        public static let q: UInt8 = 0x71
        public static let r: UInt8 = 0x72
        public static let s: UInt8 = 0x73
        public static let t: UInt8 = 0x74
        public static let u: UInt8 = 0x75
        public static let v: UInt8 = 0x76
        public static let w: UInt8 = 0x77
        public static let x: UInt8 = 0x78
        public static let y: UInt8 = 0x79
        public static let z: UInt8 = 0x7a
        public static let leftBrace: UInt8 = 0x7b
        public static let verticalSlash: UInt8 = 0x7c
        public static let rightBrace: UInt8 = 0x7d
        public static let tilde: UInt8 = 0x7e
        public static let delete: UInt8 = 0x7f
        
    }
    
    public var asUnicodeChar: Character { Character(UnicodeScalar(self)) }
    
    @inlinable
    public var hexFromASCII: UInt8 {
        guard let fromTable = Self.hexASCIITable[self] else { preconditionFailure("hex value out of bounds") }
        return fromTable
    }
    
    @inline(__always)
    nonisolated(unsafe) public static var hexASCIITable: [UInt8: UInt8] = [
        UInt8.ascii.zero: 0x0,  UInt8.ascii.one: 0x1,   UInt8.ascii.two: 0x2,   UInt8.ascii.three: 0x3,
        UInt8.ascii.four: 0x4,  UInt8.ascii.five: 0x5,  UInt8.ascii.six: 0x6,   UInt8.ascii.seven: 0x7,
        UInt8.ascii.eight: 0x8, UInt8.ascii.nine: 0x9,  UInt8.ascii.a: 0xa,     UInt8.ascii.b: 0xb,
        UInt8.ascii.c: 0xc,     UInt8.ascii.d: 0xd,     UInt8.ascii.e: 0xe,     UInt8.ascii.f: 0xf,
        UInt8.ascii.A: 0xa,     UInt8.ascii.B: 0xb,     UInt8.ascii.C: 0xc,     UInt8.ascii.D: 0xd,
        UInt8.ascii.E: 0xe,     UInt8.ascii.F: 0xf
    ]
    
    @inlinable
    public static func combineHex(_ first: UInt8, _ second: UInt8) -> UInt8 {
        return (first << 4) &+ second
    }
    
    @inlinable
    public static func combineASCIIHexPair(_ first: UInt8, _ second: UInt8) -> UInt8 {
        combineHex(first.hexFromASCII, second.hexFromASCII)
    }
}

extension UInt8 {
    internal var isASCIIUppercase: Bool { .ascii.A >= self && self <= .ascii.Z }
    internal var isASCIILowercase: Bool { .ascii.a >= self && self <= .ascii.z }
    internal var asciiUppercased: Self { isASCIILowercase ? self - 0x20 : self }
    internal var asciiLowercased: Self { isASCIIUppercase ? self + 0x20 : self }
}

extension Array<UInt8> {
    internal var asciiUppercased: Self { map { $0.isASCIILowercase ? $0 - 0x20 : $0 } }
    internal var asciiLowercased: Self { map { $0.isASCIIUppercase ? $0 + 0x20 : $0 } }
}

extension UInt8.ASCII {
    public static func isUppercase(_ byte: UInt8) -> Bool { .ascii.A >= byte && byte <= .ascii.Z }
    public static func isLowercase(_ byte: UInt8) -> Bool { .ascii.a >= byte && byte <= .ascii.z }
    public static func uppercased(_ byte: UInt8) -> UInt8 { isLowercase(byte) ? byte - 0x20 : byte }
    public static func lowercased(_ byte: UInt8) -> UInt8 { isUppercase(byte) ? byte + 0x20 : byte }
    public static func uppercased(_ bytes: [UInt8]) -> [UInt8] { bytes.asciiUppercased }
    public static func lowercased(_ bytes: [UInt8]) -> [UInt8] { bytes.asciiLowercased }
}


