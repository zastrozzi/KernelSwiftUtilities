//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.EC.PublicKey {
    public init(
        pkcs8: KernelASN1.ASN1Type,
        keyFormat: KernelCryptography.EC.KeyFormat = .pkcs8
    ) throws {
        guard
            case let .sequence(pkcs8Seq)                = pkcs8,
                pkcs8Seq.count                          >= 2
        else { throw Self.decodingError(.sequence, pkcs8) }
        
        guard
            case let .sequence(pubKeyInfoSeq)           = pkcs8Seq[0],
            pubKeyInfoSeq.count                         >= 2,
            case let .objectIdentifier(pubKeyInfoType)  = pubKeyInfoSeq[0],
            let pubKeyInfoTypeOID                       = pubKeyInfoType.oid
        else { throw Self.decodingError(.sequence, pkcs8Seq[0]) }
        
        guard
            case let .bitString(pubKeyBitStr)           = pkcs8Seq[1]
        else { throw Self.decodingError(.bitString, pkcs8Seq[1]) }
        
        
        switch pubKeyInfoTypeOID {
        case .x962PublicKey:
            guard
                case let .objectIdentifier(domainID)    = pubKeyInfoSeq[1],
                let domainOID                           = domainID.oid,
                let dom: KernelNumerics.EC.Domain       = try .init(fromOID: domainOID)
            else { throw Self.decodingError(.objectIdentifier, pubKeyInfoSeq[1]) }
            let pubPoint = try dom.decode(pubKeyBitStr.value)
            self.init(domain: dom, point: pubPoint, keyFormat: keyFormat)
        default: throw Self.decodingError(.sequence, .sequence(pubKeyInfoSeq))
        }
    }
    
    public func buildASN1TypePKCS8() -> KernelASN1.ASN1Type {
        .sequence([
            .sequence([
                .objectIdentifier(.init(oid: .x962PublicKey)),
                .objectIdentifier(.init(oid: domain.oid))
            ]),
            .bitString(.init(unusedBits: 0, data: domain.encode(point)))
        ])
    }
}
