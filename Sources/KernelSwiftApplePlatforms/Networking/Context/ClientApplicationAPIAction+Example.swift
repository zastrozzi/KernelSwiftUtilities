//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/04/2025.
//

import Foundation
import KernelSwiftCommon
import HTTPTypes

public struct LoginEnduserEmailPasswordRequest: Codable, Sendable {
    public var email: String
    public var password: String
}

public struct LoginEnduserEmailPasswordResponse: Codable, Sendable {
    public var accessToken: String
    public var expiresAt: Date
}

public struct LoginEnduser: ClientApplicationAPIAction {
    public typealias RequestBody = LoginEnduserEmailPasswordRequest
    public typealias ResponseBody = LoginEnduserEmailPasswordResponse
    
    public static let operationName: String = "LoginEnduser"
    public static let method: HTTPRequest.Method = .post
    
    public var partialPath: String { "/identity/1.0/endusers/auth/login" }
    public var requestBody: RequestBody
    
    public init(requestBody: RequestBody) {
        self.requestBody = requestBody
    }
    
}
