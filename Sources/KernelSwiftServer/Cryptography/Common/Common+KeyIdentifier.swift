//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/10/2023.
//

import Foundation

extension KernelCryptography.Common {
    public enum KeyIdentifier {
        case db(UUID)
        case jwks(String)
        case skid(String)
        case x509t(String)
        
        public var asString: String {
            switch self {
            case let .db(db): db.uuidString
            case let .jwks(jwks): jwks
            case let .skid(skid): skid
            case let .x509t(x509t): x509t
            }
        }
    }
}
