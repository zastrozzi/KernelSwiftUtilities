//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 8/5/24.
//

import Foundation
import Vapor

extension KernelIdentity.Core.Model {
    public struct PasswordResetTokenPayload: JWTPayload {
        public var userId: UUID
        public var iat: TimeInterval
        public var exp: TimeInterval
        
        public init(userId: UUID, expiration: TimeInterval = 24*60*60) {
            let now = Date().timeIntervalSince1970
            
            self.userId = userId
            self.iat = now
            self.exp = now + expiration
        }
        
        public enum CodingKeys: String, CodingKey {
            case userId = "u"
            case iat
            case exp
        }
        
        public func verify() throws {
            let now = Date().timeIntervalSince1970
            guard exp > now else { throw Abort(.unauthorized, reason: "Token expired") }
        }
    }
}

