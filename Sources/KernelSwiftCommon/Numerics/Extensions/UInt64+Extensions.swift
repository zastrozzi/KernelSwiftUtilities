//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/02/2022.
//

import Foundation

extension UInt64 {
//    public var isBelowZero: Bool {
//        return self < 0
//    }
    
    public func population() -> Int {
        var x = self
        x = x & .mask.bit.bitCheck1 + (x >> 1) & .mask.bit.bitCheck1
        x = x & .mask.bit.bitCheck2 + (x >> 2) & .mask.bit.bitCheck2
        x = x & .mask.bit.bitCheck4 + (x >> 4) & .mask.bit.bitCheck4
        x += x >> 8
        x += x >> 16
        x += x >> 32
        return .init(x & 0x7f)
    }
    
//    public static let leadingBitMasks: [UInt64] = [
//        0x0000000000000001, 0x0000000000000002, 0x0000000000000004, 0x0000000000000008,
//        0x0000000000000010, 0x0000000000000020, 0x0000000000000040, 0x0000000000000080,
//        0x0000000000000100, 0x0000000000000200, 0x0000000000000400, 0x0000000000000800,
//        0x0000000000001000, 0x0000000000002000, 0x0000000000004000, 0x0000000000008000,
//        0x0000000000010000, 0x0000000000020000, 0x0000000000040000, 0x0000000000080000,
//        0x0000000000100000, 0x0000000000200000, 0x0000000000400000, 0x0000000000800000,
//        0x0000000001000000, 0x0000000002000000, 0x0000000004000000, 0x0000000008000000,
//        0x0000000010000000, 0x0000000020000000, 0x0000000040000000, 0x0000000080000000,
//        0x0000000100000000, 0x0000000200000000, 0x0000000400000000, 0x0000000800000000,
//        0x0000001000000000, 0x0000002000000000, 0x0000004000000000, 0x0000008000000000,
//        0x0000010000000000, 0x0000020000000000, 0x0000040000000000, 0x0000080000000000,
//        0x0000100000000000, 0x0000200000000000, 0x0000400000000000, 0x0000800000000000,
//        0x0001000000000000, 0x0002000000000000, 0x0004000000000000, 0x0008000000000000,
//        0x0010000000000000, 0x0020000000000000, 0x0040000000000000, 0x0080000000000000,
//        0x0100000000000000, 0x0200000000000000, 0x0400000000000000, 0x0800000000000000,
//        0x1000000000000000, 0x2000000000000000, 0x4000000000000000, 0x8000000000000000
//    ]
    
    public typealias val = Constants
    public typealias mask = Masks
    
    public enum Constants {
        
        public typealias big                = BigEndianConstants
        public typealias little             = LittleEndianConstants
        
        public enum BigEndianConstants {
            
        }
        
        public enum LittleEndianConstants {
            public typealias base10             = Base10Constants
            public typealias base16             = Base16Constants
            public typealias radix              = RadixConstants
            
            public enum Base10Constants {
                public static let zero          : UInt64 = 0x0000000000000000
                public static let one           : UInt64 = 0x0000000000000001
                public static let two           : UInt64 = 0x0000000000000002
                public static let three         : UInt64 = 0x0000000000000003
                public static let four          : UInt64 = 0x0000000000000004
                public static let five          : UInt64 = 0x0000000000000005
                public static let six           : UInt64 = 0x0000000000000006
                public static let seven         : UInt64 = 0x0000000000000007
                public static let eight         : UInt64 = 0x0000000000000008
                public static let nine          : UInt64 = 0x0000000000000009
                public static let ten           : UInt64 = 0x000000000000000a
            }
            
