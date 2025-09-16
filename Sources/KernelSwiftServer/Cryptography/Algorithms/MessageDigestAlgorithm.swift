//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.Algorithms {
    public typealias MessageDigestAlgorithm = KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm
}


extension KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm {
    public var signatureMode: KernelCryptography.RSA.SignatureMode {
        switch self {
        case .SHA1: .pkcs1
        case .SHA2_224: .pss
        case .SHA2_256: .pss
        case .SHA2_384: .pss
        case .SHA2_512: .pss
        case .SHA3_224: .pkcs1
        case .SHA3_256: .pkcs1
        case .SHA3_384: .pkcs1
        case .SHA3_512: .pkcs1
        }
    }

    
    public var digestInfoOIDSize: Int {
        let oid: KernelASN1.ASN1Type = .objectIdentifier(.init(oid: objectIdentifier))
        let bytes = KernelASN1.ASN1Writer.dataFromObject(oid)
        return bytes.count
    }
}

