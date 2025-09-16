//
//  File.swift
//
//
//  Created by Jonathan Forbes on 13/10/2023.
//

import Foundation

extension KernelCryptography.RSA {
    public enum SignatureMode {
        case pkcs1
        case pss
    }
}

//extension KernelCryptography.RSA.SignatureMode {
//    public func maximumMessageSize(
//        for keySize: KernelCryptography.RSA.KeySize,
//        algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm
//    ) -> Int {
//        switch self {
//        case .pkcs1: maximumPKCS1MessageSize(for: keySize, algorithm: algorithm)
//        case .pss: maximumPSSMessageSize(for: keySize, algorithm: algorithm)
//        }
//    }
//    
//    public func maximumPKCS1MessageSize(
//        for keySize: KernelCryptography.RSA.KeySize,
//        algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm
//    ) -> Int {
//        keySize.byteWidth - 11
//    }
//    
//    public func maximumPSSMessageSize(
//        for keySize: KernelCryptography.RSA.KeySize,
//        algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm
//    ) -> Int {
//        max(keySize.byteWidth - 2 * algorithm.outputSizeBytes - 2, .zero)
//    }
//}
