//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/10/2022.
//

import Foundation
import Vapor

extension HTTPHeaders.Name {
    public static let acceptClientHints = HTTPHeaders.Name.init("Accept-CH")
    public static let xIdempotencyKey = HTTPHeaders.Name.init("X-Idempotency-Key")
    public static let xJwsSignature = HTTPHeaders.Name.init("X-JWS-Signature")
    public static let xLocalDeviceIdentifier = HTTPHeaders.Name.init("X-Local-Device-Identifier")
    public static let priority = HTTPHeaders.Name.init("Priority")
    
    public static let secClientHintPrefersColorScheme = HTTPHeaders.Name.init("Sec-Ch-Prefers-Color-Scheme")
    public static let secClientHintPrefersReducedMotion = HTTPHeaders.Name.init("Sec-Ch-Prefers-Reduced-Motion")
    public static let secClientHintPrefersReducedTransparency = HTTPHeaders.Name.init("Sec-Ch-Prefers-Reduced-Transparency")
    public static let secClientHintUserAgent = HTTPHeaders.Name.init("Sec-CH-UA")
    public static let secClientHintUserAgentArch = HTTPHeaders.Name.init("Sec-CH-UA-Arch")
    public static let secClientHintUserAgentBitness = HTTPHeaders.Name.init("Sec-CH-UA-Bitness")
    public static let secClientHintUserAgentFullVersionList = HTTPHeaders.Name.init("Sec-CH-UA-Full-Version-List")
    public static let secClientHintUserAgentMobile = HTTPHeaders.Name.init("Sec-CH-UA-Mobile")
    public static let secClientHintUserAgentModel = HTTPHeaders.Name.init("Sec-CH-UA-Model")
    public static let secClientHintUserAgentPlatform = HTTPHeaders.Name.init("Sec-CH-UA-Platform")
    public static let secClientHintUserAgentPlatformVersion = HTTPHeaders.Name.init("Sec-CH-UA-Platform-Version")
    
    public static let secFetchDestination = HTTPHeaders.Name.init("Sec-Fetch-Dest")
    public static let secFetchMode = HTTPHeaders.Name.init("Sec-Fetch-Mode")
    public static let secFetchSite = HTTPHeaders.Name.init("Sec-Fetch-Site")
    
}

extension HTTPHeaders.Name: OpenAPIEncodedSchemaType {
    public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
        .string
    }
}

extension HTTPHeaders.Name: OpenAPIEncodableSampleable {
    public static var sample: HTTPHeaders.Name {
        .accept
    }
}


public struct HTTPHeadersCollection: Codable, Equatable {
    public var headers: [HTTPHeadersCollectionItem]
    
    public init(_ headers: [HTTPHeadersCollectionItem]) {
        self.headers = headers
    }
}

public struct HTTPHeadersCollectionItem: Codable, Equatable {
    public var name: HTTPHeaders.Name
    public var isRequired: Bool
    public var value: String?
    
    public init(_ name: HTTPHeaders.Name, isRequired: Bool, value: String? = nil) {
        self.name = name
        self.isRequired = isRequired
        self.value = value
    }

    public mutating func setValue(_ value: String? = nil) {
        self.value = value
    }
}

extension HTTPHeaders {
    public func get(_ name: Name) throws -> String {
        guard let header = self.first(name: name) else { throw Abort(.badRequest, reason: "Could not find header \(name)") }
        return header
    }
}

extension HTTPHeaders {
    public var localDeviceIdentifier: String? {
        get {
            guard let str = self.first(name: .xLocalDeviceIdentifier) else { return nil }
            return str
        }
        set {
            if let str = newValue {
                replaceOrAdd(name: .xLocalDeviceIdentifier, value: str)
            } else {
                remove(name: .xLocalDeviceIdentifier)
            }
        }
    }
}
