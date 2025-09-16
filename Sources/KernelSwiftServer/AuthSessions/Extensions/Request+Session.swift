//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 6/4/24.
//

import Vapor

extension Request {
    public var authSession: KernelAuthSessions.Model.Session {
        if !_authSessionCache.middlewareFlag.withLockedValue({ $0 }) {
                assertionFailure("No `AuthSessionMiddleware` detected.")
            }
        return _authSessionCache.session.withLockedValue { storedSession in
            if let existing = storedSession { return existing }
            else {
                let newSession: KernelAuthSessions.Model.Session = .init()
                storedSession = newSession
                return newSession
            }
        }
    }
    
    public var hasAuthSession: Bool {
        _authSessionCache.session.withLockedValue { $0 != nil }
    }
    
    internal var _authSessionCache: KernelAuthSessions.Model.SessionCache {
        if let existing = storage[KernelAuthSessions.Model.SessionCacheKey.self] {
            return existing
        } else {
            let newCache: KernelAuthSessions.Model.SessionCache = .init()
            storage[KernelAuthSessions.Model.SessionCacheKey.self] = newCache
            return newCache
        }
    }
}
