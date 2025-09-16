//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/10/2022.
//

import Foundation
//import SwiftJWT

public protocol JWTHeaderProtocol: Codable {
    var alg: String? { get set }
    func encode() throws -> String
}

public extension JWTHeaderProtocol {
    func encode() throws -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .secondsSince1970
        let data = try jsonEncoder.encode(self)
        return Self.base64urlEncodedString(data: data)
    }
    
    static func base64urlEncodedString(data: Data) -> String {
        let result = data.base64EncodedString()
        return result.replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    static func data(base64urlEncoded: String) -> Data? {
        let paddingLength = 4 - base64urlEncoded.count % 4
        let padding = (paddingLength < 4) ? String(repeating: "=", count: paddingLength) : ""
        let base64EncodedString = base64urlEncoded
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
            + padding
        return Data(base64Encoded: base64EncodedString)
    }
}
