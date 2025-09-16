//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/09/2023.
//

import Foundation
import KernelSwiftCommon

public enum OIDCBasicScopeTypeValue: String, RawRepresentableAsString {
    case openid
    case address
    case profile
    case email
    case phone
}

public typealias OIDCBasicScopeType = SpacedStringEnumArray<OIDCBasicScopeTypeValue>

public enum OBUKAuthorizationScopeValue: RawRepresentableAsString {
    case accounts
    case payments
    case fundsConfirmation
    
    public var rawValue: String {
        switch self {
        case .accounts: "accounts"
        case .payments: "payments"
        case .fundsConfirmation: "fundsconfirmation"
        }
    }
}

public typealias OBUKAuthorizationScopeType = SpacedStringEnumArray<OBUKAuthorizationScopeValue>

public enum SCIMAuthorizationScopeValue: RawRepresentableAsString {
    case tppReadAll
    case tppReadAccess
    case aspspReadAll
    case aspspReadAccess
    case qtspReadAccess
    case authoritiesReadAccess
    
    public var rawValue: String {
        switch self {
        case .tppReadAll: "TPPReadAll"
        case .tppReadAccess: "TPPReadAcccess"
        case .aspspReadAll: "ASPSPReadAll"
        case .aspspReadAccess: "ASPSPReadAccess"
        case .qtspReadAccess: "QTSPReadAccess"
        case .authoritiesReadAccess: "AuthoritiesReadAccess"
        }
    }
}

public typealias SCIMAuthorizationScopeType = SpacedStringEnumArray<SCIMAuthorizationScopeValue>

public enum OIDCScopeTypeValue: RawRepresentableAsString {
    public static var allCases: [OIDCScopeTypeValue] {
        var allScopes: [OIDCScopeTypeValue] = []
        allScopes.append(contentsOf: OIDCBasicScopeTypeValue.allCases.map { .basic($0) })
        allScopes.append(contentsOf: OBUKAuthorizationScopeValue.allCases.map { .obukAuth($0) })
        allScopes.append(contentsOf: SCIMAuthorizationScopeValue.allCases.map { .obukSCIMAuth($0) })
        allScopes.append(.custom(""))
        return allScopes
    }
    
    public init?(rawValue: String) {
        if let foundScope = Self.allCases.first(where: { scope in
            scope.rawValue == rawValue
        }) {
            self = foundScope
        }
        else { self = .custom(rawValue) }
    }
    
    public var rawValue: String {
        switch self {
        case let .basic(value): value.rawValue
        case let .obukAuth(value): value.rawValue
        case let .obukSCIMAuth(value): value.rawValue
        case let .custom(value): value
        }
    }
    
    case basic(OIDCBasicScopeTypeValue)
    case obukAuth(OBUKAuthorizationScopeValue)
    case obukSCIMAuth(SCIMAuthorizationScopeValue)
    case custom(String)
}

public typealias OIDCScopeType = SpacedStringEnumArray<OIDCScopeTypeValue>
