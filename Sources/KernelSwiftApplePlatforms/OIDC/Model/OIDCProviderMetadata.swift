//
//  File.swift
//
//
//  Created by Jonathan Forbes on 22/04/2023.
//

import Foundation
import KernelSwiftCommon

public struct OIDCProviderMetadata: Codable, Equatable, Sendable {
    
    public var issuer: String
    public var jwksUri: String
    public var registrationEndpoint: String?
    public var pushedAuthorizationRequestEndpoint: String?
    public var authorizationEndpoint: String
    public var deviceAuthorizationEndpoint: String?
    public var tokenEndpoint: String
    public var introspectionEndpoint: String?
    public var revocationEndpoint: String?
    public var userinfoEndpoint: String?
    
    public var checkSessionIframe: String?
    public var endSessionEndpoint: String?
    
    public var grantTypesSupported: [OIDCGrantType]?
    public var responseTypesSupported: [OIDCResponseType]
    public var responseModesSupported: [OIDCResponseMode]?
    public var promptValuesSupported: [OIDCPromptType]?
    public var codeChallengeMethodsSupported: [OIDCCodeChallengeMethod]?
    
    public var subjectTypesSupported: [OIDCSubjectType]
    
    
    public var scopesSupported: [OIDCScopeTypeValue]?
    public var claimsSupported: [String]?
    public var claimLocalesSupported: [OIDCLocale]?
    public var claimTypesSupported: [OIDCClaimType]?
    
    public var acrValuesSupported: [String]?
    public var displayValuesSupported: [OIDCDisplayType]?
    
    
    
    public var uiLocalesSupported: [OIDCLocale]?
    public var claimsParameterSupported: Bool?
    public var requestParameterSupported: Bool?
    public var requestUriParameterSupported: Bool?
    public var requireRequestUriRegistration: Bool?
    
    public var idTokenSigningAlgValuesSupported: [JSONWebSignatureAlgorithm]
    public var idTokenEncryptionAlgValuesSupported: [JSONWebEncryptionAlgorithm]?
    public var idTokenEncryptionEncValuesSupported: [JSONWebEncryptionAlgorithm]?
    public var tokenEndpointAuthMethodsSupported: [OIDCClientAuthMethod]?
    public var tokenEndpointAuthSigningAlgValuesSupported: [JSONWebSignatureAlgorithm]?
    public var userinfoSigningAlgValuesSupported: [JSONWebSignatureAlgorithm]?
    public var userinfoEncryptionAlgValuesSupported: [JSONWebEncryptionAlgorithm]?
    public var userinfoEncryptionEncValuesSupported: [JSONWebEncryptionAlgorithm]?
    public var requestObjectSigningAlgValuesSupported: [JSONWebSignatureAlgorithm]?
    public var requestObjectEncryptionAlgValuesSupported: [JSONWebEncryptionAlgorithm]?
    public var requestObjectEncryptionEncValuesSupported: [JSONWebEncryptionAlgorithm]?
    public var introspectionEndpointAuthMethodsSupported: [OIDCClientAuthMethod]?
    public var revocationEndpointAuthMethodsSupported: [OIDCClientAuthMethod]?
    public var backchannelTokenDeliveryModesSupported: [OIDCCIBADeliveryMode]?
    public var backchannelAuthenticationRequestSigningAlgValuesSupported: [JSONWebSignatureAlgorithm]?
    public var dpopSigningAlgValuesSupported: [JSONWebSignatureAlgorithm]?
    
    
    public var opPolicyUri: String?
    public var opTosUri: String?
    public var serviceDocumentation: String?
    
