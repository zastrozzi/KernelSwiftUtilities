//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/04/2023.
//

import Foundation

public struct JWKEncryptionAlgorithmQueryOptions: Codable, Equatable {
    public var kid: String?
    public var alg: JWKEncryptionAlgorithm
    public var epk: JWKEllipticCurveAlgorithm
    
    public init(
        kid: String,
        alg: JWKEncryptionAlgorithm,
        epk: JWKEllipticCurveAlgorithm
    ) {
        self.kid = kid
        self.alg = alg
        self.epk = epk
    }
    
}
