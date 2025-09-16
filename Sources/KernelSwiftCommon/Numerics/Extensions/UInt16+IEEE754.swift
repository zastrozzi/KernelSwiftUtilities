//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/09/2023.
//

import Foundation

extension UInt16 {
    public typealias ieee754 = IEEE754
    
    public enum IEEE754 {
        public typealias mask = Mask
        
        public enum Mask {
            public static let sign: UInt16 = 0x8000
            public static let exponent: UInt16 = 0x7c00
            public static let mantissa: UInt16 = 0x03ff
            public static let negativeInfinity: UInt16 = 0xfc00
        }
        
    }
}
