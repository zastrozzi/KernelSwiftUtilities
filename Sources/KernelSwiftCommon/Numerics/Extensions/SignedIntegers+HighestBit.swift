//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/06/2023.
//

import Foundation
// GLOBAL_F
//
///// maybe put this under a static on KernelNumerics?

public extension Int {
    // my goodness we're bit fiddling
    func highestBit() -> Self {
        var n = self
        n |= (n >> 1)
        n |= (n >> 2)
        n |= (n >> 4)
        n |= (n >> 8)
        n |= (n >> 16)
        n |= (n >> 32)
        
        return n - (n >> 1)
    }
    
    static func safeHighestBit(_ n : Int) -> Int {
        var n = n
        
        n |= (n >>  1)
        n |= (n >>  2)
        n |= (n >>  4)
        n |= (n >>  8)
        n |= (n >> 16)
        n |= (n >> 32)
        n |= (n >> 64)
        n |= (n >> 128)
        n |= (n >> 256)
        
        return n - (n >> 1)
    }
}

public extension Int8 {
    // my goodness we're bit fiddling
    func highestBit() -> Self {
        var n = self
        n |= (n >> 1)
        n |= (n >> 2)
        n |= (n >> 4)
        
        return n - (n >> 1)
    }
}


public extension Int16 {
    // my goodness we're bit fiddling
    func highestBit() -> Self {
        var n = self
        n |= (n >> 1)
        n |= (n >> 2)
        n |= (n >> 4)
        n |= (n >> 8)
        
        return n - (n >> 1)
    }
}


public extension Int32 {
    // my goodness we're bit fiddling
    func highestBit() -> Self {
        var n = self
        n |= (n >> 1)
        n |= (n >> 2)
        n |= (n >> 4)
        n |= (n >> 8)
        n |= (n >> 16)
        
        return n - (n >> 1)
    }
}


public extension Int64 {
    // my goodness we're bit fiddling
    func highestBit() -> Self {
        var n = self
        n |= (n >> 1)
        n |= (n >> 2)
        n |= (n >> 4)
        n |= (n >> 8)
        n |= (n >> 16)
        n |= (n >> 32)
        
        return n - (n >> 1)
    }
}
