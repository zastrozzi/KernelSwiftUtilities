//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 6/4/24.
//

import Vapor
import NIOConcurrencyHelpers

extension KernelAuthSessions.Model {
    internal final class SessionCache: Sendable {
        let middlewareFlag: NIOLockedValueBox<Bool>
        let session: NIOLockedValueBox<Session?>
        
        init(session: Session? = nil) {
            self.session = .init(session)
            self.middlewareFlag = .init(false)
        }
    }
    
    internal struct SessionCacheKey: StorageKey {
        typealias Value = SessionCache
    }
}
