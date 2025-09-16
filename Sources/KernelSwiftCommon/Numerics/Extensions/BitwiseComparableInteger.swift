//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/10/2023.
//

import Foundation

public protocol BitwiseComparableInteger {
    static func |(lhs: Self, rhs: Self) -> Self
    static func &(lhs: Self, rhs: Self) -> Self
    static func ^(lhs: Self, rhs: Self) -> Self
    static func ==(lhs: Self, rhs: Self) -> Bool
    static func !=(lhs: Self, rhs: Self) -> Bool
    static func <(lhs: Self, rhs: Self) -> Bool
    static func <=(lhs: Self, rhs: Self) -> Bool
    static func >(lhs: Self, rhs: Self) -> Bool
    static func >=(lhs: Self, rhs: Self) -> Bool
//    
//    func and(_ rhs: Self, equals res: Self) -> Bool
//    func and(_ rhs: Self, lessThan res: Self) -> Bool
//    func and(_ rhs: Self, lessOrEquals res: Self) -> Bool
//    func and(_ rhs: Self, greaterThan res: Self) -> Bool
//    func and(_ rhs: Self, greaterOrEquals res: Self) -> Bool
//    func or(_ rhs: Self, equals res: Self) -> Bool
//    func or(_ rhs: Self, lessThan res: Self) -> Bool
//    func or(_ rhs: Self, lessOrEquals res: Self) -> Bool
//    func or(_ rhs: Self, greaterThan res: Self) -> Bool
//    func or(_ rhs: Self, greaterOrEquals res: Self) -> Bool
//    func xor(_ rhs: Self, equals res: Self) -> Bool
//    func xor(_ rhs: Self, lessThan res: Self) -> Bool
//    func xor(_ rhs: Self, lessOrEquals res: Self) -> Bool
//    func xor(_ rhs: Self, greaterThan res: Self) -> Bool
//    func xor(_ rhs: Self, greaterOrEquals res: Self) -> Bool
}

extension BitwiseComparableInteger {
    @inlinable @inline(__always) public func and(_ rhs: Self, equals res: Self) -> Bool { self & rhs == res }
    @inlinable @inline(__always) public func and(_ rhs: Self, not res: Self) -> Bool { self & rhs != res }
    @inlinable @inline(__always) public func and(_ rhs: Self, lessThan res: Self) -> Bool { self & rhs < res }
    @inlinable @inline(__always) public func and(_ rhs: Self, lessOrEquals res: Self) -> Bool { self & rhs <= res }
    @inlinable @inline(__always) public func and(_ rhs: Self, greaterThan res: Self) -> Bool { self & rhs > res }
    @inlinable @inline(__always) public func and(_ rhs: Self, greaterOrEquals res: Self) -> Bool { self & rhs >= res }
    
    @inlinable @inline(__always) public func andEquals(_ rhs: Self) -> Bool { self & rhs == rhs }
    @inlinable @inline(__always) public func andNotEquals(_ rhs: Self) -> Bool { self & rhs != rhs }
    @inlinable @inline(__always) public func andLessThan(_ rhs: Self) -> Bool { self & rhs < rhs }
    @inlinable @inline(__always) public func andLessOrEquals(_ rhs: Self) -> Bool { self & rhs <= rhs }
    @inlinable @inline(__always) public func andGreaterThan(_ rhs: Self) -> Bool { self & rhs > rhs }
    @inlinable @inline(__always) public func andGreaterOrEquals(_ rhs: Self) -> Bool { self & rhs >= rhs }
    
    @inlinable @inline(__always) public func or(_ rhs: Self, equals res: Self) -> Bool { self | rhs == res }
    @inlinable @inline(__always) public func or(_ rhs: Self, not res: Self) -> Bool { self | rhs != res }
    @inlinable @inline(__always) public func or(_ rhs: Self, lessThan res: Self) -> Bool { self | rhs < res }
    @inlinable @inline(__always) public func or(_ rhs: Self, lessOrEquals res: Self) -> Bool { self | rhs <= res }
    @inlinable @inline(__always) public func or(_ rhs: Self, greaterThan res: Self) -> Bool { self | rhs > res }
    @inlinable @inline(__always) public func or(_ rhs: Self, greaterOrEquals res: Self) -> Bool { self | rhs >= res }
    
    @inlinable @inline(__always) public func orEquals(_ rhs: Self) -> Bool { self | rhs == rhs }
    @inlinable @inline(__always) public func orNotEquals(_ rhs: Self) -> Bool { self | rhs != rhs }
    @inlinable @inline(__always) public func orLessThan(_ rhs: Self) -> Bool { self | rhs < rhs }
    @inlinable @inline(__always) public func orLessOrEquals(_ rhs: Self) -> Bool { self | rhs <= rhs }
    @inlinable @inline(__always) public func orGreaterThan(_ rhs: Self) -> Bool { self | rhs > rhs }
    @inlinable @inline(__always) public func orGreaterOrEquals(_ rhs: Self) -> Bool { self | rhs >= rhs }
    
    @inlinable @inline(__always) public func xor(_ rhs: Self, equals res: Self) -> Bool { self ^ rhs == res }
    @inlinable @inline(__always) public func xor(_ rhs: Self, not res: Self) -> Bool { self ^ rhs != res }
    @inlinable @inline(__always) public func xor(_ rhs: Self, lessThan res: Self) -> Bool { self ^ rhs < res }
    @inlinable @inline(__always) public func xor(_ rhs: Self, lessOrEquals res: Self) -> Bool { self ^ rhs <= res }
    @inlinable @inline(__always) public func xor(_ rhs: Self, greaterThan res: Self) -> Bool { self ^ rhs > res }
    @inlinable @inline(__always) public func xor(_ rhs: Self, greaterOrEquals res: Self) -> Bool { self ^ rhs >= res }
    
    @inlinable @inline(__always) public func xorEquals(_ rhs: Self) -> Bool { self ^ rhs == rhs }
    @inlinable @inline(__always) public func xorNotEquals(_ rhs: Self) -> Bool { self ^ rhs != rhs }
    @inlinable @inline(__always) public func xorLessThan(_ rhs: Self) -> Bool { self ^ rhs < rhs }
    @inlinable @inline(__always) public func xorLessOrEquals(_ rhs: Self) -> Bool { self ^ rhs <= rhs }
    @inlinable @inline(__always) public func xorGreaterThan(_ rhs: Self) -> Bool { self ^ rhs > rhs }
    @inlinable @inline(__always) public func xorGreaterOrEquals(_ rhs: Self) -> Bool { self ^ rhs >= rhs }
}

extension Int: BitwiseComparableInteger {}
extension Int8: BitwiseComparableInteger {}
extension Int16: BitwiseComparableInteger {}
extension Int32: BitwiseComparableInteger {}
extension Int64: BitwiseComparableInteger {}
extension UInt: BitwiseComparableInteger {}
extension UInt8: BitwiseComparableInteger {}
extension UInt16: BitwiseComparableInteger {}
extension UInt32: BitwiseComparableInteger {}
extension UInt64: BitwiseComparableInteger {}
