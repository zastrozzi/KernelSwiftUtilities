//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/12/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelCryptography.Fluent.Model {
    public final class AlgorithmIdentifier: Fields, @unchecked Sendable {
        @KernelEnum(key: "id") public var algorithm: KernelASN1.ASN1AlgorithmIdentifier
        @Group(key: "params") public var parameters: AlgorithmIdentifierParameters
        
        public init() {}
        
        public static func createFields(from algIdent: KernelCryptography.Algorithms.AlgorithmIdentifier) -> Self {
            let fields: Self = .init()
            fields.algorithm = algIdent.algorithm
            if case let .objectIdentifier(curveOID) = algIdent.parameters {
                fields.parameters.curve = curveOID.oid
            }
            return fields
        }
    }
}

extension KernelCryptography.Fluent.Model {
    public final class AlgorithmIdentifierParameters: Fields, @unchecked Sendable {
        @OptionalEnum(key: "curve") public var curve: KernelSwiftCommon.ObjectID?
        
        public init() {}
    }
}
