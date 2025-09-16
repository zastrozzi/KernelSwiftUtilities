//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.ChaCha {
    public struct ChaCha20 {
        public let s: KernelNumerics.Words512
        
        public init(_ key: [UInt8], _ nonce: [UInt8]) {
            let ss = val.chacha20StateSeed
            let kw = KernelNumerics.Words.fromBytes(key, count: 8)
            let nw = KernelNumerics.Words.fromBytes(nonce, count: 3)
            self.s = (
                ss.0,   ss.1,   ss.2,   ss.3,
                kw[0],  kw[1],  kw[2],  kw[3],
                kw[4],  kw[5],  kw[6],  kw[7],
                .zero,  nw[0],  nw[1],  nw[2]
            )
        }
        
        public func blockFunction(_ block: inout KernelNumerics.Words, _ ctr: KernelNumerics.Word = .zero) {
            var b = s
            b.12 = ctr

            for _ in .zero..<10 {
                quarterRound(&b.0, &b.4, &b.8, &b.12)
                quarterRound(&b.1, &b.5, &b.9, &b.13)
                quarterRound(&b.2, &b.6, &b.10, &b.14)
                quarterRound(&b.3, &b.7, &b.11, &b.15)
                quarterRound(&b.0, &b.5, &b.10, &b.15)
                quarterRound(&b.1, &b.6, &b.11, &b.12)
                quarterRound(&b.2, &b.7, &b.8, &b.13)
                quarterRound(&b.3, &b.4, &b.9, &b.14)
            }
            block.update(from: (
                b.0 &+ s.0,     b.1 &+ s.1,     b.2 &+ s.2,     b.3 &+ s.3,
                b.4 &+ s.4,     b.5 &+ s.5,     b.6 &+ s.6,     b.7 &+ s.7,
                b.8 &+ s.8,     b.9 &+ s.9,     b.10 &+ s.10,   b.11 &+ s.11,
                b.12 &+ ctr,    b.13 &+ s.13,   b.14 &+ s.14,   b.15 &+ s.15
            ))
        }
        
        func quarterRound(
            _ w0: inout KernelNumerics.Word,
            _ w1: inout KernelNumerics.Word,
            _ w2: inout KernelNumerics.Word,
            _ w3: inout KernelNumerics.Word
        ) {
            w0 &+=  w1
            w3 ^=   w0
            w3 =   (w3 << 16) | (w3 >> 16)
            w2 &+=  w3
            w1 ^=   w2
            w1 =   (w1 << 12) | (w1 >> 20)
            w0 &+=  w1
            w3 ^=   w0
            w3 =   (w3 << 8) | (w3 >> 24)
            w2 &+=  w3
            w1 ^=   w2
            w1 =   (w1 << 7) | (w1 >> 25)
        }
        
        public func encrypt(_ input: inout [UInt8]) {
            var xor: KernelNumerics.Words = .zeroes(16)
            let ptr = withUnsafePointer(to: &xor[0]) {
                $0.withMemoryRebound(to: UInt8.self, capacity: 64) { UnsafeBufferPointer(start: $0, count: 64) }
            }
            var j: Int = .zero
            var counter: KernelNumerics.Word = .zero
            input.withUnsafeMutableBufferPointer { ui in
                for i in .zero..<ui.count {
                    if i % 64 == .zero {
                        j = .zero
                        counter += 1
                        blockFunction(&xor, counter)
                    }
                    ui[i] ^= ptr[j]
                    j += 1
                }
            }
        }
    }
}
