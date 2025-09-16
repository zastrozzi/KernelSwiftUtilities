//
//  File.swift
//
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.RSA.PrivateKey {
    public init(
        pkcs8 sequence: [KernelASN1.ASN1Type],
        keyFormat: KernelCryptography.RSA.KeyFormat = .pkcs8
    ) throws {
        guard
            case let .integer(version)              = sequence[0],
            version.int                             == .zero,
            case let .sequence(privateKeyAlgSeq)    = sequence[1],
            !privateKeyAlgSeq.isEmpty,
            case let .objectIdentifier(algIdent)    = privateKeyAlgSeq[0],
            let algOID                              = algIdent.oid,
            algOID                                  == .pkcs1RSAEncryption,
            case let .octetString(privateKeyOctet)  = sequence[2],
            let privateKey                          = try? KernelASN1.ASN1Parser4.objectFromBytes(privateKeyOctet.value),
            case let .sequence(privateKeySeq)       = privateKey.asn1(),
            privateKeySeq.count                     >= 9
        else { throw Self.decodingError(.sequence, .sequence(sequence)) }
        try self.init(pkcs1: privateKeySeq, keyFormat: keyFormat)
    }
    
    public func buildASN1TypePKCS8() -> KernelASN1.ASN1Type {
        .sequence([
            .integer(.init(data: [0x00])),
            .sequence([
                .objectIdentifier(.init(oid: .pkcs1RSAEncryption)),
                .null(.init())
            ]),
            .octetString(.init(data: KernelASN1.ASN1Writer.dataFromObject(buildASN1TypePKCS1())))
        ])
    }
}
