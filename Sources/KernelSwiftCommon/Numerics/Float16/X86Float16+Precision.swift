//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/09/2023.
//

import Foundation

extension KernelNumerics.X86Float16 {
    public enum Precision {
        case exact
        case inexact
        case underflow
        case overflow
        case unknown
    }
}

extension KernelNumerics.X86Float16.Precision {
    public static func fromSingleWidth(_ float: Float) -> Self {
        let single = float.bitPattern
        
        if single == .zero || single == .ieee754.mask.sign { return .exact }
        let exp: Int32 = .init(truncatingIfNeeded: ((single & .ieee754.mask.exponent) >> 23) &- 127)
        let man = single & .ieee754.mask.mantissa
        if exp == 128 { return .exact }
        if exp < -24 { return .underflow }
        if exp > 15 { return .overflow }
        if (man & .ieee754.mask.drop) != .zero { return .inexact }
        if exp < -14 { return .unknown }
        return .exact
    }
}
