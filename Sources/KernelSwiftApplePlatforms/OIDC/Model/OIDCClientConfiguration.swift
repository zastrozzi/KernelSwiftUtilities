//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelAppUtils.OIDC {
    public struct OIDCClientConfiguration: Codable, Equatable, WellKnownResourceIdentifiable, Sendable {
        public var configDisplayName: String
        public var uiDesign: OIDCClientUIDesign
        public var authority: String
        public var clientId: String
        public var serverClientId: String?
        public var responseType: OIDCResponseType
        public var scope: OIDCScopeType
        public var hdParam: String?
        
        public var redirectUri: OIDCRedirectURI?
        public var customUrlScheme: OIDCCustomURLScheme?
        public var postLogoutRedirectUri: String?
        public var silentRenewUrl: String?
        
        public var ignoreNonceOnRefresh: Bool?
        public var useRefreshToken: Bool?
        public var usePushedAuthorisationRequests: Bool?
        public var startCheckSession: Bool?
        
        public var disableHistoryCleanup: Bool?                  // historyCleanupOff
        //    public var disableIATOffsetValidation: Bool?             // disableIatOffsetValidation
        //    public var disableIdTokenValidation: Bool?               // disableIdTokenValidation
        //    public var disableISSValidation: Bool?                   // issValidationOff
        public var disablePKCE: Bool?                            // disablePkce
        public var disableRefreshIdTokenAuthTimeValidation: Bool?    // disableRefreshIdTokenAuthTimeValidation
        public var disableRouteChange: Bool?                     // triggerAuthorizationResultEvent
        
        public var enableSilentRenew: Bool?                     // silentRenew
        public var enableRefreshOnIdTokenExpiration: Bool?      // triggerRefreshWhenIdTokenExpired
        public var enableServiceWorkerBypass: Bool?             // ngswBypass
        public var enableStateCleanupOnAuthentication: Bool?    // autoCleanStateAfterAuthentication
        public var enableUserInfoFetchOnLogin: Bool?            // autoUserInfo
        public var enableUserInfoFetchOnTokenRenew: Bool?       // renewUserInfoAfterTokenRenew
        
        public var allowUnsafeRefreshTokenReuse: Bool?          // allowUnsafeReuseRefreshToken
        
        public var maxIdTokenIATOffsetAllowedInSeconds: Int?    // maxIdTokenIatOffsetAllowedInSeconds
        public var renewTimeBeforeTokenExpiresInSeconds: Int?
        public var silentRenewTimeoutInSeconds: Int?
        public var tokenRefreshInSeconds: Int?
        public var tokenRefreshRetryInSeconds: Int?             // refreshTokenRetryInSeconds
        
        public var postLoginRoute: String?
        public var forbiddenRoute: String?
        public var unauthorisedRoute: String?                      // unauthorizedRoute
        public var secureRoutes: [String]?
        
        public var wellKnownResourceIdentifier: WellKnownResourceIdentifier { .openIDConfiguration(host: authority) }
        
        public init(
            configDisplayName: String,
            uiDesign: OIDCClientUIDesign,
            authority: String,
            clientId: String,
            serverClientId: String? = nil,
            responseType: OIDCResponseType,
            scope: OIDCScopeType,
            hdParam: String? = nil,
            redirectUri: OIDCRedirectURI? = nil,
            customUrlScheme: OIDCCustomURLScheme? = nil,
            postLogoutRedirectUri: String? = nil,
            silentRenewUrl: String? = nil,
            ignoreNonceOnRefresh: Bool? = nil,
            useRefreshToken: Bool? = nil,
            usePushedAuthorisationRequests: Bool? = nil,
            startCheckSession: Bool? = nil,
            disableHistoryCleanup: Bool? = nil,
            disablePKCE: Bool? = nil,
            disableRefreshIdTokenAuthTimeValidation: Bool? = nil,
            disableRouteChange: Bool? = nil,
            enableSilentRenew: Bool? = nil,
            enableRefreshOnIdTokenExpiration: Bool? = nil,
            enableServiceWorkerBypass: Bool? = nil,
            enableStateCleanupOnAuthentication: Bool? = nil,
            enableUserInfoFetchOnLogin: Bool? = nil,
            enableUserInfoFetchOnTokenRenew: Bool? = nil,
            allowUnsafeRefreshTokenReuse: Bool? = nil,
            maxIdTokenIATOffsetAllowedInSeconds: Int? = nil,
            renewTimeBeforeTokenExpiresInSeconds: Int? = nil,
            silentRenewTimeoutInSeconds: Int? = nil,
            tokenRefreshInSeconds: Int? = nil,
            tokenRefreshRetryInSeconds: Int? = nil,
            postLoginRoute: String? = nil,
            forbiddenRoute: String? = nil,
            unauthorisedRoute: String? = nil,
            secureRoutes: [String]? = nil
        ) {
            self.configDisplayName = configDisplayName
            self.uiDesign = uiDesign
            self.authority = authority
            self.clientId = clientId
            self.serverClientId = serverClientId
            self.responseType = responseType
            self.scope = scope
            self.hdParam = hdParam
            self.redirectUri = redirectUri
            self.customUrlScheme = customUrlScheme
            self.postLogoutRedirectUri = postLogoutRedirectUri
            self.silentRenewUrl = silentRenewUrl
            self.ignoreNonceOnRefresh = ignoreNonceOnRefresh
            self.useRefreshToken = useRefreshToken
            self.usePushedAuthorisationRequests = usePushedAuthorisationRequests
            self.startCheckSession = startCheckSession
            self.disableHistoryCleanup = disableHistoryCleanup
            self.disablePKCE = disablePKCE
            self.disableRefreshIdTokenAuthTimeValidation = disableRefreshIdTokenAuthTimeValidation
            self.disableRouteChange = disableRouteChange
            self.enableSilentRenew = enableSilentRenew
            self.enableRefreshOnIdTokenExpiration = enableRefreshOnIdTokenExpiration
            self.enableServiceWorkerBypass = enableServiceWorkerBypass
            self.enableStateCleanupOnAuthentication = enableStateCleanupOnAuthentication
            self.enableUserInfoFetchOnLogin = enableUserInfoFetchOnLogin
            self.enableUserInfoFetchOnTokenRenew = enableUserInfoFetchOnTokenRenew
            self.allowUnsafeRefreshTokenReuse = allowUnsafeRefreshTokenReuse
            self.maxIdTokenIATOffsetAllowedInSeconds = maxIdTokenIATOffsetAllowedInSeconds
            self.renewTimeBeforeTokenExpiresInSeconds = renewTimeBeforeTokenExpiresInSeconds
            self.silentRenewTimeoutInSeconds = silentRenewTimeoutInSeconds
            self.tokenRefreshInSeconds = tokenRefreshInSeconds
            self.tokenRefreshRetryInSeconds = tokenRefreshRetryInSeconds
            self.postLoginRoute = postLoginRoute
            self.forbiddenRoute = forbiddenRoute
            self.unauthorisedRoute = unauthorisedRoute
            self.secureRoutes = secureRoutes
        }
        
    }
}
