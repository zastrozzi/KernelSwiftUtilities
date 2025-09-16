//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/04/2023.
//

import Foundation

public struct JWKAlgorithmQueryOptions: Codable, Equatable {
    public var kid: String?
    public var use: JWKPublicKeyUse?
    public var alg: JWKAlgorithm?
    public var crv: JWKEllipticCurveAlgorithm?
    
}
