//
//  File.swift
//
//
//  Created by Jonathan Forbes on 11/04/2023.
//

import Foundation
import KernelSwiftCommon


public enum OIDCResponseTypeValue: String, Codable, Equatable, CaseIterable, Sendable {
    case none = "none"
    case code = "code"
    case token = "token"
    case idToken = "id_token"
}

public typealias OIDCResponseType = SpacedStringEnumArray<OIDCResponseTypeValue>

extension OIDCResponseType {
    public static let code: Self = .init([.code])
    public static let codeIdToken: Self = .init([.code, .idToken])
    public static let codeIdTokenToken: Self = .init([.code, .idToken, .token])
    public static let codeToken: Self = .init([.code, .token])
    public static let codeTokenIdToken: Self = .init([.code, .token, .idToken])
    public static let idToken: Self = .init([.idToken])
    public static let idTokenToken: Self = .init([.idToken, .token])
    public static let token: Self = .init([.token])
    public static let tokenIdToken: Self = .init([.token, .idToken])
    public static let none: Self = .init([.none])
    
    public static func == (lhs: OIDCResponseType, rhs: OIDCResponseType) -> Bool {
        lhs.value.count == rhs.value.count && lhs.value.allSatisfy({ val in
            rhs.value.contains(val)
        })
    }
}

public struct OIDCTokenResponse: Codable {
    
    
    public let expiresIn: Int?
    public let accessToken: String?
    public let idToken: String?
    public let scope: String?
    public let tokenType: String?
    public let refreshToken: String?
    
    public init(
        expiresIn: Int? = nil,
        accessToken: String? = nil,
        idToken: String? = nil,
        scope: String? = nil,
        tokenType: String? = nil,
        refreshToken: String? = nil
    ) {
        self.expiresIn = expiresIn
        self.accessToken = accessToken
        self.idToken = idToken
        self.scope = scope
        self.tokenType = tokenType
        self.refreshToken = refreshToken
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case idToken = "id_token"
        case scope
        case tokenType = "token_type"
    }
}
