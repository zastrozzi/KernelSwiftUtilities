//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/09/2023.
//

import Foundation

extension KernelNumerics.BigUInt {
    public typealias constants = Constants
    
    public enum Constants {
        public typealias base10 = Base10Constants
        public typealias base16 = Base16Constants
        
        public enum Base10Constants {
            public static let zero          : KernelNumerics.BigUInt = 0
            public static let one           : KernelNumerics.BigUInt = 1
            public static let two           : KernelNumerics.BigUInt = 2
            public static let three         : KernelNumerics.BigUInt = 3
            public static let four          : KernelNumerics.BigUInt = 4
            public static let five          : KernelNumerics.BigUInt = 5
            public static let six           : KernelNumerics.BigUInt = 6
            public static let seven         : KernelNumerics.BigUInt = 7
            public static let eight         : KernelNumerics.BigUInt = 8
            public static let nine          : KernelNumerics.BigUInt = 9
            public static let ten           : KernelNumerics.BigUInt = 10
        }
        
        public enum Base16Constants {
            public static let zero          : KernelNumerics.BigUInt = 0x00
            public static let one           : KernelNumerics.BigUInt = 0x01
            public static let two           : KernelNumerics.BigUInt = 0x02
            public static let three         : KernelNumerics.BigUInt = 0x03
            public static let four          : KernelNumerics.BigUInt = 0x04
            public static let five          : KernelNumerics.BigUInt = 0x05
            public static let six           : KernelNumerics.BigUInt = 0x06
            public static let seven         : KernelNumerics.BigUInt = 0x07
            public static let eight         : KernelNumerics.BigUInt = 0x08
            public static let nine          : KernelNumerics.BigUInt = 0x09
            public static let ae            : KernelNumerics.BigUInt = 0x0a
            public static let bee           : KernelNumerics.BigUInt = 0x0b
            public static let cee           : KernelNumerics.BigUInt = 0x0c
            public static let dee           : KernelNumerics.BigUInt = 0x0d
            public static let ee            : KernelNumerics.BigUInt = 0x0e
            public static let eff           : KernelNumerics.BigUInt = 0x0f
        }
    }
}
