//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/10/2023.
//

import Foundation
import Vapor

extension KernelCryptography.EC {
    public enum KeyFormat: Sendable, Equatable, Hashable {
        case json
        case pkcs1
        case pkcs8
        case pkcs8Encrypted(password: [UInt8]?, aes: KernelCryptography.AES.KeySize?)
    }
}

extension KernelCryptography.EC.KeyFormat {
    public var privateKeyPEMFormat: KernelASN1.PEMFile.Format {
        switch self {
        case .json: .privateKey
        case .pkcs1: .ecPrivateKey
        case .pkcs8: .privateKey
        case .pkcs8Encrypted: .encryptedPrivateKey
        }
    }
    
    public var publicKeyPEMFormat: KernelASN1.PEMFile.Format { .publicKey }
    
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
