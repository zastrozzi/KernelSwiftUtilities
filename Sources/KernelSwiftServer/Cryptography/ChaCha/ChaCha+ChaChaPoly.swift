//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.ChaCha {
    public struct ChaChaPoly {
        public internal(set) var key: [UInt8]
        public internal(set) var nonce: [UInt8]
        
        public init(_ key: [UInt8], _ nonce: [UInt8]) throws {
            guard key.count == 32 && nonce.count == 12 else { throw KernelCryptography.TypedError(.invalidKeyLength) }
            self.key = key
            self.nonce = nonce
        }
        
        public func encrypt(_ input: inout [UInt8], _ aad: [UInt8] = []) -> [UInt8] {
            let chacha = ChaCha20(key, nonce)
            chacha.encrypt(&input)
            var aead: [UInt8] = .zeroes(16 * ((aad.count + 15) / 16) + 16 * ((input.count + 15) / 16) + 16)
            for i in .zero..<aad.count { aead[i] = aad[i] }
            let n = 16 * ((aad.count + 15) / 16)
            for i in .zero..<input.count { aead[n + i] = input[i] }
            let m = 16 * ((input.count + 15) / 16)
            aad.count.updateBytes(&aead, offset: n + m)
            input.count.updateBytes(&aead, offset: n + m + 8)
            var poly = Poly1305(generateKey())
            return poly.computeTag(aead)
        }
        
        public func decrypt(_ input: inout [UInt8], _ tag: [UInt8], _ aad: [UInt8] = []) -> Bool {
            let n = 16 * ((aad.count + 15) / 16)
            let m = 16 * ((input.count + 15) / 16)
            var aead: [UInt8] = .zeroes(n + m + 16)
            for i in .zero..<aad.count { aead[i] = aad[i] }
            for i in .zero..<input.count { aead[n + i] = input[i] }
            aad.count.updateBytes(&aead, offset: n + m)
            input.count.updateBytes(&aead, offset: n + m + 8)
            var poly = Poly1305(generateKey())
            if poly.computeTag(aead) == tag {
                let chacha = ChaCha20(key, nonce)
                chacha.encrypt(&input)
                return true
            }
            return false
        }
        
        func generateKey() -> KernelNumerics.DoubleWords256 {
            var x: KernelNumerics.Words = .zeroes(16)
            ChaCha20(key, nonce).blockFunction(&x)
            return (
                (.init(x[1]) << 32 | .init(x[0])) & 0x0ffffffc0fffffff, (.init(x[3]) << 32 | .init(x[2])) & 0x0ffffffc0ffffffc,
                .init(x[5]) << 32 | .init(x[4]), .init(x[7]) << 32 | .init(x[6])
            )
        }
    }
}
