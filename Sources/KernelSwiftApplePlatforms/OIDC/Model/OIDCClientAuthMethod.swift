//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/09/2023.
//

import Foundation

public enum OIDCClientAuthMethod: String, Codable, Equatable, CaseIterable, Sendable {
    case clientSecretBasic = "client_secret_basic"
    case clientSecretPost = "client_secret_post"
    case clientSecretJwt = "client_secret_jwt"
    case privateKeyJwt = "private_key_jwt"
    case tlsClientAuth = "tls_client_auth"
    case selfSignedTlsClientAuth = "self_signed_tls_client_auth"
    case noneMethod = "none"
}