            public enum Base16Constants {
                public static let zero          : UInt64 = 0x0000000000000000
                public static let one           : UInt64 = 0x0000000000000001
                public static let two           : UInt64 = 0x0000000000000002
                public static let three         : UInt64 = 0x0000000000000003
                public static let four          : UInt64 = 0x0000000000000004
                public static let five          : UInt64 = 0x0000000000000005
                public static let six           : UInt64 = 0x0000000000000006
                public static let seven         : UInt64 = 0x0000000000000007
                public static let eight         : UInt64 = 0x0000000000000008
                public static let nine          : UInt64 = 0x0000000000000009
                public static let ae            : UInt64 = 0x000000000000000a
                public static let bee           : UInt64 = 0x000000000000000b
                public static let cee           : UInt64 = 0x000000000000000c
                public static let dee           : UInt64 = 0x000000000000000d
                public static let ee            : UInt64 = 0x000000000000000e
                public static let eff           : UInt64 = 0x000000000000000f
            }
            
            public enum RadixConstants {
                public static let r0            : UInt64 = 0x0000000000000000
                public static let r1            : UInt64 = 0x0000000000000000
                public static let r2            : UInt64 = 0x8000000000000000
                public static let r3            : UInt64 = 0xa8b8b452291fe821
                public static let r4            : UInt64 = 0x4000000000000000
                public static let r5            : UInt64 = 0x6765c793fa10079d
                public static let r6            : UInt64 = 0x41c21cb8e1000000
                public static let r7            : UInt64 = 0x3642798750226111
                public static let r8            : UInt64 = 0x8000000000000000
                public static let r9            : UInt64 = 0xa8b8b452291fe821
                public static let r10           : UInt64 = 0x8ac7230489e80000
                public static let r11           : UInt64 = 0x4d28cb56c33fa539
                public static let r12           : UInt64 = 0x1eca170c00000000
                public static let r13           : UInt64 = 0x780c7372621bd74d
                public static let r14           : UInt64 = 0x1e39a5057d810000
                public static let r15           : UInt64 = 0x5b27ac993df97701
                public static let r16           : UInt64 = 0x1000000000000000
                public static let r17           : UInt64 = 0x27b95e997e21d9f1
                public static let r18           : UInt64 = 0x5da0e1e53c5c8000
                public static let r19           : UInt64 = 0xd2ae3299c1c4aedb
                public static let r20           : UInt64 = 0x16bcc41e90000000
                public static let r21           : UInt64 = 0x2d04b7fdd9c0ef49
                public static let r22           : UInt64 = 0x5658597bcaa24000
                public static let r23           : UInt64 = 0xa0e2073737609371
                public static let r24           : UInt64 = 0x0c29e98000000000
                public static let r25           : UInt64 = 0x14adf4b7320334b9
                public static let r26           : UInt64 = 0x226ed36478bfa000
                public static let r27           : UInt64 = 0x383d9170b85ff80b
                public static let r28           : UInt64 = 0x5a3c23e39c000000
                public static let r29           : UInt64 = 0x8e65137388122bcd
                public static let r30           : UInt64 = 0xdd41bb36d259e000
                public static let r31           : UInt64 = 0x0aee5720ee830681
                public static let r32           : UInt64 = 0x1000000000000000
                public static let r33           : UInt64 = 0x172588ad4f5f0981
                public static let r34           : UInt64 = 0x211e44f7d02c1000
                public static let r35           : UInt64 = 0x2ee56725f06e5c71
                public static let r36           : UInt64 = 0x41c21cb8e1000000
                
                public static let d0            : Int = 0x0000000000000000
                public static let d1            : Int = 0x0000000000000000
                public static let d2            : Int = 0x000000000000003f
                public static let d3            : Int = 0x0000000000000028
                public static let d4            : Int = 0x000000000000001f
                public static let d5            : Int = 0x000000000000001b
                public static let d6            : Int = 0x0000000000000018
                public static let d7            : Int = 0x0000000000000016
                public static let d8            : Int = 0x0000000000000015
                public static let d9            : Int = 0x0000000000000014
                public static let d10           : Int = 0x0000000000000013
                public static let d11           : Int = 0x0000000000000012
                public static let d12           : Int = 0x0000000000000011
                public static let d13           : Int = 0x0000000000000011
                public static let d14           : Int = 0x0000000000000010
                public static let d15           : Int = 0x0000000000000010
                public static let d16           : Int = 0x000000000000000f
                public static let d17           : Int = 0x000000000000000f
                public static let d18           : Int = 0x000000000000000f
                public static let d19           : Int = 0x000000000000000f
                public static let d20           : Int = 0x000000000000000e
                public static let d21           : Int = 0x000000000000000e
                public static let d22           : Int = 0x000000000000000e
                public static let d23           : Int = 0x000000000000000e
                public static let d24           : Int = 0x000000000000000d
                public static let d25           : Int = 0x000000000000000d
                public static let d26           : Int = 0x000000000000000d
                public static let d27           : Int = 0x000000000000000d
                public static let d28           : Int = 0x000000000000000d
                public static let d29           : Int = 0x000000000000000d
                public static let d30           : Int = 0x000000000000000d
                public static let d31           : Int = 0x000000000000000c
                public static let d32           : Int = 0x000000000000000c
                public static let d33           : Int = 0x000000000000000c
                public static let d34           : Int = 0x000000000000000c
                public static let d35           : Int = 0x000000000000000c
                public static let d36           : Int = 0x000000000000000c
                
