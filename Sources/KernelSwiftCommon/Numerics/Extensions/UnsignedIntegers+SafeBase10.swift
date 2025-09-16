//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/05/2023.
//

import Foundation

public protocol UnsignedBase10ExponentLookup: UnsignedInteger {
    static func pow10<E: BinaryInteger>(_ exponent: E) throws -> Self
}



extension UInt8: UnsignedBase10ExponentLookup {
    public static func pow10<E: BinaryInteger>(_ exponent: E) throws -> Self {
        switch exponent {
        case 0: return 1
        case 1: return 10
        case 2: return 100
        default: throw ArithmeticError.outOfRange
        }
    }
}

extension UInt16: UnsignedBase10ExponentLookup {
    public static func pow10<E: BinaryInteger>(_ exponent: E) throws -> Self {
        switch exponent {
        case 0: return 1
        case 1: return 10
        case 2: return 100
        case 3: return 1_000
        case 4: return 10_000
        default: throw ArithmeticError.outOfRange
        }
    }
}

extension UInt32: UnsignedBase10ExponentLookup {
    public static func pow10<E: BinaryInteger>(_ exponent: E) throws -> Self {
        switch exponent {
        case 0: return 1
        case 1: return 10
        case 2: return 100
        case 3: return 1_000
        case 4: return 10_000
        case 5: return 100_000
        case 6: return 1_000_000
        case 7: return 10_000_000
        case 8: return 100_000_000
        case 9: return 1_000_000_000
        default: throw ArithmeticError.outOfRange
        }
    }
}

extension UInt64: UnsignedBase10ExponentLookup {
    public static func pow10<E: BinaryInteger>(_ exponent: E) throws -> Self {
        switch exponent {
        case 0: return 1
        case 1: return 10
        case 2: return 100
        case 3: return 1_000
        case 4: return 10_000
        case 5: return 100_000
        case 6: return 1_000_000
        case 7: return 10_000_000
        case 8: return 100_000_000
        case 9: return 1_000_000_000
        case 10: return 10_000_000_000
        case 11: return 100_000_000_000
        case 12: return 1_000_000_000_000
        case 13: return 10_000_000_000_000
        case 14: return 100_000_000_000_000
        case 15: return 1_000_000_000_000_000
        case 16: return 10_000_000_000_000_000
        case 17: return 100_000_000_000_000_000
        case 18: return 1_000_000_000_000_000_000
        case 19: return 10_000_000_000_000_000_000
        default: throw ArithmeticError.outOfRange
        }
    }
}

extension UInt: UnsignedBase10ExponentLookup {
    public static func pow10<E: BinaryInteger>(_ exponent: E) throws -> Self {
        switch exponent {
        case 0: return 1
        case 1: return 10
        case 2: return 100
        case 3: return 1_000
        case 4: return 10_000
        case 5: return 100_000
        case 6: return 1_000_000
        case 7: return 10_000_000
        case 8: return 100_000_000
        case 9: return 1_000_000_000
        case 10: return 10_000_000_000
        case 11: return 100_000_000_000
        case 12: return 1_000_000_000_000
        case 13: return 10_000_000_000_000
        case 14: return 100_000_000_000_000
        case 15: return 1_000_000_000_000_000
        case 16: return 10_000_000_000_000_000
        case 17: return 100_000_000_000_000_000
        case 18: return 1_000_000_000_000_000_000
        case 19: return 10_000_000_000_000_000_000
        default: throw ArithmeticError.outOfRange
        }
    }
}
