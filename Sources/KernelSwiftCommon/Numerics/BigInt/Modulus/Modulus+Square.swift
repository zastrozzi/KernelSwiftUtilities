//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/10/2023.
//

import Foundation


extension KernelNumerics.BigInt.Modulus {
    public struct Square: ModulusStrategy {
        private var doubleWordCount = Int.zero
        private var mask = DoubleWord.zero
        public let modulusStorage: KernelNumerics.DoubleWords
        public let baseStorage: KernelNumerics.DoubleWords
        
        public init(baseStorage: DoubleWords, modulusStorage: DoubleWords) {
            self.modulusStorage = modulusStorage
            self.baseStorage = baseStorage
        }
        
        public init(_ base: BigInt, _ modulus: BigInt) {
            self.init(base: base, modulus: modulus)
            let t = modulus.trailingZeroBitCount
            doubleWordCount = t / DoubleWord.bitWidth
            if t % DoubleWord.bitWidth != .zero { doubleWordCount += 1 }
            for _ in .zero..<(t % DoubleWord.bitWidth) { mask = (mask << 1) + 1 }
        }
        
        public func reduce(_ lhs: inout DoubleWords) {
            let k = lhs.count - doubleWordCount
            if k > .zero { lhs.removeLast(k) }
            if lhs.count == doubleWordCount { lhs[lhs.count - 1] &= mask }
            lhs.normalise()
        }
    }
}

//
//extension KernelNumerics.BigInt.Modulus {
//    public class Square: Modulus {
//        private var doubleWordCount = Int.zero
//        private var mask = DoubleWord.zero
//        
//        override public init(_ base: BigInt, _ modulus: BigInt) {
//            super.init(base, modulus)
//            let t = modulus.trailingZeroBitCount
//            doubleWordCount = t / DoubleWord.bitWidth
//            if t % DoubleWord.bitWidth != .zero { doubleWordCount += 1 }
//            for _ in .zero..<(t % DoubleWord.bitWidth) { mask = (mask << 1) + 1 }
//        }
//        
//        override public func reduce(_ lhs: inout DoubleWords) {
//            let k = lhs.count - doubleWordCount
//            if k > .zero { lhs.removeLast(k) }
//            if lhs.count == doubleWordCount { lhs[lhs.count - 1] &= mask }
//            lhs.normalise()
//        }
//    }
//}