                public static let all: [UInt64] = [
                    r0,     r1,     r2,     r3,     r4,     r5,     r6,     r7,
                    r8,     r9,     r10,    r11,    r12,    r13,    r14,    r15,
                    r16,    r17,    r18,    r19,    r20,    r21,    r22,    r23,
                    r24,    r25,    r26,    r27,    r28,    r29,    r30,    r31,
                    r32,    r33,    r34,    r35,    r36
                ]
                
                public static let allDigits: [Int] = [
                    d0,     d1,     d2,     d3,     d4,     d5,     d6,     d7,
                    d8,     d9,     d10,    d11,    d12,    d13,    d14,    d15,
                    d16,    d17,    d18,    d19,    d20,    d21,    d22,    d23,
                    d24,    d25,    d26,    d27,    d28,    d29,    d30,    d31,
                    d32,    d33,    d34,    d35,    d36
                ]
            }
            
            public static let max1bit       : UInt64 = 0x0000000000000001
            public static let max2bit       : UInt64 = 0x0000000000000003
            public static let max3bit       : UInt64 = 0x0000000000000007
            public static let max4bit       : UInt64 = 0x000000000000000f
            public static let max5bit       : UInt64 = 0x000000000000001f
            public static let max6bit       : UInt64 = 0x000000000000003f
            public static let max7bit       : UInt64 = 0x000000000000007f
            public static let max8bit       : UInt64 = 0x00000000000000ff
            public static let max9bit       : UInt64 = 0x00000000000001ff
            public static let max10bit      : UInt64 = 0x00000000000003ff
            public static let max11bit      : UInt64 = 0x00000000000007ff
            public static let max12bit      : UInt64 = 0x0000000000000fff
            public static let max13bit      : UInt64 = 0x0000000000001fff
            public static let max14bit      : UInt64 = 0x0000000000003fff
            public static let max15bit      : UInt64 = 0x0000000000007fff
            public static let max16bit      : UInt64 = 0x000000000000ffff
            public static let max17bit      : UInt64 = 0x000000000001ffff
            public static let max18bit      : UInt64 = 0x000000000003ffff
            public static let max19bit      : UInt64 = 0x000000000007ffff
            public static let max20bit      : UInt64 = 0x00000000000fffff
            public static let max21bit      : UInt64 = 0x00000000001fffff
            public static let max22bit      : UInt64 = 0x00000000003fffff
            public static let max23bit      : UInt64 = 0x00000000007fffff
            public static let max24bit      : UInt64 = 0x0000000000ffffff
            public static let max25bit      : UInt64 = 0x0000000001ffffff
            public static let max26bit      : UInt64 = 0x0000000003ffffff
            public static let max27bit      : UInt64 = 0x0000000007ffffff
            public static let max28bit      : UInt64 = 0x000000000fffffff
            public static let max29bit      : UInt64 = 0x000000001fffffff
            public static let max30bit      : UInt64 = 0x000000003fffffff
            public static let max31bit      : UInt64 = 0x000000007fffffff
            public static let max32bit      : UInt64 = 0x00000000ffffffff
            public static let max33bit      : UInt64 = 0x00000001ffffffff
            public static let max34bit      : UInt64 = 0x00000003ffffffff
            public static let max35bit      : UInt64 = 0x00000007ffffffff
            public static let max36bit      : UInt64 = 0x0000000fffffffff
            public static let max37bit      : UInt64 = 0x0000001fffffffff
            public static let max38bit      : UInt64 = 0x0000003fffffffff
            public static let max39bit      : UInt64 = 0x0000007fffffffff
            public static let max40bit      : UInt64 = 0x000000ffffffffff
            public static let max41bit      : UInt64 = 0x000001ffffffffff
            public static let max42bit      : UInt64 = 0x000003ffffffffff
            public static let max43bit      : UInt64 = 0x000007ffffffffff
            public static let max44bit      : UInt64 = 0x00000fffffffffff
            public static let max45bit      : UInt64 = 0x00001fffffffffff
            public static let max46bit      : UInt64 = 0x00003fffffffffff
            public static let max47bit      : UInt64 = 0x00007fffffffffff
            public static let max48bit      : UInt64 = 0x0000ffffffffffff
            public static let max49bit      : UInt64 = 0x0001ffffffffffff
            public static let max50bit      : UInt64 = 0x0003ffffffffffff
            public static let max51bit      : UInt64 = 0x0007ffffffffffff
            public static let max52bit      : UInt64 = 0x000fffffffffffff
            public static let max53bit      : UInt64 = 0x001fffffffffffff
            public static let max54bit      : UInt64 = 0x003fffffffffffff
            public static let max55bit      : UInt64 = 0x007fffffffffffff
            public static let max56bit      : UInt64 = 0x00ffffffffffffff
            public static let max57bit      : UInt64 = 0x01ffffffffffffff
            public static let max58bit      : UInt64 = 0x03ffffffffffffff
            public static let max59bit      : UInt64 = 0x07ffffffffffffff
            public static let max60bit      : UInt64 = 0x0fffffffffffffff
            public static let max61bit      : UInt64 = 0x1fffffffffffffff
            public static let max62bit      : UInt64 = 0x3fffffffffffffff
            public static let max63bit      : UInt64 = 0x7fffffffffffffff
            public static let max64bit      : UInt64 = 0xffffffffffffffff
        }
        
        
    }
    
