//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.Cipher {
    public struct ECB: CipherStrategy {
        public static let blockMode: KernelCryptography.Cipher.BlockMode = .ECB
        
        public var aes: AES
        public var macSecret: [UInt8]
        public var mode: CipherMode
        
        public init(secret: [UInt8], macSecret: [UInt8]) {
            self.init(secret, macSecret)
        }
        
        public init(aes: AES, macSecret: [UInt8], mode: CipherMode) {
            self.aes = aes
            self.macSecret = macSecret
            self.mode = mode
        }
        
        public mutating func processBuffer(_ input: inout [UInt8], _ index: inout Int, _ remaining: inout Int) throws {
            var b: [UInt8] = .zeroes(AES.val.blockSize)
            if mode == .encryption {
                if remaining < AES.val.blockSize {
                    let padByte: UInt8 = .init(AES.val.blockSize - remaining)
                    input.append(contentsOf: [UInt8].fill(AES.val.blockSize - remaining, with: padByte))
                }
                b[.zero..<AES.val.blockSize] = input[index..<(index + AES.val.blockSize)]
                b = AES.encrypt(b, aes: aes)
                input[index..<(index + AES.val.blockSize)] = b[.zero..<AES.val.blockSize]
                index += AES.val.blockSize
                remaining -= AES.val.blockSize
            } 
            else {
                if remaining < AES.val.blockSize { throw KernelCryptography.TypedError(.invalidAESBufferLength) }
                b[.zero..<AES.val.blockSize] = input[index..<(index + AES.val.blockSize)]
                b = AES.decrypt(b, aes: &aes)
                input[index..<(index + AES.val.blockSize)] = b[.zero..<AES.val.blockSize]
                index += AES.val.blockSize
                remaining -= AES.val.blockSize
                if remaining <= .zero {
                    let padCount: Int = .init(input[index - 1])
                    if padCount > AES.val.blockSize { throw KernelCryptography.TypedError(.invalidAESBufferLength) }
                    for i in .zero..<padCount {
                        if input[index - 1 - i] != padCount { throw KernelCryptography.TypedError(.invalidAESBufferLength) }
                    }
                    remaining -= padCount
                }
            }
        }
        
        public mutating func normalise(_ input: inout [UInt8], _ remaining: Int) {
            input.removeLast(-remaining)
        }
    }
}

