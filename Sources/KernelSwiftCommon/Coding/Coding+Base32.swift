//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/05/2023.
//

import Foundation

extension KernelSwiftCommon.Coding {
    public enum Base32 {}
}

extension KernelSwiftCommon.Coding.Base32 {
    nonisolated(unsafe) private static var Base32ByteEncodingTable: [UInt8: UInt8] = [
        0x0:    .ascii.A,     0x1:  .ascii.B,     0x2:  .ascii.C,     0x3:  .ascii.D,
        0x4:    .ascii.E,     0x5:  .ascii.F,     0x6:  .ascii.G,     0x7:  .ascii.H,
        0x8:    .ascii.I,     0x9:  .ascii.J,     0xa:  .ascii.K,     0xb:  .ascii.L,
        0xc:    .ascii.M,     0xd:  .ascii.N,     0xe:  .ascii.O,     0xf:  .ascii.P,
        
        0x00:   .ascii.A,     0x01: .ascii.B,     0x02: .ascii.C,     0x03: .ascii.D,
        0x04:   .ascii.E,     0x05: .ascii.F,     0x06: .ascii.G,     0x07: .ascii.H,
        0x08:   .ascii.I,     0x09: .ascii.J,     0x0a: .ascii.K,     0x0b: .ascii.L,
        0x0c:   .ascii.M,     0x0d: .ascii.N,     0x0e: .ascii.O,     0x0f: .ascii.P,
        
        0x10:   .ascii.Q,     0x11: .ascii.R,     0x12: .ascii.S,     0x13: .ascii.T,
        0x14:   .ascii.U,     0x15: .ascii.V,     0x16: .ascii.W,     0x17: .ascii.X,
        0x18:   .ascii.Y,     0x19: .ascii.Z,     0x1a: .ascii.two,   0x1b: .ascii.three,
        0x1c:   .ascii.four,  0x1d: .ascii.five,  0x1e: .ascii.six,   0x1f: .ascii.seven
    ]
    
    nonisolated(unsafe) private static var Base32ByteDecodingTable: [UInt8: UInt8] = [
        .ascii.A: 0x00,     .ascii.B: 0x01,     .ascii.C: 0x02,     .ascii.D: 0x03,
        .ascii.E: 0x04,     .ascii.F: 0x05,     .ascii.G: 0x06,     .ascii.H: 0x07,
        .ascii.I: 0x08,     .ascii.J: 0x09,     .ascii.K: 0x0a,     .ascii.L: 0x0b,
        .ascii.M: 0x0c,     .ascii.N: 0x0d,     .ascii.O: 0x0e,     .ascii.P: 0x0f,
        
            .ascii.Q: 0x10,     .ascii.R: 0x11,     .ascii.S: 0x12,     .ascii.T: 0x13,
        .ascii.U: 0x14,     .ascii.V: 0x15,     .ascii.W: 0x16,     .ascii.X: 0x17,
        .ascii.Y: 0x18,     .ascii.Z: 0x19,     .ascii.two: 0x1a,   .ascii.three: 0x1b,
        .ascii.four: 0x1c,  .ascii.five: 0x1d,  .ascii.six: 0x1e,   .ascii.seven: 0x1f
    ]
    
    nonisolated(unsafe) private static let encodeTableLookup: (UInt8) -> UInt8 = { Base32ByteEncodingTable[$0] ?? .max }
    nonisolated(unsafe) private static let decodeTableLookup: (UInt8) -> UInt8 = { Base32ByteDecodingTable[$0] ?? .max }
    nonisolated(unsafe) private static let encodeTableContains: (UInt8) -> Bool = { Base32ByteEncodingTable[$0] != nil }
    nonisolated(unsafe) private static let decodeTableContains: (UInt8) -> Bool = { Base32ByteDecodingTable[$0] != nil }
    
