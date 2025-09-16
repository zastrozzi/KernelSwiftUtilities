//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/12/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelX509.Fluent.Model {
    public final class PublicKeyFields: Fields, @unchecked Sendable {
        @Group(key: "alg") public var keyAlgorithm: KernelCryptography.Fluent.Model.AlgorithmIdentifier
        @ASN1Field(key: "key") public var underlyingKey: KernelX509.Certificate.PublicKey.UnderlyingKey
        @OptionalGroupParent(key: "db_id") public var publicKey: KernelCryptography.Fluent.Model.PublicKey?
        
        public init() {}
        
        public static func createFields(from dto: KernelX509.Certificate.PublicKey) -> Self {
            let fields: Self = .init()
            fields.keyAlgorithm = .createFields(from: dto.keyAlgorithm)
            fields.underlyingKey = dto.underlyingKey
            return fields
        }
    }
}
