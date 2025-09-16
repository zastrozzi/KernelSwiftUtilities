//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/11/2023.
//

import Foundation

extension KernelSwiftCommon.Cryptography.Algorithms {
    public enum MessageDigestAlgorithm: String, Codable, Equatable, CaseIterable, Sendable {
        case SHA1
        case SHA2_224
        case SHA2_256
        case SHA2_384
        case SHA2_512
        case SHA3_224
        case SHA3_256
        case SHA3_384
        case SHA3_512
        // MD5?
    }
}

extension KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm {
    public var objectIdentifier: KernelSwiftCommon.ObjectID {
        switch self {
        case .SHA1: .sha1
        case .SHA2_224: .sha224
        case .SHA2_256: .sha256
        case .SHA2_384: .sha384
        case .SHA2_512: .sha512
        case .SHA3_224: .sha3_224
        case .SHA3_256: .sha3_256
        case .SHA3_384: .sha3_384
        case .SHA3_512: .sha3_512
        }
    }
    
    public static let allPSS: [Self] = [
        .SHA2_224,
        .SHA2_256,
        .SHA2_384,
        .SHA2_512
    ]
    
    public static let allPKCS1: [Self] = [
        .SHA1,
        .SHA3_224,
        .SHA3_256,
        .SHA3_384,
        .SHA3_512
    ]
    
    public var digestStorageWidth: KernelSwiftCommon.Cryptography.MD.DigestStorageWidth {
        switch self {
        case .SHA1, .SHA2_224, .SHA2_256: .word
        case .SHA2_384, .SHA2_512, .SHA3_224, .SHA3_256, .SHA3_384, .SHA3_512: .doubleWord
        }
    }
    
    
    public var digestStorageSize: Int {
        switch self {
        case .SHA1: 5
        case .SHA2_224, .SHA2_256, .SHA2_384, .SHA2_512: 8
        case .SHA3_224, .SHA3_256, .SHA3_384, .SHA3_512: 25
        }
    }
    
    public var digestStorageBytes: Int { digestStorageWidth.byteWidth * digestStorageSize }
}
