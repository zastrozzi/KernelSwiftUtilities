//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/10/2022.
//

//import Foundation
//import SwiftJWT
//
//public struct NoAuthJWTHeader: HeaderProtocol {
//    public enum CodingKeys: String, CodingKey {
//        case typ = "typ"
//        case alg = "alg"
//        case kid = "kid"
//        case crit = "crit"
//        case b64 = "b64"
//        case obIat = "http://openbanking.org.uk/iat"
//        case obIss = "http://openbanking.org.uk/iss"
//        case obTan = "http://openbanking.org.uk/tan"
//    }
//
//    public var typ: String
//    public var alg: String?
//    public var kid: String
//    public var crit: [String]
//    public var b64: Bool
//    public var obIat: Date
//    public var obIss: String
//    public var obTan: String
//    
//    public init(
//        typ: String = "JWT",
//        kid: String,
//        crit: [String],
//        b64: Bool,
//        obIat: Date,
//        obIss: String,
//        obTan: String
//    ) {
//        self.typ = typ
//        self.kid = kid
//        self.crit = crit
//        self.b64 = b64
//        self.obIat = obIat
//        self.obIss = obIss
//        self.obTan = obTan
//    }
//    
//    public func encode() throws -> String {
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .custom({ (date, encoder) in
//            var container = encoder.singleValueContainer()
//            try container.encode(Int(date.timeIntervalSince1970))
//        })
//        
//        let data = try encoder.encode(self)
//        return Self.base64urlEncodedString(data: data)
//    }
//}
