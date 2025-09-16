//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/09/2023.
//

import Foundation

extension KernelNumerics.X86Float16 {
    public static func fromSingleWidthFloat(_ float: Float) -> Self {
        return .init(float)
    }
    
    public static func fromSingleWidthNaN(_ nan: Float32) -> Self? {
        let single = nan.bitPattern
        let sign = single & .ieee754.mask.sign
        let exp = single & .ieee754.mask.exponent
        let man = single & .ieee754.mask.mantissa
        
        if exp != .ieee754.mask.exponent || man == .zero { return nil }
        let half: UInt16 = .init((sign >> 16) | .ieee754.bit.infinity | (man >> 13))
        if (half & .ieee754.mask.mantissa) == .zero { return .init(bitPattern: half | 0x0001) }
        return .init(bitPattern: half)
    }
}
