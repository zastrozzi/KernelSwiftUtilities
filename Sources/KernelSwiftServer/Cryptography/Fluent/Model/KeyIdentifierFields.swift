//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/12/2023.
//

import Vapor
import Fluent

extension KernelCryptography.Fluent.Model {
    public final class KeyIdentifierFields: Fields, @unchecked Sendable {
        @Field(key: "hex") public var hex: String
        @Field(key: "jwks") public var jwks: String
        @Field(key: "x509t") public var x509t: String
        
        public init() {}
    }
}
