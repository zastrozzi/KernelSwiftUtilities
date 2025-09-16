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
        pkcs1 sequence: [KernelASN1.ASN1Type],
        keyFormat: KernelCryptography.RSA.KeyFormat = .pkcs1
    ) throws {
        guard
            case let .integer(version)  = sequence[0],
            case let .integer(nInt)     = sequence[1],
            case let .integer(eInt)     = sequence[2],
            case let .integer(dInt)     = sequence[3],
            case let .integer(pInt)     = sequence[4],
            case let .integer(qInt)     = sequence[5],
            case let .integer(dpInt)    = sequence[6],
            case let .integer(dqInt)    = sequence[7]
                //            case let .integer(coefInt)  = sequence[8]
        else { throw Self.decodingError(.sequence, .sequence(sequence)) }
        
        guard version.int == .zero else { throw KernelCryptography.TypedError(.decodingRSAPrivateKeyFailed) }
        guard nInt.int == pInt.int * qInt.int else { throw KernelCryptography.TypedError(.decodingRSAPrivateKeyFailed) }
        guard dpInt.int == (dInt.int % (pInt.int - 1)) else { throw KernelCryptography.TypedError(.decodingRSAPrivateKeyFailed) }
        guard dqInt.int == (dInt.int % (qInt.int - 1)) else { throw KernelCryptography.TypedError(.decodingRSAPrivateKeyFailed) }
        //        guard coefInt.int == qInt.int.modInverse(pInt.int) else { throw KernelCryptography.TypedError(.decodingRSAPrivateKeyFailed) }
        self.init(
            n: nInt.int,
            e: eInt.int,
            d: dInt.int,
            p: pInt.int,
            q: qInt.int,
            keySize: try .init(nInt.int.bitWidth),
            keyFormat: keyFormat
        )
    }
    
    public func buildASN1TypePKCS1() -> KernelASN1.ASN1Type {
        let coefficient = q.modInverse(p)
        return .sequence([
            .integer(.init(data: [0x00])),
            .integer(.init(data: Array(n.signedBytes()), exactLength: keySize.byteWidth)),
            .integer(.init(data: Array(e.signedBytes()), exactLength: 3)),
            .integer(.init(data: Array(d.signedBytes()), exactLength: keySize.byteWidth)),
            .integer(.init(data: Array(p.signedBytes()), exactLength: keySize.byteWidth / 2)),
            .integer(.init(data: Array(q.signedBytes()), exactLength: keySize.byteWidth / 2)),
            .integer(.init(data: Array((d % (p - 1)).signedBytes()), exactLength: keySize.byteWidth / 2)),
            .integer(.init(data: Array((d % (q - 1)).signedBytes()), exactLength: keySize.byteWidth / 2)),
            .integer(.init(data: Array(coefficient.signedBytes()), exactLength: keySize.byteWidth / 2))
        ])
    }
}
