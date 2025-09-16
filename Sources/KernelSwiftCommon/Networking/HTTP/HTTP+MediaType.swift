//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 29/03/2025.
//

import Foundation

extension KernelNetworking.HTTP {
    public struct MediaType: Hashable, CustomStringConvertible, Equatable, Sendable, LosslessStringConvertible {
        public static func ==(lhs: MediaType, rhs: MediaType) -> Bool {
            guard lhs.type != "*" && rhs.type != "*" else {
                return true
            }
            
            guard lhs.type.caseInsensitiveCompare(rhs.type) == .orderedSame else {
                return false
            }
            
            return lhs.subType == "*" || rhs.subType == "*" || lhs.subType.caseInsensitiveCompare(rhs.subType) == .orderedSame
        }
        
        public var type: String
        public var subType: String
        public var parameters: [String: String]
        
        public func serialize() -> String {
            var string = "\(type)/\(subType)"
            for (key, val) in parameters {
                string += "; \(key)=\(val)"
            }
            return string
        }
        
        public var description: String {
            return serialize()
        }
        
        public func hash(into hasher: inout Hasher) {
            self.type.hash(into: &hasher)
            self.subType.hash(into: &hasher)
        }
        
        public init(type: String, subType: String, parameters: [String: String] = [:]) {
            self.type = type
            self.subType = subType
            self.parameters = parameters
        }
        
        public init?(_ description: String) {
            var components =
            description
                .split(separator: ";").map(String.init)
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            guard !components.isEmpty else { return nil }
            let firstComponent = components.removeFirst()
            let typeAndSubtype = firstComponent.split(separator: "/").map(String.init)
            guard typeAndSubtype.count == 2 else { return nil }
            let typeString: String = typeAndSubtype[0]
            let subtypeString: String = typeAndSubtype[1]
            func parseParameter(_ string: String) -> (String, String)? {
                let paramComponents = string.split(separator: "=").map(String.init)
                guard paramComponents.count == 2 else { return nil }
                return (paramComponents[0], paramComponents[1])
            }
            let parameters = components.compactMap(parseParameter)
            self.init(type: typeString, subType: subtypeString, parameters: Dictionary(uniqueKeysWithValues: parameters))
        }
    }
}

extension KernelNetworking.HTTP.MediaType {
    public static let any: Self = .init(type: "*", subType: "*")
    public static let plainText: Self = .init(type: "text", subType: "plain", parameters: ["charset": "utf-8"])
    public static let html: Self = .init(type: "text", subType: "html", parameters: ["charset": "utf-8"])
    public static let css: Self = .init(type: "text", subType: "css", parameters: ["charset": "utf-8"])
    public static let urlEncodedForm: Self = .init(type: "application", subType: "x-www-form-urlencoded", parameters: ["charset": "utf-8"])
    public static let formData: Self = .init(type: "multipart", subType: "form-data")
    public static let multipart: Self = .init(type: "multipart", subType: "mixed")
    public static let json: Self = .init(type: "application", subType: "json", parameters: ["charset": "utf-8"])
    public static let jsonAPI: Self = .init(type: "application", subType: "vnd.api+json", parameters: ["charset": "utf-8"])
    public static let jsonSequence: Self = .init(type: "application", subType: "json-seq", parameters: ["charset": "utf-8"])
    public static let xml: Self = .init(type: "application", subType: "xml", parameters: ["charset": "utf-8"])
    public static let dtd: Self = .init(type: "application", subType: "xml-dtd", parameters: ["charset": "utf-8"])
    public static let pdf: Self = .init(type: "application", subType: "pdf")
    public static let zip: Self = .init(type: "application", subType: "zip")
    public static let tar: Self = .init(type: "application", subType: "x-tar")
    public static let gzip: Self = .init(type: "application", subType: "x-gzip")
    public static let bzip2: Self = .init(type: "application", subType: "x-bzip2")
    public static let binary: Self = .init(type: "application", subType: "octet-stream")
    public static let gif: Self = .init(type: "image", subType: "gif")
    public static let jpeg: Self = .init(type: "image", subType: "jpeg")
    public static let png: Self = .init(type: "image", subType: "png")
    public static let svg: Self = .init(type: "image", subType: "svg+xml")
    public static let tiff: Self = .init(type: "image", subType: "tiff")
    public static let webp: Self = .init(type: "image", subType: "webp")
    public static let jxl: Self = .init(type: "image", subType: "jxl")
    public static let avif: Self = .init(type: "image", subType: "avif")
    public static let audio: Self = .init(type: "audio", subType: "basic")
    public static let midi: Self = .init(type: "audio", subType: "x-midi")
    public static let mp3: Self = .init(type: "audio", subType: "mpeg")
    public static let wave: Self = .init(type: "audio", subType: "wav")
    public static let ogg: Self = .init(type: "audio", subType: "vorbis")
    public static let avi: Self = .init(type: "video", subType: "avi")
    public static let mpeg: Self = .init(type: "video", subType: "mpeg")
    
    public static let csv: Self = .init(type: "text", subType: "csv")
    public static let yaml: Self = .init(type: "application", subType: "x-yaml")
    public static let pemFile: Self = .init(type: "application", subType: "x-pem-file")
    public static let pkcs7Certificates: Self = .init(type: "application", subType: "x-pkcs7-certificates")
    public static let pkcs7CertReqResp: Self = .init(type: "application", subType: "x-pkcs7-certreqresp")
    public static let pkcs7Crl: Self = .init(type: "application", subType: "x-pkcs7-crl")
    public static let pkcs7Mime: Self = .init(type: "application", subType: "pkcs7-mime")
    public static let pkcs8: Self = .init(type: "application", subType: "pkcs8")
    public static let pkcs8Encrypted: Self = .init(type: "application", subType: "pkcs8-encrypted")
    public static let pkcs10: Self = .init(type: "application", subType: "pkcs10")
    public static let pkcs12: Self = .init(type: "application", subType: "x-pkcs12")
    public static let pkixCert: Self = .init(type: "application", subType: "pkix-cert")
    public static let pkixCrl: Self = .init(type: "application", subType: "pkix-crl")
    public static let x509CaCert: Self = .init(type: "application", subType: "x-x509-ca-cert")
    public static let x509UserCert: Self = .init(type: "application", subType: "x-x509-user-cert")
    
    static func formData(boundary: String) -> Self {
        .init(type: "multipart", subType: "form-data", parameters: [
            "boundary": boundary
        ])
    }
}
