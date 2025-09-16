//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

extension KernelNumerics.BigUInt {
    nonisolated(unsafe) public static var sharedRNG = SystemRandomNumberGenerator()
    
    @inlinable
    public static func randomInteger(withMaximumWidth width: Int) -> KernelNumerics.BigUInt {
        var result = Self.zero
        var bitsLeft = width
        var i = 0
        let wordsNeeded = (width + Word.bitWidth - 1) / Word.bitWidth
        if wordsNeeded > 2 {
            reserveCapacity(for: &result, wordsNeeded)
        }
        while bitsLeft >= Word.bitWidth {
            result[i] = Self.sharedRNG.next()
            i += 1
            bitsLeft -= Word.bitWidth
        }
        if bitsLeft > 0 {
            let mask: Word = (1 << bitsLeft) - 1
            result[i] = (Self.sharedRNG.next() as Word) & mask
        }
        return result
    }

//    @inlinable
//    public static func randomInteger(withMaximumWidth width: Int) -> KernelNumerics.BigUInt {
////        var rng = SystemRandomNumberGenerator()
//        return randomInteger(withMaximumWidth: width)
//    }

    @inlinable
    public static func randomInteger(withExactWidth width: Int) -> KernelNumerics.BigUInt {
        guard width > 1 else { return KernelNumerics.BigUInt(width) }
        var result = randomInteger(withMaximumWidth: width - 1)
        result[(width - 1) / Word.bitWidth] |= 1 << Word((width - 1) % Word.bitWidth)
        result |= 1
        return result
    }

//    @inlinable
//    public static func randomInteger(withExactWidth width: Int) -> KernelNumerics.BigUInt {
//        var rng = SystemRandomNumberGenerator()
//        return randomInteger(withExactWidth: width, using: &rng)
//    }
    
    @inlinable
    public static func randomOddInteger(withExactWidth width: Int) -> KernelNumerics.BigUInt {
        guard width > 1 else { return KernelNumerics.BigUInt(width) }
        var result = randomInteger(withMaximumWidth: width - 1)
        result[(width - 1) / Word.bitWidth] |= 1 << Word((width - 1) % Word.bitWidth)
        result |= 1
        return result
    }
    
//    @inlinable
//    public static func randomOddInteger(withExactWidth width: Int) -> KernelNumerics.BigUInt {
//        
//        return randomOddInteger(withExactWidth: width, using: &rng)
//    }

    @inlinable
    public static func randomInteger(lessThan limit: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
//        precondition(limit > 0, "\(#function): 0 is not a valid limit")
        let width = limit.bitWidth
        var random = randomInteger(withMaximumWidth: width)
        while random >= limit {
            random = randomInteger(withMaximumWidth: width)
        }
        return random
    }
//
//    @inlinable
//    public static func randomInteger(lessThan limit: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
////        var rng = SystemRandomNumberGenerator()
//        return randomInteger(lessThan: limit)
//    }
}
