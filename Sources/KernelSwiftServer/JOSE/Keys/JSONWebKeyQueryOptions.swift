//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/04/2023.
//

import Foundation

public struct JSONWebKeyQueryOptions: Codable, Equatable {
    public var action: JSONWebKeyAction
    public var alg: JSONWebAlgorithm
    public var kid: String?
    public var crv: JSONWebEllipticCurve?
    
    public init(
        action: JSONWebKeyAction,
        alg: JSONWebAlgorithm,
        kid: String? = nil,
        crv: JSONWebEllipticCurve? = nil
    ) {
        self.action = action
        self.alg = alg
        self.kid = kid
        self.crv = crv
    }
}
