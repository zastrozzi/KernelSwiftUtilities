//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import Vapor
@preconcurrency import OpenAPIKit30

extension Route {
    @discardableResult
    public func summary(_ summary: String) -> Route {
        userInfo["openapi:summary"] = summary
        return self
    }

    @discardableResult
    public func tags(_ tags: String...) -> Route {
        return self.tags(tags)
    }

    @discardableResult
    public func tags(_ tags: [String]) -> Route {
        userInfo["openapi:tags"] = tags
        return self
    }
    
    @discardableResult
    public func headers(_ headers: HTTPHeaders.Name...) -> Route {
        return self.headers(headers)
    }
    
    @discardableResult
    public func headers(_ headers: [HTTPHeaders.Name]) -> Route {
        userInfo["openapi:headers"] = headers
        return self
    }
    
    @discardableResult
    public func security(_ schemes: SecuritySchemeName...) -> Route {
        return self.security(schemes)
    }
    
    @discardableResult
    public func security(_ schemes: [SecuritySchemeName]) -> Route {
//        userInfo["openapi:security"] = schemes
        if userInfo.keys.contains("openapi:security"), let routeSecuritySchemes = userInfo["openapi:security"] as? [SecuritySchemeName] {
            userInfo["openapi:security"] = (schemes + routeSecuritySchemes).uniqued(on: { name in
                name.rawValue
            })
        } else {
            userInfo["openapi:security"] = schemes
        }
        return self
    }
    
    @discardableResult
    public func contentTypes(_ types: OpenAPI.ContentType...) -> Route {
        return self.contentTypes(types)
    }
    
    @discardableResult
    public func contentTypes(_ types: [OpenAPI.ContentType]) -> Route {
        userInfo["openapi:contentTypes"] = types
        return self
    }
}

public enum SecuritySchemeName: String, Sendable {
    case bearerJWT = "BearerJWTAuthorization"
    case localDeviceIdentification = "LocalDeviceIdentification"
}

