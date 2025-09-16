//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 7/5/24.
//

import Foundation
import Vapor
import KernelSwiftCommon

public protocol JWTPayload: Codable, Equatable, Content, OpenAPIEncodableSampleable {
    func verify() throws
}

extension JWTPayload {
    public func makeJWT(on app: Application) throws -> String {
        try app.kernelDI(KernelIdentity.self).auth.makeJWT(self)
    }
    
    public static func verify(_ token: String, on app: Application) throws -> Self {
        let payload = try app.kernelDI(KernelIdentity.self).auth.verifyJWT(token, as: Self.self)
        try payload.verify()
        return payload
    }
}
