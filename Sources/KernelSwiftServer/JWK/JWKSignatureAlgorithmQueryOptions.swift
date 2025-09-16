//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/04/2023.
//

import Foundation

public struct JWKSignatureAlgorithmQueryOptions: Codable, Equatable {
    public var alg: JSONWebSignatureAlgorithm
    public var kid: String
    
    public init(
        alg: JSONWebSignatureAlgorithm,
        kid: String
    ) {
        self.alg = alg
        self.kid = kid
    }
    
}
