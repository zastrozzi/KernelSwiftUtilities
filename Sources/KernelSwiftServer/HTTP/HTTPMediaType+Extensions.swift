//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/07/2023.
//

import Vapor

extension HTTPMediaType {
    public static let csv: HTTPMediaType = .init(type: "text", subType: "csv")
    public static let yaml: HTTPMediaType = .init(type: "application", subType: "x-yaml")
    
    // PKI File Types
    public static let pemFile: HTTPMediaType = .init(type: "application", subType: "x-pem-file")
    public static let pkcs7Certificates: HTTPMediaType = .init(type: "application", subType: "x-pkcs7-certificates")
    public static let pkcs7CertReqResp: HTTPMediaType = .init(type: "application", subType: "x-pkcs7-certreqresp")
    public static let pkcs7Crl: HTTPMediaType = .init(type: "application", subType: "x-pkcs7-crl")
    public static let pkcs7Mime: HTTPMediaType = .init(type: "application", subType: "pkcs7-mime")
    public static let pkcs8: HTTPMediaType = .init(type: "application", subType: "pkcs8")
    public static let pkcs8Encrypted: HTTPMediaType = .init(type: "application", subType: "pkcs8-encrypted")
    public static let pkcs10: HTTPMediaType = .init(type: "application", subType: "pkcs10")
    public static let pkcs12: HTTPMediaType = .init(type: "application", subType: "x-pkcs12")
    public static let pkixCert: HTTPMediaType = .init(type: "application", subType: "pkix-cert")
    public static let pkixCrl: HTTPMediaType = .init(type: "application", subType: "pkix-crl")
    public static let x509CaCert: HTTPMediaType = .init(type: "application", subType: "x-x509-ca-cert")
    public static let x509UserCert: HTTPMediaType = .init(type: "application", subType: "x-x509-user-cert")
    
}

extension HTTPMediaType {
    public var fallback: HTTPMediaType? {
        switch self {
        case    .pemFile,
                .pkcs7Certificates,
                .pkcs7CertReqResp,
                .pkcs7Crl,
                .pkcs7Mime,
                .pkcs8,
                .pkcs8Encrypted,
                .pkcs10,
                .pkcs12,
                .pkixCert,
                .pkixCrl,
                .x509CaCert,
                .x509UserCert: .plainText
        default: nil
        }
    }
}

extension HTTPMediaType: @retroactive Codable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(serialize())
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard string.contains("/") else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid media type: \(string)")
        }
        let stringParts = string.split(separator: "/", maxSplits: 2)
        guard stringParts.count == 2 else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid media type: \(string)")
        }
        let typePart = stringParts[0]
        let subTypeAndParamsParts = stringParts[1].split(separator: ";", maxSplits: 1)
        let subTypePart = subTypeAndParamsParts[0]
        let parametersPart = subTypeAndParamsParts.count == 2 ? subTypeAndParamsParts[1] : ""
        
        if parametersPart.isEmpty {
            self.init(type: String(typePart), subType: String(subTypePart))
        } else {
            let parameters = parametersPart.split(separator: ";").reduce(into: [String: String]()) { (result, parameter) in
                let parts = parameter.split(separator: "=", maxSplits: 1)
                guard parts.count == 2 else {
                    return
                }
                let key = parts[0].trimmingCharacters(in: .whitespaces)
                let value = parts[1].trimmingCharacters(in: .whitespaces)
                result[key] = value
            }
            self.init(type: String(typePart), subType: String(subTypePart), parameters: parameters)
        }
    }
}

extension HTTPMediaType: OpenAPIEncodedSchemaType {
    public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
        .string
    }
}

extension HTTPMediaType: OpenAPIEncodableSampleable {
    public static var sample: HTTPMediaType {
        .plainText
    }
}
