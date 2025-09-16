//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/10/2023.
//

import Foundation


@_documentation(visibility: private)
public protocol _KernelNumericsBigIntModulusStrategyRepresentable {
    init(baseStorage: DoubleWords, modulusStorage: DoubleWords)
    var modulusStorage: KernelNumerics.DoubleWords { get }
    var baseStorage: KernelNumerics.DoubleWords { get }
    func toMod(_ lhs: KernelNumerics.DoubleWords) -> KernelNumerics.DoubleWords
    func fromMod(_ lhs: KernelNumerics.DoubleWords) -> KernelNumerics.DoubleWords
    func reduce(_ lhs: inout KernelNumerics.DoubleWords)
}

extension KernelNumerics.BigInt {
    public enum Modulus {
        public typealias ModulusStrategy = _KernelNumericsBigIntModulusStrategyRepresentable
    }
}

extension KernelNumerics.BigInt.Modulus.ModulusStrategy {
    @_documentation(visibility: private)
    public typealias BigInt = KernelNumerics.BigInt
    @_documentation(visibility: private)
    public typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
    @_documentation(visibility: private)
    public typealias DoubleWord = KernelNumerics.BigInt.DoubleWord
    
    internal init(base: BigInt, modulus: BigInt) {
        let modulusStorage = modulus.storage
        self.init(baseStorage: base.storage.divMod(modulusStorage).r, modulusStorage: modulusStorage)
    }
    
    public func toMod(_ lhs: DoubleWords) -> DoubleWords { lhs }
    public func fromMod(_ lhs: DoubleWords) -> DoubleWords { lhs }
    
    public func expMod(_ e: BigInt) -> BigInt {
        let k = e.bitWidth < 512 ? 4 : 5
        var g: [DoubleWords] = .init(repeating: .zeroes(.zero), count: 1 << k)
        g[.zero] = toMod(baseStorage)
        var gsq = g[.zero].squared()
        reduce(&gsq)
        for i in 1..<g.count {
            g[i] = g[i - 1].multiplied(gsq)
            reduce(&g[i])
        }
        var res = toMod(.fill(1, with: 1)), eb = e.bitWidth - 1
        while eb >= .zero {
            if e.testBit(eb) {
                var l = max(.zero, eb - k + 1)
                while !e.testBit(l) { l += 1 }
                for _ in .zero..<(eb - l + 1) {
                    res.square()
                    reduce(&res)
                }
                var p = Int.zero
                for i in (l...eb).reversed() {
                    p <<= 1
                    if e.testBit(i) { p += 1 }
                }
                p >>= 1
                res.multiply(g[p])
                reduce(&res)
                eb = l - 1
            } else {
                res.square()
                reduce(&res)
                eb -= 1
            }
        }
        return .init(fromMod(res))
    }
}
//
//extension KernelNumerics.BigInt {
//    public class Modulus {
//        @_documentation(visibility: private)
//        public typealias BigInt = KernelNumerics.BigInt
//        @_documentation(visibility: private)
//        public typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
//        @_documentation(visibility: private)
//        public typealias DoubleWord = KernelNumerics.BigInt.DoubleWord
//        @_documentation(visibility: private)
//        public typealias Modulus = KernelNumerics.BigInt.Modulus
//        
//        public let modulusStorage: DoubleWords
//        public let baseStorage: DoubleWords
//        
//        public init(_ base: BigInt, _ modulus: BigInt) {
//            self.modulusStorage = modulus.storage
//            self.baseStorage = base.storage.divMod(modulusStorage).r
//        }
//        
//        public func toMod(_ lhs: DoubleWords) -> DoubleWords { lhs }
//        public func fromMod(_ lhs: DoubleWords) -> DoubleWords { lhs }
//        public func reduce(_ lhs: inout DoubleWords) { preconditionFailure("Reduce must be implemented by a subclass") }
//        
//        public func expMod(_ e: BigInt) -> BigInt {
//            let k = e.bitWidth < 512 ? 4 : 5
//            var g: [DoubleWords] = .init(repeating: .zeroes(.zero), count: 1 << k)
//            g[.zero] = toMod(baseStorage)
//            var gsq = g[.zero].squared()
//            reduce(&gsq)
//            for i in 1..<g.count {
//                g[i] = g[i - 1].multiplied(gsq)
//                reduce(&g[i])
//            }
//            var res = toMod(.fill(1, with: 1)), eb = e.bitWidth - 1
//            while eb >= .zero {
//                if e.testBit(eb) {
//                    var l = max(.zero, eb - k + 1)
//                    while !e.testBit(l) { l += 1 }
//                    for _ in .zero..<(eb - l + 1) {
//                        res.square()
//                        reduce(&res)
//                    }
//                    var p = Int.zero
//                    for i in (l...eb).reversed() {
//                        p <<= 1
//                        if e.testBit(i) { p += 1 }
//                    }
//                    p >>= 1
//                    res.multiply(g[p])
//                    reduce(&res)
//                    eb = l - 1
//                } else {
//                    res.square()
//                    reduce(&res)
//                    eb -= 1
//                }
//            }
//            return .init(fromMod(res))
//        }
//    }
//}
