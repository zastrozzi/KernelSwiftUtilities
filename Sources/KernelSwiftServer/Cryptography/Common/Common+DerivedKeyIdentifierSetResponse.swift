//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/10/2023.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension KernelCryptography.Common {
    public struct DerivedKeyIdentifierSetResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public init(
            skid: String,
            jwks: String,
            x509t: String
        ) {
            self.skid = skid
            self.jwks = jwks
            self.x509t = x509t
        }
        
        public var skid: String
        public var jwks: String
        public var x509t: String
    }
}
