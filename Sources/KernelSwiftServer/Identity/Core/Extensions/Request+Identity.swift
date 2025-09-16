//
//  File.swift
//
//
//  Created by Jonathan Forbes on 6/5/24.
//

import Foundation
import Vapor

extension Request {
    public var loggedIn: Bool {
        return self.storage[AccessTokenPayloadKey.self] != nil ? true : false
    }
    
    public var authedAsEnduser: Bool {
        get { self.storage[AuthedAsEnduserKey.self] ?? false }
        set { self.storage[AuthedAsEnduserKey.self] = newValue }
    }

    public var authedAsAdminUser: Bool {
        get { self.storage[AuthedAsAdminUserKey.self] ?? false }
        set { self.storage[AuthedAsAdminUserKey.self] = newValue }
    }
    
    public var authed: KernelIdentity.Core.Model.AccessTokenPayload? {
        get { self.storage[AccessTokenPayloadKey.self] }
        set { self.storage[AccessTokenPayloadKey.self] = newValue }
    }
    
    public var platformActor: KernelIdentity.Core.Model.PlatformActor {
        guard let authed else { return .none }
        if authedAsEnduser { return .enduser(id: authed.userId) }
        if authedAsAdminUser { return .adminUser(id: authed.userId) }
        return .none
    }
    
    struct AccessTokenPayloadKey: StorageKey {
        typealias Value = KernelIdentity.Core.Model.AccessTokenPayload
    }

    struct AuthedAsEnduserKey: StorageKey {
        typealias Value = Bool
    }

    struct AuthedAsAdminUserKey: StorageKey {
        typealias Value = Bool
    }
}