    public init(
        issuer: String,
        jwksUri: String,
        registrationEndpoint: String? = nil,
        pushedAuthorizationRequestEndpoint: String? = nil,
        authorizationEndpoint: String,
        deviceAuthorizationEndpoint: String? = nil,
        tokenEndpoint: String,
        introspectionEndpoint: String? = nil,
        revocationEndpoint: String? = nil,
        userinfoEndpoint: String? = nil,
        checkSessionIframe: String? = nil,
        endSessionEndpoint: String? = nil,
        grantTypesSupported: [OIDCGrantType]? = nil,
        responseTypesSupported: [OIDCResponseType],
        responseModesSupported: [OIDCResponseMode]? = nil,
        promptValuesSupported: [OIDCPromptType]? = nil,
        codeChallengeMethodsSupported: [OIDCCodeChallengeMethod]? = nil,
        subjectTypesSupported: [OIDCSubjectType],
        scopesSupported: [OIDCScopeTypeValue]? = nil,
        claimsSupported: [String]? = nil,
        claimLocalesSupported: [OIDCLocale]? = nil,
        claimTypesSupported: [OIDCClaimType]? = nil,
        acrValuesSupported: [String]? = nil,
        displayValuesSupported: [OIDCDisplayType]? = nil,
        uiLocalesSupported: [OIDCLocale]? = nil,
        claimsParameterSupported: Bool? = nil,
        requestParameterSupported: Bool? = nil,
        requestUriParameterSupported: Bool? = nil,
        requireRequestUriRegistration: Bool? = nil,
        idTokenSigningAlgValuesSupported: [JSONWebSignatureAlgorithm],
        idTokenEncryptionAlgValuesSupported: [JSONWebEncryptionAlgorithm]? = nil,
        idTokenEncryptionEncValuesSupported: [JSONWebEncryptionAlgorithm]? = nil,
        tokenEndpointAuthMethodsSupported: [OIDCClientAuthMethod]? = nil,
        tokenEndpointAuthSigningAlgValuesSupported: [JSONWebSignatureAlgorithm]? = nil,
        userinfoSigningAlgValuesSupported: [JSONWebSignatureAlgorithm]? = nil,
        userinfoEncryptionAlgValuesSupported: [JSONWebEncryptionAlgorithm]? = nil,
        userinfoEncryptionEncValuesSupported: [JSONWebEncryptionAlgorithm]? = nil,
        requestObjectSigningAlgValuesSupported: [JSONWebSignatureAlgorithm]? = nil,
        requestObjectEncryptionAlgValuesSupported: [JSONWebEncryptionAlgorithm]? = nil,
        requestObjectEncryptionEncValuesSupported: [JSONWebEncryptionAlgorithm]? = nil,
        introspectionEndpointAuthMethodsSupported: [OIDCClientAuthMethod]? = nil,
        revocationEndpointAuthMethodsSupported: [OIDCClientAuthMethod]? = nil,
        backchannelTokenDeliveryModesSupported: [OIDCCIBADeliveryMode]? = nil,
        backchannelAuthenticationRequestSigningAlgValuesSupported: [JSONWebSignatureAlgorithm]? = nil,
        dpopSigningAlgValuesSupported: [JSONWebSignatureAlgorithm]? = nil,
        opPolicyUri: String? = nil,
        opTosUri: String? = nil,
        serviceDocumentation: String? = nil
    ) {
        self.issuer = issuer
        self.jwksUri = jwksUri
        self.registrationEndpoint = registrationEndpoint
        self.pushedAuthorizationRequestEndpoint = pushedAuthorizationRequestEndpoint
        self.authorizationEndpoint = authorizationEndpoint
        self.deviceAuthorizationEndpoint = deviceAuthorizationEndpoint
        self.tokenEndpoint = tokenEndpoint
        self.introspectionEndpoint = introspectionEndpoint
        self.revocationEndpoint = revocationEndpoint
        self.userinfoEndpoint = userinfoEndpoint
        self.checkSessionIframe = checkSessionIframe
        self.endSessionEndpoint = endSessionEndpoint
        self.grantTypesSupported = grantTypesSupported
        self.responseTypesSupported = responseTypesSupported
        self.responseModesSupported = responseModesSupported
        self.promptValuesSupported = promptValuesSupported
        self.codeChallengeMethodsSupported = codeChallengeMethodsSupported
        self.subjectTypesSupported = subjectTypesSupported
        self.scopesSupported = scopesSupported
        self.claimsSupported = claimsSupported
        self.claimLocalesSupported = claimLocalesSupported
        self.claimTypesSupported = claimTypesSupported
        self.acrValuesSupported = acrValuesSupported
        self.displayValuesSupported = displayValuesSupported
        self.uiLocalesSupported = uiLocalesSupported
        self.claimsParameterSupported = claimsParameterSupported
        self.requestParameterSupported = requestParameterSupported
        self.requestUriParameterSupported = requestUriParameterSupported
        self.requireRequestUriRegistration = requireRequestUriRegistration
        self.idTokenSigningAlgValuesSupported = idTokenSigningAlgValuesSupported
        self.idTokenEncryptionAlgValuesSupported = idTokenEncryptionAlgValuesSupported
        self.idTokenEncryptionEncValuesSupported = idTokenEncryptionEncValuesSupported
        self.tokenEndpointAuthMethodsSupported = tokenEndpointAuthMethodsSupported
        self.tokenEndpointAuthSigningAlgValuesSupported = tokenEndpointAuthSigningAlgValuesSupported
        self.userinfoSigningAlgValuesSupported = userinfoSigningAlgValuesSupported
        self.userinfoEncryptionAlgValuesSupported = userinfoEncryptionAlgValuesSupported
        self.userinfoEncryptionEncValuesSupported = userinfoEncryptionEncValuesSupported
        self.requestObjectSigningAlgValuesSupported = requestObjectSigningAlgValuesSupported
        self.requestObjectEncryptionAlgValuesSupported = requestObjectEncryptionAlgValuesSupported
        self.requestObjectEncryptionEncValuesSupported = requestObjectEncryptionEncValuesSupported
        self.introspectionEndpointAuthMethodsSupported = introspectionEndpointAuthMethodsSupported
        self.revocationEndpointAuthMethodsSupported = revocationEndpointAuthMethodsSupported
        self.backchannelTokenDeliveryModesSupported = backchannelTokenDeliveryModesSupported
        self.backchannelAuthenticationRequestSigningAlgValuesSupported = backchannelAuthenticationRequestSigningAlgValuesSupported
        self.dpopSigningAlgValuesSupported = dpopSigningAlgValuesSupported
        self.opPolicyUri = opPolicyUri
        self.opTosUri = opTosUri
        self.serviceDocumentation = serviceDocumentation
    }
    
    
    enum CodingKeys: String, CodingKey {
        case issuer
        case jwksUri = "jwks_uri"
        case registrationEndpoint = "registration_endpoint"
        case pushedAuthorizationRequestEndpoint = "pushed_authorization_request_endpoint"
        case authorizationEndpoint = "authorization_endpoint"
        case deviceAuthorizationEndpoint = "device_authorization_endpoint"
        case tokenEndpoint = "token_endpoint"
        case introspectionEndpoint = "introspection_endpoint"
        case revocationEndpoint = "revocation_endpoint"
        case userinfoEndpoint = "userinfo_endpoint"
        case checkSessionIframe = "check_session_iframe"
        case endSessionEndpoint = "end_session_endpoint"
        case grantTypesSupported = "grant_types_supported"
        case responseTypesSupported = "response_types_supported"
        case responseModesSupported = "response_modes_supported"
        case promptValuesSupported = "prompt_values_supported"
        case codeChallengeMethodsSupported = "code_challenge_methods_supported"
        case subjectTypesSupported = "subject_types_supported"
        case scopesSupported = "scopes_supported"
        case claimsSupported = "claims_supported"
        case claimLocalesSupported = "claim_locales_supported"
        case claimTypesSupported = "claim_types_supported"
        case acrValuesSupported = "acr_values_supported"
        case displayValuesSupported = "display_values_supported"
        case uiLocalesSupported = "ui_locales_supported"
        case claimsParameterSupported = "claims_parameter_supported"
        case requestParameterSupported = "request_parameter_supported"
        case requestUriParameterSupported = "request_uri_parameter_supported"
        case requireRequestUriRegistration = "require_request_uri_registration"
        case idTokenSigningAlgValuesSupported = "id_token_signing_alg_values_supported"
        case idTokenEncryptionAlgValuesSupported = "id_token_encryption_alg_values_supported"
        case idTokenEncryptionEncValuesSupported = "id_token_encryption_enc_values_supported"
        case tokenEndpointAuthMethodsSupported = "token_endpoint_auth_methods_supported"
        case tokenEndpointAuthSigningAlgValuesSupported = "token_endpoint_auth_signing_alg_values_supported"
        case userinfoSigningAlgValuesSupported = "userinfo_signing_alg_values_supported"
        case userinfoEncryptionAlgValuesSupported = "userinfo_encryption_alg_values_supported"
        case userinfoEncryptionEncValuesSupported = "userinfo_encryption_enc_values_supported"
        case requestObjectSigningAlgValuesSupported = "request_object_signing_alg_values_supported"
        case requestObjectEncryptionAlgValuesSupported = "request_object_encryption_alg_values_supported"
        case requestObjectEncryptionEncValuesSupported = "request_object_encryption_enc_values_supported"
        case introspectionEndpointAuthMethodsSupported = "introspection_endpoint_auth_methods_supported"
        case revocationEndpointAuthMethodsSupported = "revocation_endpoint_auth_methods_supported"
        case backchannelTokenDeliveryModesSupported = "backchannel_token_delivery_modes_supported"
        case backchannelAuthenticationRequestSigningAlgValuesSupported = "backchannel_authentication_request_signing_alg_values_supported"
        case dpopSigningAlgValuesSupported = "dpop_signing_alg_values_supported"
        case opPolicyUri = "op_policy_uri"
        case opTosUri = "op_tos_uri"
        case serviceDocumentation = "service_documentation"
    }
    
}
