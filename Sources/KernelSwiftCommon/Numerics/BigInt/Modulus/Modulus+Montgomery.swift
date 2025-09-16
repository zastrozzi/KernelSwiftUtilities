//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/10/2023.
//

import Foundation


extension KernelNumerics.BigInt.Modulus {
    public struct Montgomery: ModulusStrategy {
        var radixSize = Int.zero
        var radixSize64Bit = Int.zero
        var radixInv: DoubleWords = .fill(1, with: 1)
        var modP: DoubleWords = .zeroes(1)
        public let modulusStorage: KernelNumerics.DoubleWords
        public let baseStorage: KernelNumerics.DoubleWords
        
        public init(baseStorage: DoubleWords, modulusStorage: DoubleWords) {
            self.modulusStorage = modulusStorage
            self.baseStorage = baseStorage
        }
        
        public init(_ base: BigInt, _ modulus: BigInt) {
            self.init(base: base, modulus: modulus)
            radixSize = modulusStorage.count
            radixSize64Bit = radixSize << 6
            for _ in 0 ..< radixSize64Bit {
                if radixInv[.zero].and(1, equals: .zero) {
                    radixInv.shiftRightOne()
                    modP.shiftRightOne()
                } else {
                    radixInv.add(modulusStorage)
                    radixInv.shiftRightOne()
                    modP.shiftRightOne()
                    modP.setBit(radixSize64Bit - 1)
                }
            }
        }
        
        public func toMod(_ lhs: DoubleWords) -> DoubleWords {
            (lhs.shiftedLeft(radixSize64Bit)).divMod(modulusStorage).r
        }
        
        public func fromMod(_ lhs: DoubleWords) -> DoubleWords {
            return (lhs.multiplied(radixInv)).divMod(modulusStorage).r
        }
        
        private func modR(_ lhs: inout DoubleWords) {
            if lhs.count > radixSize { lhs.removeLast(lhs.count - radixSize) }
            lhs.normalise()
        }
        
        private func divR(_ lhs: inout DoubleWords) {
            if lhs.count > radixSize { lhs.removeFirst(radixSize) }
            else { lhs = .zeroes(1) }
        }
        
        public func reduce(_ lhs: inout DoubleWords) {
            var tlhs = lhs
            modR(&tlhs)
            tlhs.multiply(modP)
            modR(&tlhs)
            tlhs.multiply(modulusStorage)
            tlhs.add(lhs)
            divR(&tlhs)
            if !tlhs.lessThan(modulusStorage) { tlhs.difference(modulusStorage) }
            lhs = tlhs
        }
        
    }
}
//
//
//extension KernelNumerics.BigInt.Modulus {
//    public class Montgomery: Modulus {
//        var radixSize = Int.zero
//        var radixSize64Bit = Int.zero
//        var radixInv: DoubleWords = .fill(1, with: 1)
//        var modP: DoubleWords = .zeroes(1)
//        
//        override public init(_ base: BigInt, _ modulus: BigInt) {
//            super.init(base, modulus)
//            radixSize = modulusStorage.count
//            radixSize64Bit = radixSize << 6
//            for _ in 0 ..< radixSize64Bit {
//                if radixInv[.zero].and(1, equals: .zero) {
//                    radixInv.shiftRightOne()
//                    modP.shiftRightOne()
//                } else {
//                    radixInv.add(modulusStorage)
//                    radixInv.shiftRightOne()
//                    modP.shiftRightOne()
//                    modP.setBit(radixSize64Bit - 1)
//                }
//            }
//        }
//        
//        override public func toMod(_ lhs: DoubleWords) -> DoubleWords {
//            (lhs.shiftedLeft(radixSize64Bit)).divMod(modulusStorage).r
//        }
//        
//        override public func fromMod(_ lhs: DoubleWords) -> DoubleWords {
//            return (lhs.multiplied(radixInv)).divMod(modulusStorage).r
//        }
//        
//        private func modR(_ lhs: inout DoubleWords) {
//            if lhs.count > radixSize { lhs.removeLast(lhs.count - radixSize) }
//            lhs.normalise()
//        }
//        
//        private func divR(_ lhs: inout DoubleWords) {
//            if lhs.count > radixSize { lhs.removeFirst(radixSize) }
//            else { lhs = .zeroes(1) }
//        }
//        
//        override public func reduce(_ lhs: inout DoubleWords) {
//            var tlhs = lhs
//            modR(&tlhs)
//            tlhs.multiply(modP)
//            modR(&tlhs)
//            tlhs.multiply(modulusStorage)
//            tlhs.add(lhs)
//            divR(&tlhs)
//            if !tlhs.lessThan(modulusStorage) { tlhs.difference(modulusStorage) }
//            lhs = tlhs
//        }
//        
//    }
//}
