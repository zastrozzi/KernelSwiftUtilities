//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.RSA {
    public struct Signature: Sendable {
        public var algorithmIdentifier: KernelCryptography.Algorithms.AlgorithmIdentifier
        public var rawBytes: [UInt8]
        
        public init(
            algorithmIdentifier: KernelCryptography.Algorithms.AlgorithmIdentifier,
            rawBytes: [UInt8]
        ) {
            self.algorithmIdentifier = algorithmIdentifier
            self.rawBytes = rawBytes
        }
        
        public var digestAlg: KernelCryptography.Algorithms.MessageDigestAlgorithm {
            switch algorithmIdentifier.algorithm {
            case .pkcs1SHA224WithRSAEncryption: .SHA2_224
            case .pkcs1SHA256WithRSAEncryption: .SHA2_256
            case .pkcs1SHA384WithRSAEncryption: .SHA2_384
            case .pkcs1SHA512WithRSAEncryption: .SHA2_512
            default: .SHA1
            }
        }
        
        public var rawRepresentation: [UInt8] { rawBytes }
    }
}

extension KernelCryptography.RSA.Signature: ASN1CompositeTypedDecodable {
    public static let compositeCount: Int = 2
    
    public init(from asn1TypeArray: [KernelASN1.ASN1Type]) throws {
        guard asn1TypeArray.count == Self.compositeCount else { throw Self.decodingError(nil, asn1TypeArray[0]) }
        let sigAlg: KernelCryptography.Algorithms.AlgorithmIdentifier = try .init(from: asn1TypeArray[0])
        guard case let .bitString(asn1BitString) = asn1TypeArray[1] else { throw Self.decodingError(.bitString, asn1TypeArray[1]) }
        self.algorithmIdentifier = sigAlg
        self.rawBytes = asn1BitString.value
    }
}

extension KernelCryptography.RSA.Signature: ASN1ArrayBuildable {
    public func buildASN1TypeArray() -> [KernelASN1.ASN1Type] {
        [
            algorithmIdentifier.buildASN1Type(),
            .bitString(.init(unusedBits: 0, data: rawBytes))
        ]
    }
    
    public func signatureBytes() -> [UInt8] {
        rawBytes
    }
    
    public func signatureBitString() -> KernelASN1.ASN1Type {
        .bitString(.init(unusedBits: 0, data: rawBytes))
    }
    
    public func serialisedSignatureBitString() -> [UInt8] {
        KernelASN1.ASN1Writer.dataFromObject(.bitString(.init(unusedBits: 0, data: signatureBytes())))
    }
}
