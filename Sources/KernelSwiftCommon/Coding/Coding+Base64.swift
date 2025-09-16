//
//  File.swift
//
//
//  Created by Jonathan Forbes on 06/09/2023.
//

import Foundation

extension KernelSwiftCommon.Coding {
    public enum Base64 {}
}

extension KernelSwiftCommon.Coding.Base64 {
    public enum Encoding {
        case `default`
        case url
    }
}

extension KernelSwiftCommon.Coding.Base64 {
    
    nonisolated(unsafe) private static var Base64EncodingTable: [UInt8: UInt8] = [
        0x00: .ascii.A,       0x01: .ascii.B,       0x02: .ascii.C,       0x03: .ascii.D,
        0x04: .ascii.E,       0x05: .ascii.F,       0x06: .ascii.G,       0x07: .ascii.H,
        0x08: .ascii.I,       0x09: .ascii.J,       0x0a: .ascii.K,       0x0b: .ascii.L,
        0x0c: .ascii.M,       0x0d: .ascii.N,       0x0e: .ascii.O,       0x0f: .ascii.P,
        0x10: .ascii.Q,       0x11: .ascii.R,       0x12: .ascii.S,       0x13: .ascii.T,
        0x14: .ascii.U,       0x15: .ascii.V,       0x16: .ascii.W,       0x17: .ascii.X,
        0x18: .ascii.Y,       0x19: .ascii.Z,       0x1a: .ascii.a,       0x1b: .ascii.b,
        0x1c: .ascii.c,       0x1d: .ascii.d,       0x1e: .ascii.e,       0x1f: .ascii.f,
        0x20: .ascii.g,       0x21: .ascii.h,       0x22: .ascii.i,       0x23: .ascii.j,
        0x24: .ascii.k,       0x25: .ascii.l,       0x26: .ascii.m,       0x27: .ascii.n,
        0x28: .ascii.o,       0x29: .ascii.p,       0x2a: .ascii.q,       0x2b: .ascii.r,
        0x2c: .ascii.s,       0x2d: .ascii.t,       0x2e: .ascii.u,       0x2f: .ascii.v,
        0x30: .ascii.w,       0x31: .ascii.x,       0x32: .ascii.y,       0x33: .ascii.z,
        0x34: .ascii.zero,    0x35: .ascii.one,     0x36: .ascii.two,     0x37: .ascii.three,
        0x38: .ascii.four,    0x39: .ascii.five,    0x3a: .ascii.six,     0x3b: .ascii.seven,
        0x3c: .ascii.eight,   0x3d: .ascii.nine,    0x3e: .ascii.plus,    0x3f: .ascii.forwardSlash
    ]
    
    nonisolated(unsafe) private static var Base64URLEncodingTable: [UInt8: UInt8] = [
        0x00: .ascii.A,       0x01: .ascii.B,       0x02: .ascii.C,       0x03: .ascii.D,
        0x04: .ascii.E,       0x05: .ascii.F,       0x06: .ascii.G,       0x07: .ascii.H,
        0x08: .ascii.I,       0x09: .ascii.J,       0x0a: .ascii.K,       0x0b: .ascii.L,
        0x0c: .ascii.M,       0x0d: .ascii.N,       0x0e: .ascii.O,       0x0f: .ascii.P,
        0x10: .ascii.Q,       0x11: .ascii.R,       0x12: .ascii.S,       0x13: .ascii.T,
        0x14: .ascii.U,       0x15: .ascii.V,       0x16: .ascii.W,       0x17: .ascii.X,
        0x18: .ascii.Y,       0x19: .ascii.Z,       0x1a: .ascii.a,       0x1b: .ascii.b,
        0x1c: .ascii.c,       0x1d: .ascii.d,       0x1e: .ascii.e,       0x1f: .ascii.f,
        0x20: .ascii.g,       0x21: .ascii.h,       0x22: .ascii.i,       0x23: .ascii.j,
        0x24: .ascii.k,       0x25: .ascii.l,       0x26: .ascii.m,       0x27: .ascii.n,
        0x28: .ascii.o,       0x29: .ascii.p,       0x2a: .ascii.q,       0x2b: .ascii.r,
        0x2c: .ascii.s,       0x2d: .ascii.t,       0x2e: .ascii.u,       0x2f: .ascii.v,
        0x30: .ascii.w,       0x31: .ascii.x,       0x32: .ascii.y,       0x33: .ascii.z,
        0x34: .ascii.zero,    0x35: .ascii.one,     0x36: .ascii.two,     0x37: .ascii.three,
        0x38: .ascii.four,    0x39: .ascii.five,    0x3a: .ascii.six,     0x3b: .ascii.seven,
        0x3c: .ascii.eight,   0x3d: .ascii.nine,    0x3e: .ascii.hyphen,  0x3f: .ascii.underscore
    ]
    
