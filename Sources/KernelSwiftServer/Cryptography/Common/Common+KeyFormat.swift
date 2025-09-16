//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/12/2023.
//

import Foundation
import Vapor

extension KernelCryptography.Common {
    public enum KeyFormat: Sendable, Equatable, Hashable {
        case json
        case pkcs1
        case pkcs8
        case pkcs8Encrypted(aes: KernelCryptography.AES.KeySize?)
    }
}

extension KernelCryptography.Common.KeyFormat {
    public func privateKeyPEMFormat(for keyType: KernelCryptography.Common.KeyType) -> KernelASN1.PEMFile.Format {
        switch keyType {
        case .ec:
            switch self {
            case .json: .privateKey
            case .pkcs1: .ecPrivateKey
            case .pkcs8: .privateKey
            case .pkcs8Encrypted: .encryptedPrivateKey
            }
        case .rsa:
            switch self {
            case .json: .rsaPrivateKey
            case .pkcs1: .rsaPrivateKey
            case .pkcs8: .privateKey
            case .pkcs8Encrypted: .encryptedPrivateKey
            }
        }
        
    }
    
    public func publicKeyPEMFormat(for keyType: KernelCryptography.Common.KeyType) -> KernelASN1.PEMFile.Format {
        switch keyType {
        case .ec: .publicKey
        case .rsa:
            switch self {
            case .json: .rsaPublicKey
            case .pkcs1: .rsaPublicKey
            case .pkcs8: .publicKey
            case .pkcs8Encrypted: .publicKey
            }
        }
    }
    
    public init(from mediaType: HTTPMediaType) {
        switch mediaType {
        case .json: self = .json
        case .pemFile: self = .pkcs1
        case .pkcs8: self = .pkcs8
        case .pkcs8Encrypted: self = .pkcs8Encrypted(aes: nil)
        default: self = .pkcs8
        }
    }
}
