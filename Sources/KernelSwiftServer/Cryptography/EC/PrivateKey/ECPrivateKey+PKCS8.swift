//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import KernelSwiftCommon

extension KernelCryptography.EC.PrivateKey {
    public init(
        pkcs8 sequence: [KernelASN1.ASN1Type],
        keyFormat: KernelCryptography.EC.KeyFormat = .pkcs8
    ) throws {
        guard
            case let .integer(version)              = sequence[0],
            version.int                             == .zero,
            case let .sequence(privKeyAlgSeq)       = sequence[1],
            !privKeyAlgSeq.isEmpty,
            case let .objectIdentifier(algTypeId)   = privKeyAlgSeq[0],
            let algTypeOID                          = algTypeId.oid
        else { throw Self.decodingError(.sequence, .sequence(sequence)) }
        
        switch algTypeOID {
        case .x962ECDSAWithSpecified:
            guard
                case let .octetString(privKeyOctStr)    = sequence[2],
                let privateKey                          = try? KernelASN1.ASN1Parser4.objectFromBytes(privKeyOctStr.value),
                case let .sequence(privateKeySeq)       = privateKey.asn1(),
                privateKeySeq.count                     >= 2
            else { throw Self.decodingError(.sequence, .sequence(sequence)) }
            try self.init(pkcs1: privateKeySeq, keyFormat: keyFormat)
        case .x962PublicKey:
            guard
                case let .objectIdentifier(domainId)    = privKeyAlgSeq[1],
                let domainOID                           = domainId.oid,
                case let .octetString(privKeyOctStr)    = sequence[2],
                let privateKey                          = try? KernelASN1.ASN1Parser4.objectFromBytes(privKeyOctStr.value),
                case let .sequence(privateKeySeq)       = privateKey.asn1(),
                privateKeySeq.count                     >= 2
            else { throw Self.decodingError(.sequence, .sequence(sequence)) }
            try self.init(pkcs1: privateKeySeq, domainOID: domainOID, keyFormat: keyFormat)
        default: throw Self.decodingError(.sequence, .sequence(sequence))
        }
    }
    
    public func buildASN1TypePKCS8(pkcs8Domain: Bool = true) -> KernelASN1.ASN1Type {
        let keyTypeSequence: KernelASN1.ASN1Type = pkcs8Domain ?
            .sequence([
                .objectIdentifier(.init(oid: .x962PublicKey)),
                .objectIdentifier(.init(oid: domain.oid))
            ]) :
            .sequence([.objectIdentifier(.init(oid: .x962ECDSAWithSpecified))])
        
        return .sequence([
            .integer(.init(data: [0x00])),
            keyTypeSequence,
            .octetString(.init(data: KernelASN1.ASN1Writer.dataFromObject(buildASN1TypePKCS1(skipDomain: pkcs8Domain))))
        ])
    }
}
