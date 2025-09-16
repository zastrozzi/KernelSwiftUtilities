//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 8/5/24.
//

import Foundation
import Vapor

extension KernelIdentity.Core.Model {
    public struct RefreshTokenPayload: JWTPayload {
        public var userId: UUID
        public var deviceId: UUID
        public var sessionId: UUID
        public var iat: TimeInterval
        public var exp: TimeInterval
        
        public init(userId: UUID, deviceId: UUID, sessionId: UUID, expiration: TimeInterval = 24*60*60*10) {
            let now = Date().timeIntervalSince1970
            
            self.userId = userId
            self.deviceId = deviceId
            self.sessionId = sessionId
            self.iat = now
            self.exp = now + expiration
        }
        
        public enum CodingKeys: String, CodingKey {
            case userId = "u"
            case deviceId = "d"
            case sessionId = "s"
            case iat
            case exp
        }
        
        public func verify() throws {
            let now = Date().timeIntervalSince1970
            guard exp > now else { throw Abort(.unauthorized, reason: "Token expired") }
        }
    }
}
