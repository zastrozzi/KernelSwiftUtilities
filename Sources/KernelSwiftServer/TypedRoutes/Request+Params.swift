//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import Vapor

extension Request {
    func getParameterUUID(_ parameterName: String) throws -> UUID {
        guard
            let uuidStr = parameters.get(parameterName),
            let uuid = UUID(uuidString: uuidStr)
        else {
            throw Abort(.badRequest, reason: "Parameter \(parameterName) not found on request")
        }
        return uuid
    }
    
    public func getHeaderUUID(_ headerName: HTTPHeaders.Name) throws -> UUID {
        guard
            let uuidStr = try? headers.get(headerName),
            let uuid = UUID(uuidString: uuidStr)
        else {
            throw Abort(.badRequest, reason: "Header \(headerName) not found on request")
        }
        return uuid
    }
}

extension TypedRequest {
    func getParameterUUID(_ parameterName: String) throws -> UUID {
        guard
            let uuidStr = underlyingRequest.parameters.get(parameterName),
            let uuid = UUID(uuidString: uuidStr)
        else {
            throw Abort(.badRequest, reason: "Parameter \(parameterName) not found on request")
        }
        return uuid
    }
    
    public func getHeaderUUID(_ headerName: HTTPHeaders.Name) throws -> UUID {
        guard
            let uuidStr = try? underlyingRequest.headers.get(headerName),
            let uuid = UUID(uuidString: uuidStr)
        else {
            throw Abort(.badRequest, reason: "Header \(headerName) not found on request")
        }
        return uuid
    }
}
