//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.RSA.PublicKey {
    public init(pkcs8 sequence: [KernelASN1.ASN1Type]) throws {
        guard
            case let .sequence(publicKeyAlgSeq)     = sequence[0],
            !publicKeyAlgSeq.isEmpty,
            case let .objectIdentifier(algIdent)    = publicKeyAlgSeq[0],
            let algOID                              = algIdent.oid,
            algOID                                  == .pkcs1RSAEncryption,
            case let .bitString(publicKeyBytes)     = sequence[1],
            let publicKey                           = try? KernelASN1.ASN1Parser4.objectFromBytes(publicKeyBytes.value),
            case let .sequence(publicKeySeq)        = publicKey.asn1(),
            publicKeySeq.count                      >= 2
        else { throw Self.decodingError(.sequence, .sequence(sequence)) }
        try self.init(pkcs1: publicKeySeq, fromPKCS8: true)
    }
    
    public func buildASN1TypePKCS8() -> KernelASN1.ASN1Type {
        .sequence([
            .sequence([
                .objectIdentifier(.init(oid: .pkcs1RSAEncryption)),
                .null(.init())
            ]),
            .bitString(.init(unusedBits: 0, data: KernelASN1.ASN1Writer.dataFromObject(buildASN1TypePKCS1())))
        ])
    }
}