    nonisolated(unsafe) static let encodeTable: (UInt8, Encoding) -> UInt8 = { byte, type in
        return (type == .default ? Base64EncodingTable : Base64URLEncodingTable)[byte] ?? .max
    }
    
    private static let Base64DecodingTable: [UInt8: UInt8] = [
        .ascii.A: 0x00,       .ascii.B: 0x01,       .ascii.C: 0x02,       .ascii.D: 0x03,
        .ascii.E: 0x04,       .ascii.F: 0x05,       .ascii.G: 0x06,       .ascii.H: 0x07,
        .ascii.I: 0x08,       .ascii.J: 0x09,       .ascii.K: 0x0a,       .ascii.L: 0x0b,
        .ascii.M: 0x0c,       .ascii.N: 0x0d,       .ascii.O: 0x0e,       .ascii.P: 0x0f,
        .ascii.Q: 0x10,       .ascii.R: 0x11,       .ascii.S: 0x12,       .ascii.T: 0x13,
        .ascii.U: 0x14,       .ascii.V: 0x15,       .ascii.W: 0x16,       .ascii.X: 0x17,
        .ascii.Y: 0x18,       .ascii.Z: 0x19,       .ascii.a: 0x1a,       .ascii.b: 0x1b,
        .ascii.c: 0x1c,       .ascii.d: 0x1d,       .ascii.e: 0x1e,       .ascii.f: 0x1f,
        .ascii.g: 0x20,       .ascii.h: 0x21,       .ascii.i: 0x22,       .ascii.j: 0x23,
        .ascii.k: 0x24,       .ascii.l: 0x25,       .ascii.m: 0x26,       .ascii.n: 0x27,
        .ascii.o: 0x28,       .ascii.p: 0x29,       .ascii.q: 0x2a,       .ascii.r: 0x2b,
        .ascii.s: 0x2c,       .ascii.t: 0x2d,       .ascii.u: 0x2e,       .ascii.v: 0x2f,
        .ascii.w: 0x30,       .ascii.x: 0x31,       .ascii.y: 0x32,       .ascii.z: 0x33,
        .ascii.zero: 0x34,    .ascii.one: 0x35,     .ascii.two: 0x36,     .ascii.three: 0x37,
        .ascii.four: 0x38,    .ascii.five: 0x39,    .ascii.six: 0x3a,     .ascii.seven: 0x3b,
        .ascii.eight: 0x3c,   .ascii.nine: 0x3d,    .ascii.plus: 0x3e,    .ascii.forwardSlash: 0x3f
    ]
    
    private static let Base64URLDecodingTable: [UInt8: UInt8] = [
        .ascii.A: 0x00,       .ascii.B: 0x01,       .ascii.C: 0x02,       .ascii.D: 0x03,
        .ascii.E: 0x04,       .ascii.F: 0x05,       .ascii.G: 0x06,       .ascii.H: 0x07,
        .ascii.I: 0x08,       .ascii.J: 0x09,       .ascii.K: 0x0a,       .ascii.L: 0x0b,
        .ascii.M: 0x0c,       .ascii.N: 0x0d,       .ascii.O: 0x0e,       .ascii.P: 0x0f,
        .ascii.Q: 0x10,       .ascii.R: 0x11,       .ascii.S: 0x12,       .ascii.T: 0x13,
        .ascii.U: 0x14,       .ascii.V: 0x15,       .ascii.W: 0x16,       .ascii.X: 0x17,
        .ascii.Y: 0x18,       .ascii.Z: 0x19,       .ascii.a: 0x1a,       .ascii.b: 0x1b,
        .ascii.c: 0x1c,       .ascii.d: 0x1d,       .ascii.e: 0x1e,       .ascii.f: 0x1f,
        .ascii.g: 0x20,       .ascii.h: 0x21,       .ascii.i: 0x22,       .ascii.j: 0x23,
        .ascii.k: 0x24,       .ascii.l: 0x25,       .ascii.m: 0x26,       .ascii.n: 0x27,
        .ascii.o: 0x28,       .ascii.p: 0x29,       .ascii.q: 0x2a,       .ascii.r: 0x2b,
        .ascii.s: 0x2c,       .ascii.t: 0x2d,       .ascii.u: 0x2e,       .ascii.v: 0x2f,
        .ascii.w: 0x30,       .ascii.x: 0x31,       .ascii.y: 0x32,       .ascii.z: 0x33,
        .ascii.zero: 0x34,    .ascii.one: 0x35,     .ascii.two: 0x36,     .ascii.three: 0x37,
        .ascii.four: 0x38,    .ascii.five: 0x39,    .ascii.six: 0x3a,     .ascii.seven: 0x3b,
        .ascii.eight: 0x3c,   .ascii.nine: 0x3d,    .ascii.hyphen: 0x3e,  .ascii.underscore: 0x3f
    ]
    
