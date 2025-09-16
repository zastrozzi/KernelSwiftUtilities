//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 02/07/2023.
//

import Vapor
import KernelSwiftCommon

extension TypedRoutesBuilder {
//    @discardableResult
//    public func summary(_ summary: String) -> TypedRoutesBuilder {
//        userInfo["openapi:summary"] = summary
//        return self
//    }
//    
    @discardableResult
    public func tags(_ tags: String...) -> TypedRoutesBuilder {
        return self.tags(tags)
    }
    
    @discardableResult
    public func tags(_ tags: [String]) -> TypedRoutesBuilder {
        if userInfo.keys.contains("openapi:group_tags"), let groupTags = userInfo["openapi:group_tags"] as? [String] {
            userInfo["openapi:group_tags"] = (tags + groupTags).uniqued(on: { tag in
                tag
            })
        } else {
            userInfo["openapi:group_tags"] = tags
        }
        return self
    }
    
    @discardableResult
    public func clearTags() -> TypedRoutesBuilder {
        userInfo["openapi:group_tags"] = []
        return self
    }


    @discardableResult
    public func headers(_ headers: HTTPHeaders.Name...) -> TypedRoutesBuilder {
        return self.headers(headers)
    }
    
    @discardableResult
    public func headers(_ headers: [HTTPHeaders.Name]) -> TypedRoutesBuilder {
        if userInfo.keys.contains("openapi:group_headers"), let groupHeaders = userInfo["openapi:group_headers"] as? [HTTPHeaders.Name] {
            userInfo["openapi:group_headers"] = headers + groupHeaders
        } else {
            userInfo["openapi:group_headers"] = headers
        }
        return self
    }
    
    @discardableResult
    public func security(_ schemes: SecuritySchemeName...) -> TypedRoutesBuilder {
        return self.security(schemes)
    }
    
    @discardableResult
    public func security(_ schemes: [SecuritySchemeName]) -> TypedRoutesBuilder {
        if userInfo.keys.contains("openapi:group_security"), let groupSecuritySchemes = userInfo["openapi:group_security"] as? [SecuritySchemeName] {
            userInfo["openapi:group_security"] = (schemes + groupSecuritySchemes).uniqued(on: { name in
                name.rawValue
            })
        } else {
            userInfo["openapi:group_security"] = schemes
        }
        return self
    }
}