    public enum Masks {
        public typealias bit = Bits
        
        public enum Bits {
            public typealias big     = BigEndianBits
            public typealias little  = LittleEndianBits
            
            public static let bitSwap8      : UInt64 = 0xff00ff00ff00ff00
            public static let bitSwap16     : UInt64 = 0xffff0000ffff0000
            public static let bitSwap32     : UInt64 = 0xffffffff00000000
            
            public static let bitCheck1     : UInt64 = 0x5555555555555555
            public static let bitCheck2     : UInt64 = 0x3333333333333333
            public static let bitCheck4     : UInt64 = 0x0f0f0f0f0f0f0f0f
            public static let bitCheck8     : UInt64 = 0x00ff00ff00ff00ff
            public static let bitCheck16    : UInt64 = 0x0000ffff0000ffff
            public static let bitCheck32    : UInt64 = 0x00000000ffffffff
            
            public enum BigEndianBits {
                
                public static let b0            : UInt64 = 0x8000000000000000
                public static let b1            : UInt64 = 0x4000000000000000
                public static let b2            : UInt64 = 0x2000000000000000
                public static let b3            : UInt64 = 0x1000000000000000
                public static let b4            : UInt64 = 0x0800000000000000
                public static let b5            : UInt64 = 0x0400000000000000
                public static let b6            : UInt64 = 0x0200000000000000
                public static let b7            : UInt64 = 0x0100000000000000
                public static let b8            : UInt64 = 0x0080000000000000
                public static let b9            : UInt64 = 0x0040000000000000
                public static let b10           : UInt64 = 0x0020000000000000
                public static let b11           : UInt64 = 0x0010000000000000
                public static let b12           : UInt64 = 0x0008000000000000
                public static let b13           : UInt64 = 0x0004000000000000
                public static let b14           : UInt64 = 0x0002000000000000
                public static let b15           : UInt64 = 0x0001000000000000
                public static let b16           : UInt64 = 0x0000800000000000
                public static let b17           : UInt64 = 0x0000400000000000
                public static let b18           : UInt64 = 0x0000200000000000
                public static let b19           : UInt64 = 0x0000100000000000
                public static let b20           : UInt64 = 0x0000080000000000
                public static let b21           : UInt64 = 0x0000040000000000
                public static let b22           : UInt64 = 0x0000020000000000
                public static let b23           : UInt64 = 0x0000010000000000
                public static let b24           : UInt64 = 0x0000008000000000
                public static let b25           : UInt64 = 0x0000004000000000
                public static let b26           : UInt64 = 0x0000002000000000
                public static let b27           : UInt64 = 0x0000001000000000
                public static let b28           : UInt64 = 0x0000000800000000
                public static let b29           : UInt64 = 0x0000000400000000
                public static let b30           : UInt64 = 0x0000000200000000
                public static let b31           : UInt64 = 0x0000000100000000
                public static let b32           : UInt64 = 0x0000000080000000
                public static let b33           : UInt64 = 0x0000000040000000
                public static let b34           : UInt64 = 0x0000000020000000
                public static let b35           : UInt64 = 0x0000000010000000
                public static let b36           : UInt64 = 0x0000000008000000
                public static let b37           : UInt64 = 0x0000000004000000
                public static let b38           : UInt64 = 0x0000000002000000
                public static let b39           : UInt64 = 0x0000000001000000
                public static let b40           : UInt64 = 0x0000000000800000
                public static let b41           : UInt64 = 0x0000000000400000
                public static let b42           : UInt64 = 0x0000000000200000
                public static let b43           : UInt64 = 0x0000000000100000
                public static let b44           : UInt64 = 0x0000000000080000
                public static let b45           : UInt64 = 0x0000000000040000
                public static let b46           : UInt64 = 0x0000000000020000
                public static let b47           : UInt64 = 0x0000000000010000
                public static let b48           : UInt64 = 0x0000000000008000
                public static let b49           : UInt64 = 0x0000000000004000
                public static let b50           : UInt64 = 0x0000000000002000
                public static let b51           : UInt64 = 0x0000000000001000
                public static let b52           : UInt64 = 0x0000000000000800
                public static let b53           : UInt64 = 0x0000000000000400
                public static let b54           : UInt64 = 0x0000000000000200
                public static let b55           : UInt64 = 0x0000000000000100
                public static let b56           : UInt64 = 0x0000000000000080
                public static let b57           : UInt64 = 0x0000000000000040
                public static let b58           : UInt64 = 0x0000000000000020
                public static let b59           : UInt64 = 0x0000000000000010
                public static let b60           : UInt64 = 0x0000000000000008
                public static let b61           : UInt64 = 0x0000000000000004
                public static let b62           : UInt64 = 0x0000000000000002
                public static let b63           : UInt64 = 0x0000000000000001
                
