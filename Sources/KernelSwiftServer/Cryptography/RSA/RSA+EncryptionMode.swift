//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/10/2023.
//

import Foundation

extension KernelCryptography.RSA {
    public enum EncryptionMode {
        case pkcs1
        case oaep(algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm)
    }
}

extension KernelCryptography.RSA.EncryptionMode {
    public func maximumMessageSize(for keySize: KernelCryptography.RSA.KeySize) -> Int {
        switch self {
        case .pkcs1: maximumPKCS1MessageSize(for: keySize)
        case let .oaep(algorithm): maximumOAEPMessageSize(for: keySize, algorithm: algorithm)
        }
    }
    
    public func maximumPKCS1MessageSize(for keySize: KernelCryptography.RSA.KeySize) -> Int {
        keySize.byteWidth - 11
    }
    
    public func maximumOAEPMessageSize(
        for keySize: KernelCryptography.RSA.KeySize,
        algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm
    ) -> Int {
        max(keySize.byteWidth - 2 * algorithm.outputSizeBytes - 2, .zero)
    }
}
