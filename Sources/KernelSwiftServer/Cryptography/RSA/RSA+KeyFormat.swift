//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/10/2023.
//

import Foundation
import Vapor

extension KernelCryptography.RSA {
    public enum KeyFormat: Sendable, Equatable, Hashable {
        case json
        case pkcs1
        case pkcs8
        case pkcs8Encrypted(password: [UInt8]?, aes: KernelCryptography.AES.KeySize?)
    }
}

extension KernelCryptography.RSA.KeyFormat {
    public var privateKeyPEMFormat: KernelASN1.PEMFile.Format {
        switch self {
        case .json: .rsaPrivateKey
        case .pkcs1: .rsaPrivateKey
        case .pkcs8: .privateKey
        case .pkcs8Encrypted: .encryptedPrivateKey
        }
    }
    
    public var publicKeyPEMFormat: KernelASN1.PEMFile.Format {
        switch self {
        case .json: .rsaPublicKey
        case .pkcs1: .rsaPublicKey
        case .pkcs8: .publicKey
        case .pkcs8Encrypted: .publicKey
        }
    }
    
    public init(from mediaType: HTTPMediaType) {
        switch mediaType {
        case .json: self = .json
        case .pemFile: self = .pkcs1
        case .pkcs8: self = .pkcs8
        case .pkcs8Encrypted: self = .pkcs8Encrypted(password: nil, aes: nil)
        default: self = .pkcs8
        }
    }
}
