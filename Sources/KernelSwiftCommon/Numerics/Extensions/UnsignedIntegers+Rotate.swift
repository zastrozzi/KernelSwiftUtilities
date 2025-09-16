//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/10/2023.
//

import Foundation

extension UnsignedInteger {
    @inline(__always)
    public func rotatedRight(by n: Int) -> Self where Self: FixedWidthInteger {
        (self >> n) | (self << (Self.bitWidth - n))
    }
    
    @inline(__always)
    public func rotatedLeft(by n: Int) -> Self where Self: FixedWidthInteger {
        (self << n) | (self >> (Self.bitWidth - n))
    }
}
