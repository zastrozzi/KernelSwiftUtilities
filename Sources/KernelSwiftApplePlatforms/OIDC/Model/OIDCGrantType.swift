//
//  File.swift
//
//
//  Created by Jonathan Forbes on 23/04/2023.
//

import Foundation

public enum OIDCGrantType: String, Codable, Equatable, CaseIterable, Sendable {
    case authorizationCode = "authorization_code"
    case ciba = "urn:openid:params:grant-type:ciba"
    case clientCredentials = "client_credentials"
    case deviceCode = "urn:ietf:params:oauth:grant-type:device_code"
    case jwtBearer = "urn:ietf:params:oauth:grant-type:jwt-bearer"
    case password = "password"
    case refreshToken = "refresh_token"
    case tokenExchange = "urn:ietf:params:oauth:grant-type:token-exchange"
}
