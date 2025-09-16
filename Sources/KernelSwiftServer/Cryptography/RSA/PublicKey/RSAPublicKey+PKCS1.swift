//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.RSA.PublicKey {
    public init(pkcs1 sequence: [KernelASN1.ASN1Type], fromPKCS8: Bool = false) throws {
        guard
            case let .integer(nInt)     = sequence[0],
            case let .integer(eInt)     = sequence[1]
        else { throw Self.decodingError(.sequence, .sequence(sequence)) }
        
        self.init(n: nInt.int, e: eInt.int, keySize: try .init(nInt.int.bitWidth), keyFormat: fromPKCS8 ? .pkcs8 : .pkcs1)
    }
    
    public func buildASN1TypePKCS1() -> KernelASN1.ASN1Type {
        return .sequence([
            .integer(.init(data: n.signedBytes(), exactLength: keySize.byteWidth)),
            .integer(.init(data: e.signedBytes(), exactLength: 3))
        ])
    }
}
