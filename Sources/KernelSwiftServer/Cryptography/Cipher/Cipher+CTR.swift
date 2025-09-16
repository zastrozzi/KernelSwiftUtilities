//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.Cipher {
    public struct CTR: CipherStrategy {
        public static let blockMode: KernelCryptography.Cipher.BlockMode = .CTR
        
        public var aes: AES
        public var macSecret: [UInt8]
        public var xor: [UInt8] = []
        public var mode: CipherMode
        
        public init(secret: [UInt8], macSecret: [UInt8], xor: [UInt8]) {
            self.init(secret, macSecret)
            self.xor = xor
        }
        
        public init(aes: AES, macSecret: [UInt8], mode: CipherMode) {
            self.aes = aes
            self.macSecret = macSecret
            self.mode = mode
        }
        
        public mutating func processBuffer(_ input: inout [UInt8], _ index: inout Int, _ remaining: inout Int) throws {
            let w = AES.encrypt(xor, aes: aes)
            let n = min(AES.val.blockSize, remaining)
            for i in .zero..<n { input[index + i] ^= w[i] }
            for i in (.zero..<xor.count).reversed() {
                if xor[i] == .max { xor[i] = .zero }
                else {
                    xor[i] += 1
                    break
                }
            }
            index += AES.val.blockSize
            remaining -= AES.val.blockSize
        }
    }
}
