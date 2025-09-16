//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/09/2023.
//

import Foundation

extension KernelNumerics.X86Float16 {
    public static func fromHalfWidthBits(_ half: UInt16) -> Self {
        .init(bitPattern: half)
    }
    
    public static func singleWidthToHalfWidthBits(_ single: UInt32) -> UInt16 {
        let sign = single & .ieee754.mask.sign
        let exp = single & .ieee754.mask.exponent
        let man = single & .ieee754.mask.mantissa

        if exp == .ieee754.mask.exponent {
            let nan: UInt32 = man == .zero ? .zero : .ieee754.bit.nan
            return .init((sign >> 16) | .ieee754.bit.infinity | nan | (man >> 13))
        }
        
        let halfSign = sign >> 16
        let halfExp = Int32(exp >> 23) - 0x70
        if halfExp >= 0x1f { return .init(halfSign | .ieee754.bit.infinity) }
        
        if halfExp <= .zero {
            if 14 - halfExp > 24 { return .init(halfSign) }
            let man = man | .ieee754.bit.hiddenMantissa
            let halfMan = man >> UInt32(14 - halfExp)
            let round: UInt32 = 1 << UInt32(13 - halfExp)
            if (man & round) != .zero && (man & (3 * round - 1)) != .zero { return .init(halfSign | halfMan + 1) }
            return .init(halfSign | halfMan)
        }
        
        let uHalfExp = UInt32(halfExp) << 10
        let halfMan = man >> 13
        if (man & .ieee754.bit.rounding) != .zero && (man & (3 * .ieee754.bit.rounding - 1)) != .zero {
            return .init((halfSign | uHalfExp | halfMan) + 1)
        }
        return .init(halfSign | uHalfExp | halfMan)
    }
    
    public static func halfWidthToSingleWidthBits(_ half: UInt16) -> UInt32 {
        let sign: UInt32 = .init(half & .ieee754.mask.sign) << 16
        var exp: UInt32 = .init(half & .ieee754.mask.exponent) >> 10
        var man: UInt32 = .init(half & .ieee754.mask.mantissa) << 13
        
        if exp == 0x1f {
            if man == .zero { return sign | .ieee754.mask.exponent | man }
            return sign | .ieee754.mask.nan | man
        }
        
        if exp == .zero {
            if man == .zero { return sign }
            exp += 1
            while man & .ieee754.mask.exponent == .zero {
                man <<= 1
                exp &-= 1
            }
            man &= .ieee754.mask.mantissa
        }
        return sign | ((exp &+ 0x70) << 23) | man
    }
}
