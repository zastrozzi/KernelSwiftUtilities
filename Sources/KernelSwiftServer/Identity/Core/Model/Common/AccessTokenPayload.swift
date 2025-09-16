//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 7/5/24.
//

import Foundation
import Vapor

extension KernelIdentity.Core.Model {
    public struct AccessTokenPayload: JWTPayload, Sendable {
        public var userId: UUID
        public var deviceId: UUID
        public var sessionId: UUID
        public var roles: String
        public var platformRole: PlatformUserRole
        public var status: Int
        public var iat: TimeInterval
        public var exp: TimeInterval
        
        public init(userId: UUID, deviceId: UUID, sessionId: UUID, roles: String, platformRole: PlatformUserRole) {
            let now = Date().timeIntervalSince1970
            let expiration: TimeInterval = 60 * 30
            self.userId = userId
            self.roles = roles
            self.platformRole = platformRole
            self.deviceId = deviceId
            self.sessionId = sessionId
            self.status = 0
            self.iat = now
            self.exp = now + expiration
            
        }
        
        public enum CodingKeys: String, CodingKey {
            case userId = "u"
            case deviceId = "d"
            case sessionId = "s"
            case roles = "r"
            case platformRole = "p"
            case status = "st"
            case iat
            case exp
        }
//
        public func verify() throws {
            let now = Date().timeIntervalSince1970
            guard exp > now else { throw Abort(.unauthorized, reason: "Token has expired") }
        }
        
    }
}
