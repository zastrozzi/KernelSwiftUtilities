//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/04/2023.
//

import Foundation

public struct JWKSignatureHeader {
    public var alg: JSONWebSignatureAlgorithm?
    public var b64: Bool?
    public var crit: [String]?
    public var cty: String?
    public var jku: String?
    public var jwk: String?
}
