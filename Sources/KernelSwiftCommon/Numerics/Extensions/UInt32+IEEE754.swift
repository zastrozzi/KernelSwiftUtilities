//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/09/2023.
//

import Foundation

extension UInt32 {
    public typealias ieee754 = IEEE754
    
    public enum IEEE754 {
        public typealias mask = Mask
        public typealias bit = Bit
        
        public enum Mask {
            public static let sign: UInt32              = 0x80000000
            public static let exponent: UInt32          = 0x7f800000
            public static let nan: UInt32               = 0x7fc00000
            public static let mantissa: UInt32          = 0x007fffff
            public static let drop: UInt32              = 0x00001fff
            
        }
        
        public enum Bit {
            public static let b0: UInt32                = 0x80000000
            public static let b1: UInt32                = 0x40000000
            public static let b2: UInt32                = 0x20000000
            public static let nan: UInt32               = 0x00000200
            public static let infinity: UInt32          = 0x00007c00
            public static let hiddenMantissa: UInt32    = 0x00800000
            public static let rounding: UInt32          = 0x00001000
            
            public static let max28bit: UInt32          = 0x0fffffff
        }
    }
}
