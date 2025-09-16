//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.EC {
    public struct Signature: Sendable {
        public var algorithmIdentifier: KernelCryptography.Algorithms.AlgorithmIdentifier
        public var r: KernelNumerics.BigInt
        public var s: KernelNumerics.BigInt
        
        public init(
            algorithmIdentifier: KernelCryptography.Algorithms.AlgorithmIdentifier,
            r: KernelNumerics.BigInt,
            s: KernelNumerics.BigInt
        ) {
            self.algorithmIdentifier = algorithmIdentifier
            self.r = r
            self.s = s
        }
        
        public var digestAlg: KernelCryptography.Algorithms.MessageDigestAlgorithm {
            switch algorithmIdentifier.algorithm {
            case .x962ECDSAWithSHA1: .SHA1
            case .x962ECDSAWithSHA224: .SHA2_224
            case .x962ECDSAWithSHA256: .SHA2_256
            case .x962ECDSAWithSHA384: .SHA2_384
            case .x962ECDSAWithSHA512: .SHA2_512
            default: .SHA1
            }
        }
//
//        public init(_ signature: P256.Signing.ECDSASignature) throws {
//            let sigBytes: [UInt8] = .init(signature.derRepresentation)
//            let sigParsed = try KernelASN1.ASN1Parser4.objectFromBytes(sigBytes)
//            try self.init(from: sigParsed.asn1())
//        }
//        
//        public init(_ signature: P384.Signing.ECDSASignature) throws {
//            let sigBytes: [UInt8] = .init(signature.derRepresentation)
//            let sigParsed = try KernelASN1.ASN1Parser4.objectFromBytes(sigBytes)
//            try self.init(from: sigParsed.asn1())
//        }
//        
//        public init(_ signature: P521.Signing.ECDSASignature) throws {
//            let sigBytes: [UInt8] = .init(signature.derRepresentation)
//            let sigParsed = try KernelASN1.ASN1Parser4.objectFromBytes(sigBytes)
//            try self.init(from: sigParsed.asn1())
//        }
    }
}

extension KernelCryptography.EC.Signature: ASN1CompositeTypedDecodable {
    public static let compositeCount: Int = 2
    
    public init(from asn1TypeArray: [KernelASN1.ASN1Type]) throws {
        guard asn1TypeArray.count == Self.compositeCount else { throw Self.decodingError(nil, asn1TypeArray[0]) }
//        let sigAlg: KernelCryptography.Algorithms.AlgorithmIdentifier = try .init(from: asn1TypeArray[0])
//        guard case let .bitString(asn1BitString) = asn1TypeArray[1] else { throw Self.decodingError(.bitString, asn1TypeArray[1]) }
        
        var asn1Type = asn1TypeArray[1]
        if case let .bitString(bitString) = asn1Type {
            let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(bitString.value)
            asn1Type = parsed.asn1()
        }
        
        guard case let .sequence(sequenceItems) = asn1Type, sequenceItems.count == 2 else { throw Self.decodingError(.sequence, asn1Type) }
        guard case let .integer(rInteger) = sequenceItems[0] else { throw Self.decodingError(.integer, sequenceItems[0]) }
        guard case let .integer(sInteger) = sequenceItems[1] else { throw Self.decodingError(.integer, sequenceItems[1]) }
        r = rInteger.int
        s = sInteger.int
        let combinedCoordinateLength = r.magnitudeBytes().count + s.magnitudeBytes().count
        switch combinedCoordinateLength {
        case 0...40: algorithmIdentifier = .init(algorithm: .x962ECDSAWithSHA1)
        case 41...56: algorithmIdentifier = .init(algorithm: .x962ECDSAWithSHA224)
        case 57...64: algorithmIdentifier = .init(algorithm: .x962ECDSAWithSHA256)
        case 65...96: algorithmIdentifier = .init(algorithm: .x962ECDSAWithSHA384)
        case 97...132: algorithmIdentifier = .init(algorithm: .x962ECDSAWithSHA512)
        default: throw Self.decodingError(.sequence, asn1Type)
        }
    }
    
    public init(from decoder: Decoder) throws {
        preconditionFailure("Decoder not implemented")
    }
    
    public var rawRepresentation: [UInt8] {
        let coordinateByteCount: Int = switch algorithmIdentifier.algorithm {
        case .x962ECDSAWithSHA1: 20
        case .x962ECDSAWithSHA224: 28
        case .x962ECDSAWithSHA256: 32
        case .x962ECDSAWithSHA384: 48
        case .x962ECDSAWithSHA512: 66
        default: 0
        }
        
        return paddedCoordinateBytes(coordinateByteCount)
    }
    
    public func paddedCoordinateBytes(_ byteCount: Int) -> [UInt8] {
        var rBytes: [UInt8] = .init(r.magnitudeBytes())
        let rPadding = byteCount - rBytes.count
        if rPadding > .zero { rBytes.prepend(.zeroes(rPadding)) }
        var sBytes: [UInt8] = .init(s.magnitudeBytes())
        let sPadding = byteCount - sBytes.count
        if sPadding > .zero { sBytes.prepend(.zeroes(sPadding)) }
        rBytes.append(contentsOf: sBytes)
        return rBytes
    }
}

extension KernelCryptography.EC.Signature: ASN1ArrayBuildable {
    public func buildASN1TypeArray() -> [KernelASN1.ASN1Type] {
        [
            algorithmIdentifier.buildASN1Type(),
            signatureBitString()
        ]
    }
    
    public func signatureBytes() -> [UInt8] {
        return KernelASN1.ASN1Writer.dataFromObject(
            .sequence([
                .integer(.init(int: r)),
                .integer(.init(int: s))
            ])
        )
    }
    
    public func signatureBitString() -> KernelASN1.ASN1Type {
        .bitString(.init(unusedBits: 0, data: signatureBytes()))
    }
    
    public func serialisedSignatureBitString() -> [UInt8] {
        return KernelASN1.ASN1Writer.dataFromObject(
            .bitString(.init(unusedBits: 0, data: signatureBytes()))
        )
    }
}
