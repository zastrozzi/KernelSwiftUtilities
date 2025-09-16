//
//  File.swift
//
//
//  Created by Jonathan Forbes on 7/5/24.
//

import Foundation
import Vapor

extension KernelIdentity.Core.Model {
    public enum PlatformActor: Codable, Equatable, Sendable {
        case adminUser(id: UUID)
        case enduser(id: UUID)
        case otherUser(id: UUID, userType: String)
        case none
        case system
        
        public enum ActorType {
            case adminUser
            case enduser
            case otherUser(userType: String)
            case none
            case system
        }
        
        public func actorType() -> ActorType {
            switch self {
            case .adminUser: return .adminUser
            case .enduser: return .enduser
            case let .otherUser(_, userType): return .otherUser(userType: userType)
            case .none: return .none
            case .system: return .system
            }
        }
    }
}

extension KernelIdentity.Core.Model.PlatformActor {
    private var _isSystem: Bool {
        switch self {
        case .system: true
        default: false
        }
    }
    
    private var _isSystemOrAdmin: Bool {
        switch self {
        case .system, .adminUser: true
        default: false
        }
    }
    
    private var _isEnduser: Bool {
        switch self {
        case .enduser: true
        default: false
        }
    }
    
    private var _isOtherUser: Bool {
        switch self {
        case .otherUser: true
        default: false
        }
    }
    
    private var _hasType: Bool {
        if case .none = self { return false }
        return true
    }
    
    public func hasType() throws {
        guard _hasType else { throw Abort(.unauthorized, reason: "No actor type identified") }
    }
    
    public func systemOrAdmin() throws {
        guard _isSystemOrAdmin else { throw Abort(.unauthorized, reason: "Must be Admin or System") }
    }
    
    public func isSystem() -> Bool { _isSystem }
    public func isSystemOrAdmin() -> Bool { _isSystemOrAdmin }
    public func isEnduser() -> Bool { _isEnduser }
    public func isOtherUser() -> Bool { _isOtherUser }
    public func isOtherUser(userType: String) -> Bool {
        if case let .otherUser(_, type) = self { return type == userType }
        return false
    }
    
    public func checkActorType(_ actorType: ActorType) throws {
        switch actorType {
        case .adminUser: guard _isSystemOrAdmin else { throw Abort(.unauthorized, reason: "Must be Admin or System") }
        case .enduser: guard _isEnduser else { throw Abort(.unauthorized, reason: "Must be Enduser") }
        case let .otherUser(userType): guard isOtherUser(userType: userType) else { throw Abort(.unauthorized, reason: "Must be \(userType)") }
        case .none: guard !_hasType else { throw Abort(.unauthorized, reason: "None actor type not allowed") }
        case .system: guard _isSystem else { throw Abort(.unauthorized, reason: "Must be System") }
        }
    }
    
    public func checkAdminUser(id: UUID) throws {
        try hasType()
        if case let .adminUser(adminUserId) = self {
            guard id == adminUserId else { throw Abort(.unauthorized, reason: "AdminUser does not match") }
        }
    }
    
    public func checkEnduser(id: UUID) throws {
        try hasType()
        if case let .enduser(enduserId) = self {
            guard id == enduserId else { throw Abort(.unauthorized, reason: "Enduser does not match") }
        }
    }
    
    public func checkOtherUser(id: UUID, userType: String) throws {
        try hasType()
        if case let .otherUser(otherUserId, otherUserType) = self {
            guard id == otherUserId && userType == otherUserType else { throw Abort(.unauthorized, reason: "OtherUser does not match") }
        }
    }
    
    public func checkOtherUser(id: UUID, userType: String? = nil) throws {
        try hasType()
        if case let .otherUser(otherUserId, _) = self {
            guard id == otherUserId else { throw Abort(.unauthorized, reason: "OtherUser does not match") }
        }
    }
    
    public func replaceAdminUserId(_ original: UUID? = nil) throws -> UUID? {
        if let original {
            try checkAdminUser(id: original)
            return original
        }
        if case let .adminUser(adminUserId) = self { return adminUserId }
        return nil
    }
    
    public func replaceAdminUserId(_ original: UUID) throws -> UUID {
        try checkAdminUser(id: original)
        if case let .adminUser(adminUserId) = self { return adminUserId }
        return original
    }
    
    public func replaceEnduserId(_ original: UUID? = nil) throws -> UUID? {
        if let original {
            try checkEnduser(id: original)
            return original
        }
        if case let .enduser(enduserId) = self { return enduserId }
        return nil
    }
    
    public func replaceEnduserId(_ original: UUID) throws -> UUID {
        try checkEnduser(id: original)
        if case let .enduser(enduserId) = self { return enduserId }
        return original
    }
    
    public func replaceOtherUserId(_ original: UUID? = nil, userType: String? = nil) throws -> UUID? {
        if let original {
            try checkOtherUser(id: original, userType: userType)
            return original
        }
        if case let .otherUser(otherUserId, otherUserType) = self {
            if userType == nil || userType == otherUserType { return otherUserId }
        }
        return nil
    }
    
    public func replaceOtherUserId(_ original: UUID, userType: String? = nil) throws -> UUID {
        try checkOtherUser(id: original, userType: userType)
        if case let .otherUser(otherUserId, otherUserType) = self {
            if userType == otherUserType { return otherUserId }
        }
        return original
    }
    
    public func replaceUserId(_ original: UUID, userType: String? = nil) throws -> UUID {
        try hasType()
        switch self {
        case .adminUser: return try replaceAdminUserId(original)
        case .enduser: return try replaceEnduserId(original)
        case .otherUser: return try replaceOtherUserId(original, userType: userType)
        default: return original
        }
    }
    
    public func userId() throws -> UUID {
        switch self {
        case let .adminUser(id), let .enduser(id), let .otherUser(id, _): return id
        default: throw Abort(.badRequest, reason: "No User Id")
        }
    }
}
