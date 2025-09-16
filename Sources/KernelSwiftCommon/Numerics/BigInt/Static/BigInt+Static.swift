//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/10/2023.
//

import Foundation

extension KernelNumerics.BigInt {
    public typealias val = ConstantValues
    public typealias util = UtilityValues
    
    public enum ConstantValues {}
    public enum UtilityValues {}
    
    public static let zero      : KernelNumerics.BigInt = val.little.base10.zero
    public static let one       : KernelNumerics.BigInt = val.little.base10.one
    public static let two       : KernelNumerics.BigInt = val.little.base10.two
    public static let three     : KernelNumerics.BigInt = val.little.base10.three
    public static let four      : KernelNumerics.BigInt = val.little.base10.four
    public static let five      : KernelNumerics.BigInt = val.little.base10.five
    public static let six       : KernelNumerics.BigInt = val.little.base10.six
    public static let seven     : KernelNumerics.BigInt = val.little.base10.seven
    public static let eight     : KernelNumerics.BigInt = val.little.base10.eight
    public static let nine      : KernelNumerics.BigInt = val.little.base10.nine
    
    public static let min2dw : Self = .init([.val.little.base10.one, .zero])
}

extension KernelNumerics.BigInt.ConstantValues {
    public typealias little = LittleEndian
    public typealias big    = BigEndian
    
    public enum LittleEndian {}
    public enum BigEndian {}
    
    
}

extension KernelNumerics.BigInt.ConstantValues.LittleEndian {
    public typealias base10 = Base10
        
    public enum Base10 {
        public static let zero      : KernelNumerics.BigInt = .init(.val.little.base10.zero)
        public static let one       : KernelNumerics.BigInt = .init(.val.little.base10.one)
        public static let two       : KernelNumerics.BigInt = .init(.val.little.base10.two)
        public static let three     : KernelNumerics.BigInt = .init(.val.little.base10.three)
        public static let four      : KernelNumerics.BigInt = .init(.val.little.base10.four)
        public static let five      : KernelNumerics.BigInt = .init(.val.little.base10.five)
        public static let six       : KernelNumerics.BigInt = .init(.val.little.base10.six)
        public static let seven     : KernelNumerics.BigInt = .init(.val.little.base10.seven)
        public static let eight     : KernelNumerics.BigInt = .init(.val.little.base10.eight)
        public static let nine      : KernelNumerics.BigInt = .init(.val.little.base10.nine)
    }
    
    public static let max30bit      : KernelNumerics.BigInt = .init(.val.little.max30bit)
}

extension KernelNumerics.BigInt.UtilityValues {
    public static let zeroPadding = "0000000000000000000000000000000000000000000000000000000000000000"
    public static let d2pow64: Double = .init(sign: .plus, exponent: 64, significand: 1.0)
    public static let b62: KernelNumerics.BigInt = KernelNumerics.BigInt.one << 62
    
    public static let squareMap: [Bool] = [
//          0x00    0x01    0x02    0x03    0x04    0x05    0x06    0x07    0x08    0x09    0x0a    0x0b    0x0c    0x0d    0x0e    0x0f
/*0x00*/    true,   true,   false,  false,  true,   false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x01*/    true,   true,   false,  false,  false,  false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x02*/    false,  true,   false,  false,  true,   false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x03*/    false,  true,   false,  false,  false,  false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x04*/    true,   true,   false,  false,  true,   false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x05*/    false,  true,   false,  false,  false,  false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x06*/    false,  true,   false,  false,  true,   false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x07*/    false,  true,   false,  false,  false,  false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x08*/    false,  true,   false,  false,  true,   false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x09*/    true,   true,   false,  false,  false,  false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x0a*/    false,  true,   false,  false,  true,   false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x0b*/    false,  true,   false,  false,  false,  false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x0c*/    false,  true,   false,  false,  true,   false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x0d*/    false,  true,   false,  false,  false,  false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x0e*/    false,  true,   false,  false,  true,   false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false,
/*0x0f*/    false,  true,   false,  false,  false,  false,  false,  false,  false,  true,   false,  false,  false,  false,  false,  false
    ]
    
    public static let rootWheel: [Int] = [4, 2, 4, 2, 4, 6, 2, 6]
}
