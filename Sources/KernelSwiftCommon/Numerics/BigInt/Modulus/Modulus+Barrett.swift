//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/10/2023.
//

import Foundation


extension KernelNumerics.BigInt.Modulus {
    public struct Barrett: ModulusStrategy {
        private var u: DoubleWords = []
        private var k1 = Int.zero
        private var km1 = Int.zero
        public let modulusStorage: KernelNumerics.DoubleWords
        public let baseStorage: KernelNumerics.DoubleWords
        
        public init(baseStorage: DoubleWords, modulusStorage: DoubleWords) {
            self.modulusStorage = modulusStorage
            self.baseStorage = baseStorage
        }
        
        public init(_ base: BigInt, _ modulus: BigInt) {
            self.init(base: base, modulus: modulus)
            k1 = modulusStorage.count + 1
            km1 = modulusStorage.count - 1
            var uu: DoubleWords = .zeroes(2 * modulusStorage.count + 1)
            uu[2 * modulusStorage.count] = 1
            u = uu.divMod(modulusStorage).q
        }
        
        private func modK1(_ lhs: inout DoubleWords) {
            if lhs.count > k1 { lhs.removeLast(lhs.count - k1) }
            lhs.normalise()
        }
        
        private func divK(_ k: Int, _ lhs: inout DoubleWords) {
            if lhs.count > k { lhs.removeFirst(k) }
            else { lhs = .zeroes(1) }
        }
        
        public func reduce(_ lhs: inout DoubleWords) {
            if modulusStorage.compare(lhs) > .zero { return }
            var tlhs = lhs
            divK(km1, &tlhs)
            tlhs.multiply(u)
            divK(k1, &tlhs)
            modK1(&lhs)
            tlhs.multiply(modulusStorage)
            modK1(&tlhs)
            if lhs.compare(tlhs) < .zero {
                var a: DoubleWords = .zeroes(k1 + 1)
                a[k1] = 1
                lhs.add(a)
            }
            lhs.difference(tlhs)
            while lhs.compare(modulusStorage) >= .zero { lhs.difference(modulusStorage) }
        }
    }
}
//
//
//extension KernelNumerics.BigInt.Modulus {
//    public class Barrett: Modulus {
//        private var u: DoubleWords = []
//        private var k1 = Int.zero
//        private var km1 = Int.zero
//        
//        override public init(_ base: BigInt, _ modulus: BigInt) {
//            super.init(base, modulus)
//            k1 = modulusStorage.count + 1
//            km1 = modulusStorage.count - 1
//            var uu: DoubleWords = .zeroes(2 * modulusStorage.count + 1)
//            uu[2 * modulusStorage.count] = 1
//            u = uu.divMod(modulusStorage).q
//        }
//        
//        private func modK1(_ lhs: inout DoubleWords) {
//            if lhs.count > k1 { lhs.removeLast(lhs.count - k1) }
//            lhs.normalise()
//        }
//        
//        private func divK(_ k: Int, _ lhs: inout DoubleWords) {
//            if lhs.count > k { lhs.removeFirst(k) }
//            else { lhs = .zeroes(1) }
//        }
//        
//        override public func reduce(_ lhs: inout DoubleWords) {
//            if modulusStorage.compare(lhs) > .zero { return }
//            var tlhs = lhs
//            divK(km1, &tlhs)
//            tlhs.multiply(u)
//            divK(k1, &tlhs)
//            modK1(&lhs)
//            tlhs.multiply(modulusStorage)
//            modK1(&tlhs)
//            if lhs.compare(tlhs) < .zero {
//                var a: DoubleWords = .zeroes(k1 + 1)
//                a[k1] = 1
//                lhs.add(a)
//            }
//            lhs.difference(tlhs)
//            while lhs.compare(modulusStorage) >= .zero { lhs.difference(modulusStorage) }
//        }
//    }
//}