    nonisolated(unsafe) static let decodeTable: (UInt8, Encoding) -> UInt8 = { byte, type in
        return (type == .default ? Base64DecodingTable : Base64URLDecodingTable)[byte] ?? .max
    }
    
    public static func encode(_ bytes: [UInt8], type: Encoding = .default, padded: Bool = false) -> [UInt8] {
        if bytes.count == 0 { return [] }
        
        let len = bytes.count
        var offset: Int = 0
        var c1: UInt8
        var c2: UInt8
        var result: [UInt8] = []
        
        while offset < len {
            c1 = bytes[offset] & 0xff
            offset += 1
            result.append(encodeTable((c1 >> 2) & 0x3f, type))
            c1 = (c1 & 0x03) << 4
            if offset >= len {
                result.append(encodeTable(c1 & 0x3f, type))
                break
            }
            
            c2 = bytes[offset] & 0xff
            offset += 1
            c1 |= (c2 >> 4) & 0x0f
            result.append(encodeTable(c1 & 0x3f, type))
            c1 = (c2 & 0x0f) << 2
            if offset >= len {
                result.append(encodeTable(c1 & 0x3f, type))
                break
            }
            
            c2 = bytes[offset] & 0xff
            offset += 1
            c1 |= (c2 >> 6) & 0x03
            result.append(encodeTable(c1 & 0x3f, type))
            result.append(encodeTable(c2 & 0x3f, type))
        }
        if padded {
            switch result.count % 3 {
            case 0: break
            case 1:
                result.append(.ascii.equals)
                result.append(.ascii.equals)
            case 2:
                result.append(.ascii.equals)
            default: preconditionFailure("encountered irregular length encoding. aborting to prevent hidden data capture")
            }
        }
        
        return result
    }
    
    public static func decode(_ bytes: [UInt8], type: Encoding = .default) -> [UInt8] {
        
        let maxolen = bytes.count
        
        var off: Int = 0
        var olen: Int = 0
        var result: [UInt8] = .zeroes(maxolen)
        
        var c1: UInt8
        var c2: UInt8
        var c3: UInt8
        var c4: UInt8
        var o: UInt8
        
        while off < bytes.count - 1 && olen < maxolen {
            c1 = decodeTable(bytes[off], type)
            off += 1
            c2 = decodeTable(bytes[off], type)
            off += 1
            if c1 == .max || c2 == .max { break }
            
            o = c1 << 2
            o |= (c2 & 0x30) >> 4
            result[olen] = o
            olen += 1
            if olen >= maxolen || off >= bytes.count { break }
            
            c3 = decodeTable(bytes[off], type)
            off += 1
            if c3 == .max { break }
            
            o = (c2 & 0x0f) << 4
            o |= (c3 & 0x3c) >> 2
            result[olen] = o
            olen += 1
            if olen >= maxolen || off >= bytes.count {
                break
            }
            
            c4 = decodeTable(bytes[off], type)
            off += 1
            if c4 == .max {
                break
            }
            o = (c3 & 0x03) << 6
            o |= c4
            result[olen] = o
            olen += 1
        }
        
        return [UInt8](result[0..<olen])
    }
}