    public static func encodeBase32(_ bytes: [UInt8]) -> [UInt8] {
        var result: [UInt8] = []
        let start = bytes.startIndex
        let end = bytes.endIndex
        
        for idx in stride(from: start, to: end, by: 5) {
            let offset = (idx + 5 >= end) ? end : idx + 5
            var count = offset - idx
            var raw: [UInt8] = .zeroes(5)
            var encoded: [UInt8] = .fill(8, with: .ascii.equals)
            
            while count > 0 {
                switch count {
                case 5:
                    raw[4] = bytes[idx + 4]
                    encoded[7] = encodeTableLookup(raw[4] & 0x1F)
                case 4:
                    raw[3] = bytes[idx + 3]
                    let b1 = (raw[3] << 3) & 0x18
                    let b2 = (raw[4] >> 5) & 0x07
                    let b3 = (raw[3] >> 2) & 0x1F
                    encoded[6] = encodeTableLookup(b1 | b2)
                    encoded[5] = encodeTableLookup(b3)
                case 3:
                    raw[2] = bytes[idx + 2]
                    let b1 = (raw[2] << 1) & 0x1E
                    let b2 = (raw[3] >> 7) & 0x01
                    encoded[4] = encodeTableLookup(b1 | b2)
                case 2:
                    raw[1] = bytes[idx + 1]
                    let b1 = (raw[1] >> 1) & 0x1F
                    let b2 = (raw[1] << 4) & 0x10
                    let b3 = (raw[2] >> 4) & 0x0F
                    encoded[2] = encodeTableLookup(b1)
                    encoded[3] = encodeTableLookup(b2 | b3)
                case 1:
                    raw[0] = bytes[idx + 0]
                    let b1 = (raw[0] >> 3) & 0x1F
                    let b2 = (raw[0] << 2) & 0x1C
                    let b3 = (raw[1] >> 6) & 0x03
                    encoded[0] = encodeTableLookup(b1)
                    encoded[1] = encodeTableLookup(b2 | b3)
                default: break
                }
                count -= 1
            }
            result += encoded
        }
        
        return result
    }
    
    public enum Base32DecodingError: Error {
        case oddLength
        case invalid(UInt8)
    }
    
    public static func decodeBase32(_ bytes: [UInt8]) throws -> [UInt8] {
        guard bytes.count % 2 == 0 else { throw Base32DecodingError.oddLength }
        var buff: [UInt8] = []
        for byte in UInt8.ascii.uppercased(bytes) {
            if decodeTableContains(byte) { buff.append(byte) }
            else if byte != .ascii.equals { throw Base32DecodingError.invalid(byte) }
        }
        
        var result: [UInt8] = []
        
        let start = buff.startIndex
        let end = buff.endIndex
        
        for idx in stride(from: start, to: end, by: 8) {
            let offset = (idx + 8 >= end) ? end : idx + 8
            var count = offset - idx
            var decoded: [UInt8] = .zeroes(8)
            
            while count > 0 {
                switch count {
                case 8: decoded[7] = decodeTableLookup(buff[idx + 7])
                case 7: decoded[6] = decodeTableLookup(buff[idx + 6])
                case 6: decoded[5] = decodeTableLookup(buff[idx + 5])
                case 5: decoded[4] = decodeTableLookup(buff[idx + 4])
                case 4: decoded[3] = decodeTableLookup(buff[idx + 3])
                case 3: decoded[2] = decodeTableLookup(buff[idx + 2])
                case 2: decoded[1] = decodeTableLookup(buff[idx + 1])
                case 1: decoded[0] = decodeTableLookup(buff[idx + 0])
                default: break
                }
                count -= 1
            }
            
            let b01 = (decoded[0] << 3) & 0xF8
            let b02 = (decoded[1] >> 2) & 0x07
            result.append(b01 | b02)
            let b11 = (decoded[1] << 6) & 0xC0
            let b12 = (decoded[2] << 1) & 0x3E
            let b13 = (decoded[3] >> 4) & 0x01
            result.append(b11 | b12 | b13)
            let b21 = (decoded[3] << 4) & 0xF0
            let b22 = (decoded[4] >> 1) & 0x0F
            result.append(b21 | b22)
            let b31 = (decoded[4] << 7) & 0x80
            let b32 = (decoded[5] << 2) & 0x7C
            let b33 = (decoded[6] >> 3) & 0x03
            result.append(b31 | b32 | b33)
            let b41 = (decoded[6] << 5) & 0xE0
            let b42 = (decoded[7])      & 0x1F
            result.append(b41 | b42)
        }
        
        while result.last == 0x00 { result.removeLast() }
        return result
    }
}
