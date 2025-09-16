//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/09/2023.
//

import Foundation
import KernelSwiftCommon

public enum OIDCURLQueryParam: RawRepresentableAsString {
    case clientId
    case clientSecret
    case redirectUri
    case responseType
    case scope
    case codeChallenge
    case codeChallengeMethod
    case codeVerifier
    case code
    case grantType
    case nonce
    
    public var rawValue: String {
        switch self {
        case .clientId: "client_id"
        case .clientSecret: "client_secret"
        case .redirectUri: "redirect_uri"
        case .responseType: "response_type"
        case .scope: "scope"
        case .codeChallenge: "code_challenge"
        case .codeChallengeMethod: "code_challenge_method"
        case .codeVerifier: "code_verifier"
        case .code: "code"
        case .grantType: "grant_type"
        case .nonce: "nonce"
        }
    }
}

extension URLQueryItem {
    public static func oidc(_ oidcParam: OIDCURLQueryParam, _ value: String?) -> URLQueryItem {
        return .init(name: oidcParam.rawValue, value: value)
    }
}