                public static let all: [UInt64] = [
                    b0,     b1,     b2,     b3,     b4,     b5,     b6,     b7,
                    b8,     b9,     b10,    b11,    b12,    b13,    b14,    b15,
                    b16,    b17,    b18,    b19,    b20,    b21,    b22,    b23,
                    b24,    b25,    b26,    b27,    b28,    b29,    b30,    b31,
                    b32,    b33,    b34,    b35,    b36,    b37,    b38,    b39,
                    b40,    b41,    b42,    b43,    b44,    b45,    b46,    b47,
                    b48,    b49,    b50,    b51,    b52,    b53,    b54,    b55,
                    b56,    b57,    b58,    b59,    b60,    b61,    b62,    b63
                ]
            }
            
            public enum LittleEndianBits {
                public static let b0            : UInt64 = 0x0000000000000001
                public static let b1            : UInt64 = 0x0000000000000002
                public static let b2            : UInt64 = 0x0000000000000004
                public static let b3            : UInt64 = 0x0000000000000008
                public static let b4            : UInt64 = 0x0000000000000010
                public static let b5            : UInt64 = 0x0000000000000020
                public static let b6            : UInt64 = 0x0000000000000040
                public static let b7            : UInt64 = 0x0000000000000080
                public static let b8            : UInt64 = 0x0000000000000100
                public static let b9            : UInt64 = 0x0000000000000200
                public static let b10           : UInt64 = 0x0000000000000400
                public static let b11           : UInt64 = 0x0000000000000800
                public static let b12           : UInt64 = 0x0000000000001000
                public static let b13           : UInt64 = 0x0000000000002000
                public static let b14           : UInt64 = 0x0000000000004000
                public static let b15           : UInt64 = 0x0000000000008000
                public static let b16           : UInt64 = 0x0000000000010000
                public static let b17           : UInt64 = 0x0000000000020000
                public static let b18           : UInt64 = 0x0000000000040000
                public static let b19           : UInt64 = 0x0000000000080000
                public static let b20           : UInt64 = 0x0000000000100000
                public static let b21           : UInt64 = 0x0000000000200000
                public static let b22           : UInt64 = 0x0000000000400000
                public static let b23           : UInt64 = 0x0000000000800000
                public static let b24           : UInt64 = 0x0000000001000000
                public static let b25           : UInt64 = 0x0000000002000000
                public static let b26           : UInt64 = 0x0000000004000000
                public static let b27           : UInt64 = 0x0000000008000000
                public static let b28           : UInt64 = 0x0000000010000000
                public static let b29           : UInt64 = 0x0000000020000000
                public static let b30           : UInt64 = 0x0000000040000000
                public static let b31           : UInt64 = 0x0000000080000000
                public static let b32           : UInt64 = 0x0000000100000000
                public static let b33           : UInt64 = 0x0000000200000000
                public static let b34           : UInt64 = 0x0000000400000000
                public static let b35           : UInt64 = 0x0000000800000000
                public static let b36           : UInt64 = 0x0000001000000000
                public static let b37           : UInt64 = 0x0000002000000000
                public static let b38           : UInt64 = 0x0000004000000000
                public static let b39           : UInt64 = 0x0000008000000000
                public static let b40           : UInt64 = 0x0000010000000000
                public static let b41           : UInt64 = 0x0000020000000000
                public static let b42           : UInt64 = 0x0000040000000000
                public static let b43           : UInt64 = 0x0000080000000000
                public static let b44           : UInt64 = 0x0000100000000000
                public static let b45           : UInt64 = 0x0000200000000000
                public static let b46           : UInt64 = 0x0000400000000000
                public static let b47           : UInt64 = 0x0000800000000000
                public static let b48           : UInt64 = 0x0001000000000000
                public static let b49           : UInt64 = 0x0002000000000000
                public static let b50           : UInt64 = 0x0004000000000000
                public static let b51           : UInt64 = 0x0008000000000000
                public static let b52           : UInt64 = 0x0010000000000000
                public static let b53           : UInt64 = 0x0020000000000000
                public static let b54           : UInt64 = 0x0040000000000000
                public static let b55           : UInt64 = 0x0080000000000000
                public static let b56           : UInt64 = 0x0100000000000000
                public static let b57           : UInt64 = 0x0200000000000000
                public static let b58           : UInt64 = 0x0400000000000000
                public static let b59           : UInt64 = 0x0800000000000000
                public static let b60           : UInt64 = 0x1000000000000000
                public static let b61           : UInt64 = 0x2000000000000000
                public static let b62           : UInt64 = 0x4000000000000000
                public static let b63           : UInt64 = 0x8000000000000000
                
                public static let all: [UInt64] = [
                    b0,     b1,     b2,     b3,     b4,     b5,     b6,     b7,
                    b8,     b9,     b10,    b11,    b12,    b13,    b14,    b15,
                    b16,    b17,    b18,    b19,    b20,    b21,    b22,    b23,
                    b24,    b25,    b26,    b27,    b28,    b29,    b30,    b31,
                    b32,    b33,    b34,    b35,    b36,    b37,    b38,    b39,
                    b40,    b41,    b42,    b43,    b44,    b45,    b46,    b47,
                    b48,    b49,    b50,    b51,    b52,    b53,    b54,    b55,
                    b56,    b57,    b58,    b59,    b60,    b61,    b62,    b63
                ]
                
            }
        }
        
        
    }
}
