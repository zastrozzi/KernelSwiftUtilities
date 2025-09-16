//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 6/4/24.
//

import Vapor

extension KernelAuthSessions.Model {
    public struct CookieConfiguration: Sendable {
        public var name: String
        public var factory: @Sendable (SessionID) -> HTTPCookies.Value
        
        public init(
            name: String,
            factory: @Sendable @escaping (SessionID) -> HTTPCookies.Value
        ) {
            self.name = name
            self.factory = factory
        }
        
        public static func `default`() -> Self {
            .init(
                name: "kernel-auth-session") { id in
                        .init(
                            string: id.string,
                            expires: .init(timeIntervalSinceNow: 60 * 60 * 24 * 7),
                            maxAge: nil,
                            domain: nil,
                            path: "/",
                            isSecure: false,
                            isHTTPOnly: false,
                            sameSite: .lax
                        )
                }
        }
    }
}
