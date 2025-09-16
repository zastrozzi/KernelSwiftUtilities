//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/04/2023.
//

import Foundation

public typealias JSONWebAlgorithm = Either<JSONWebSignatureAlgorithm, JSONWebEncryptionAlgorithm>

extension JSONWebAlgorithm {
    public static func signature(_ alg: JSONWebSignatureAlgorithm) -> JSONWebAlgorithm { self.left(alg) }
    public static func encryption(_ alg: JSONWebEncryptionAlgorithm) -> JSONWebAlgorithm { self.right(alg) }
    public var signature: JSONWebSignatureAlgorithm? { self.left }
    public var encryption: JSONWebEncryptionAlgorithm? { self.right }
    public func either<V>(ifSignature: (JSONWebSignatureAlgorithm) throws -> V, ifEncryption: (JSONWebEncryptionAlgorithm) throws -> V) rethrows -> V {
        try self.either(ifLeft: ifSignature, ifRight: ifEncryption)
    }
    public func `do`(ifSignature: (JSONWebSignatureAlgorithm) throws -> Void, ifEncryption: (JSONWebEncryptionAlgorithm) throws -> Void) rethrows {
        try self.do(ifLeft: ifSignature, ifRight: ifEncryption)
    }
    
//    public var secKeyAlgorithm: SecKeyAlgorithm {
//        return self.either(ifSignature: { $0.secKeyAlgorithm }, ifEncryption: { $0.secKeyAlgorithm })
//    }
}
