//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/10/2022.
//

import Foundation
import KernelSwiftCommon

public struct AuthJWTHeader: Codable {
    public var typ: String?
    public var alg: String?
    public var jku : String?
    public var jwk: String?
    public var kid: String?
    public var x5u: String?
    public var x5c: [String]?
    public var x5t: String?
    public var x5tS256: String?
    public var cty: String?
    public var crit: [String]?

    public init(
        typ: String? = "JWT",
        alg: String? = nil,
        jku: String? = nil,
        jwk: String? = nil,
        kid: String? = nil,
        x5u: String? = nil,
        x5c: [String]? = nil,
        x5t: String? = nil,
        x5tS256: String? = nil,
        cty: String? = nil,
        crit: [String]? = nil
    ) {
        self.typ = typ
        self.alg = alg
        self.jku = jku
        self.jwk = jwk
        self.kid = kid
        self.x5u = x5u
        self.x5c = x5c
        self.x5t = x5t
        self.x5tS256 = x5tS256
        self.cty = cty
        self.crit = crit
    }
}
