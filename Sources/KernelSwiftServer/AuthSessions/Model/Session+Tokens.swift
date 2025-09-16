//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/4/24.
//

import Vapor

extension KernelAuthSessions.Model.Session {
    public enum Keys {
        static let accessToken = "access_token"
        static let refreshToken = "refresh_token"
    }
    
    public func accessToken() throws -> String {
        guard let token = try? get(Keys.accessToken, as: String.self) else {
            throw Abort(.unauthorized, reason: "User not authenticated")
        }
        return token
    }
    
    public func refreshToken() throws -> String {
        guard let token = try? get(Keys.refreshToken, as: String.self) else {
            throw Abort(.unauthorized, reason: "User not authenticated")
        }
        return token
    }
    
    public func setAccessToken(_ token: String) throws {
        try set(Keys.accessToken, to: token)
    }
    
    public func setRefreshToken(_ token: String) throws {
        try set(Keys.refreshToken, to: token)
    }
}
