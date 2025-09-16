//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.RSA {
    public struct PrivateKey: Sendable, Hashable, Equatable {
        public let n: KernelNumerics.BigInt
        public let e: KernelNumerics.BigInt
        public let d: KernelNumerics.BigInt
        public let p: KernelNumerics.BigInt
        public let q: KernelNumerics.BigInt
        public let dp: KernelNumerics.BigInt
        public let dq: KernelNumerics.BigInt
        public let keySize: KeySize
        public let keyFormat: KeyFormat
        
        public init(
            n: KernelNumerics.BigInt,
            e: KernelNumerics.BigInt,
            d: KernelNumerics.BigInt,
            p: KernelNumerics.BigInt,
            q: KernelNumerics.BigInt,
            dp: KernelNumerics.BigInt,
            dq: KernelNumerics.BigInt,
            keySize: KeySize,
            keyFormat: KeyFormat
        ) {
            self.n = n
            self.e = e
            self.d = d
            self.p = p
            self.q = q
            self.dp = dp
            self.dq = dq
            self.keySize = keySize
            self.keyFormat = keyFormat
        }
        
        public init(
            n: KernelNumerics.BigInt,
            e: KernelNumerics.BigInt,
            d: KernelNumerics.BigInt,
            p: KernelNumerics.BigInt,
            q: KernelNumerics.BigInt,
            keySize: KeySize,
            keyFormat: KeyFormat
        ) {
            self.n = n
            self.e = e
            self.d = d
            self.p = p
            self.q = q
            self.dp = d % (p - 1)
            self.dq = d % (q - 1)
            self.keySize = keySize
            self.keyFormat = keyFormat
        }
    }
}

extension KernelCryptography.RSA.PrivateKey: ASN1Decodable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .sequence(sequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
        switch sequenceItems.count {
        case 3...4: try self.init(pkcs8: sequenceItems)
        case 9...: try self.init(pkcs1: sequenceItems)
        default: throw Self.decodingError(.sequence, asn1Type)
        }
    }
    
    public init(sequence: [KernelASN1.ASN1Type], keyFormat: KernelCryptography.RSA.KeyFormat) throws {
        switch keyFormat {
        case .json: try self.init(pkcs1: sequence)
        case .pkcs1: try self.init(pkcs1: sequence)
        case .pkcs8: try self.init(pkcs8: sequence)
        case let .pkcs8Encrypted(password, _): try self.init(pkcs8Encrypted: .sequence(sequence), password: password ?? [])
        }
    }
}

extension KernelCryptography.RSA.PrivateKey: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        switch keyFormat {
        case .json: buildASN1TypePKCS1()
        case .pkcs1: buildASN1TypePKCS1()
        case .pkcs8: buildASN1TypePKCS8()
        case let .pkcs8Encrypted(password, aes): buildEncryptedPKCS8(password: password ?? [], aes: aes ?? .b128)
        }
    }
}
