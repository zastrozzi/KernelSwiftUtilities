//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/10/2023.
//

import Foundation

extension KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm {
    public var outputSizeBytes: Int {
        switch self {
        case .SHA1: 20
        case .SHA2_224, .SHA3_224: 28
        case .SHA2_256, .SHA3_256: 32
        case .SHA2_384, .SHA3_384: 48
        case .SHA2_512, .SHA3_512: 64
        }
    }
    
    public var blockSizeBytes: Int {
        switch self {
        case .SHA1, .SHA2_224, .SHA2_256: 64
        case .SHA2_384, .SHA2_512: 128
        case .SHA3_224: 144
        case .SHA3_256: 136
        case .SHA3_384: 104
        case .SHA3_512: 72
        }
    }
    
    public var digestWordsCount: Int {
        switch self {
        case .SHA1: 5
        case .SHA2_224, .SHA2_256: 8
        default: 0
        }
    }
    
    public var digestLongsCount: Int {
        switch self {
        case .SHA2_384, .SHA2_512: 8
        default: 0
        }
    }
    
    public var digestCustomisationBytesCount: Int {
        switch self {
        case .SHA3_224, .SHA3_256, .SHA3_384, .SHA3_512: 200
        default: 0
        }
    }
    
    public var usesKeccak: Bool {
        switch self {
        case .SHA3_224, .SHA3_256, .SHA3_384, .SHA3_512: true
        default: false
        }
    }
}

