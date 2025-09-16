//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//
import Vapor

extension KernelASN1 {
    public struct PEMFile: AsyncResponseEncodable, ResponseEncodable, Sendable {
        
        public var pemString: String
        
        public init<Object: ASN1Buildable>(for format: Format, from asn1Object: Object) {
            self.pemString = Self.pemString(for: format, from: asn1Object)
        }
        
        public init(for format: Format, from bytes: [UInt8]) {
            self.pemString = Self.pemString(for: format, from: bytes)
        }
        
        public init(pemString: String) {
            self.pemString = pemString
        }
        
        public func encodeResponse(for request: Request) async throws -> Response {
            let headers = HTTPHeaders()
            return .init(status: .ok, headers: headers, body: .init(data: .init(pemString.utf8Bytes)))
        }
        
        public func encodeResponse(for request: Request) -> EventLoopFuture<Response> {
            let headers = HTTPHeaders()
            return request.eventLoop.makeSucceededFuture(.init(
                status: .ok, headers: headers, body: .init(data: .init(pemString.utf8Bytes))
            ))
        }
    }
    
    public struct TypedPEMFile<Format: _KernelASN1PEMFormat>: AsyncResponseEncodable, ResponseEncodable, Sendable {
        public var pemString: String
        
        public init(_ pem: PEMFile) {
            self.pemString = pem.pemString
        }
        
        public init<Object: ASN1Buildable>(for format: Format, from asn1Object: Object) {
//            self.format = format
            self.pemString = PEMFile.pemString(for: Format.format, from: asn1Object)
        }
        
        public init(for format: Format, from bytes: [UInt8]) {
//            self.format = format
            self.pemString = PEMFile.pemString(for: Format.format, from: bytes)
        }
        
        public func encodeResponse(for request: Request) async throws -> Response {
            let headers = HTTPHeaders()
            return .init(status: .ok, headers: headers, body: .init(data: .init(pemString.utf8Bytes)))
        }
        
        public func encodeResponse(for request: Request) -> EventLoopFuture<Response> {
            let headers = HTTPHeaders()
            return request.eventLoop.makeSucceededFuture(.init(
                status: .ok, headers: headers, body: .init(data: .init(pemString.utf8Bytes))
            ))
        }
    }
}

extension KernelASN1.TypedPEMFile: Content {
//    public static func decodeRequest(_ request: Request) async throws -> KernelASN1.TypedPEMFile<Format> {
//        let pemString = try request.content.decode(String.self)
//        let contentBlocksWithFormat = try KernelASN1.PEMFile.allBase64ContentBlocksWithFormat(pemString)
//        guard contentBlocksWithFormat.count == 1, let firstContentBlockWithFormat = contentBlocksWithFormat.first else {
//            throw Abort(.unsupportedMediaType, reason: "PEM file must contain exactly one block")
//        }
//        let pemFile: KernelASN1.PEMFile = .init(for: firstContentBlockWithFormat.format, from: firstContentBlockWithFormat.base64Content.base64Bytes())
//        return .init(pemFile)
//    }
//    
//    public static func decodeRequest(_ request: Request) -> EventLoopFuture<KernelASN1.TypedPEMFile<Format>> {
//        let promise = request.eventLoop.makePromise(of: KernelASN1.TypedPEMFile<Format>.self)
//        promise.completeWithTask {
//            try await decodeRequest(request)
//        }
////        let future: EventLoopFuture<KernelASN1.TypedPEMFile<Format>> = promise.futureResult
//        return promise.futureResult
//    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let pemString = try container.decode(String.self)
        let pemFile: KernelASN1.PEMFile = .init(pemString: pemString)
        self.init(pemFile)
    }
    
    
}

public protocol _KernelASN1PEMFormat {
    static var format: KernelASN1.PEMFile.Format { get }
}

extension KernelASN1.PEMFile {
    public enum Format: Sendable {
        case rsaPublicKey
        case rsaPrivateKey
        case crl
        case crt
        case csr
        case newCsr
        case pem
        case pkcs7
        case privateKey
        case publicKey
        case encryptedPrivateKey
        case dsaKey
        case ecPrivateKey
        case ecPublicKey
        case pgpPrivateKey
        case pgpPublicKey
        
        public var qualifier: String {
            switch self {
            case .rsaPublicKey: "RSA PUBLIC KEY"
            case .rsaPrivateKey: "RSA PRIVATE KEY"
            case .crl: "X509 CRL"
            case .crt: "CERTIFICATE"
            case .csr: "CERTIFICATE REQUEST"
            case .newCsr: "NEW CERTIFICATE REQUEST"
            case .pem: "RSA PRIVATE KEY"
            case .pkcs7: "PKCS7"
            case .privateKey: "PRIVATE KEY"
            case .publicKey: "PUBLIC KEY"
            case .encryptedPrivateKey: "ENCRYPTED PRIVATE KEY"
            case .dsaKey: "DSA KEY"
            case .ecPrivateKey: "EC PRIVATE KEY"
            case .ecPublicKey: "EC PUBLIC KEY"
            case .pgpPrivateKey: "PGP PRIVATE KEY BLOCK"
            case .pgpPublicKey: "PGP PUBLIC KEY BLOCK"
            }
        }
        
        public var header: String { KernelASN1.PEMFile.headerPrefix + qualifier + KernelASN1.PEMFile.headerSuffix }
        public var footer: String { KernelASN1.PEMFile.footerPrefix + qualifier + KernelASN1.PEMFile.footerSuffix }
        
        public struct RSAPublicKey: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .rsaPublicKey }
        public struct RSAPrivateKey: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .rsaPrivateKey }
        public struct CRL: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .crl }
        public struct CRT: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .crt }
        public struct CSR: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .csr }
        public struct NewCSR: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .newCsr }
        public struct PEM: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .pem }
        public struct PKCS7: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .pkcs7 }
        public struct PrivateKey: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .privateKey }
        public struct PublicKey: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .publicKey }
        public struct EncryptedPrivateKey: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .encryptedPrivateKey }
        public struct DSAKey: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .dsaKey }
        public struct ECPrivateKey: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .ecPrivateKey }
        public struct ECPublicKey: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .ecPublicKey }
        public struct PGPPrivateKey: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .pgpPrivateKey }
        public struct PGPPublicKey: _KernelASN1PEMFormat { public static let format: KernelASN1.PEMFile.Format = .pgpPublicKey }
    }
    
    public static func pemString<Object: ASN1Buildable>(for format: Format, from asn1Object: Object) -> String {
        let built = asn1Object.buildASN1Type()
        if case let .bitString(digest) = built {
//            print("BITSTRINGDIG")
            let serializedStringLines: [String] = [format.header] + digest.value.base64String().chunks(ofCount: 64).map { String($0) } + [format.footer]
            return serializedStringLines.joined(separator: .newLine)
        } else {
            let data = KernelASN1.ASN1Writer.dataFromObject(built)
            let serializedStringLines: [String] = [format.header] + data.base64String().chunks(ofCount: 64).map { String($0) } + [format.footer]
            return serializedStringLines.joined(separator: .newLine)
        }
        //        ASN1Printer.printObject(built)
        
    }
    
    public static func pemString(for format: Format, from bytes: [UInt8]) -> String {
        let serializedStringLines: [String] = [format.header] + bytes.base64String().chunks(ofCount: 64).map { String($0) } + [format.footer]
        return serializedStringLines.joined(separator: .newLine)
        //        ASN1Printer.printObject(built)
        
    }
}

extension KernelASN1.PEMFile {
    public static let headerPrefix: String = "-----BEGIN "
    public static let headerSuffix: String = "-----"
    public static let footerPrefix: String = "-----END "
    public static let footerSuffix: String = "-----"
    
    public static func headerPrefixRange(_ pemString: String) throws -> Range<Substring.Index> {
        guard let range = pemString.range(of: headerPrefix) else { throw KernelASN1.TypedError(.pemReadFailed) }
        return range
    }
    
    public static func headerSuffixRange(_ pemString: String) throws -> Range<Substring.Index> {
        guard let range = pemString[try headerPrefixRange(pemString).upperBound...].range(of: headerSuffix) else { throw KernelASN1.TypedError(.pemReadFailed) }
        return range
    }
    
    public static func footerPrefixRange(_ pemString: String) throws -> Range<Substring.Index> {
        guard let range = pemString.range(of: footerPrefix) else { throw KernelASN1.TypedError(.pemReadFailed) }
        return range
    }
    
    public static func footerSuffixRange(_ pemString: String) throws -> Range<Substring.Index> {
        guard let range = pemString[try footerPrefixRange(pemString).upperBound...].range(of: footerSuffix) else { throw KernelASN1.TypedError(.pemReadFailed) }
        return range
    }
    
    public static func qualifier(_ pemString: String) throws -> String {
        let lower = try headerPrefixRange(pemString).upperBound
        let upper = try headerSuffixRange(pemString).lowerBound
        return String(pemString[lower..<upper])
    }
    
    public static func detectFormat(_ pemString: String) throws -> Format {
        switch try qualifier(pemString) {
        case "RSA PUBLIC KEY": .rsaPublicKey
        case "RSA PRIVATE KEY": .rsaPrivateKey
        case "X509 CRL": .crl
        case "CERTIFICATE": .crt
        case "CERTIFICATE REQUEST": .csr
        case "NEW CERTIFICATE REQUEST": .newCsr
//        case "RSA PRIVATE KEY": .pem
        case "PKCS7": .pkcs7
        case "PRIVATE KEY": .privateKey
        case "PUBLIC KEY": .publicKey
        case "ENCRYPTED PRIVATE KEY": .encryptedPrivateKey
        case "DSA KEY": .dsaKey
        case "EC PRIVATE KEY": .ecPrivateKey
        case "EC PUBLIC KEY": .ecPublicKey
        case "PGP PRIVATE KEY BLOCK": .pgpPrivateKey
        case "PGP PUBLIC KEY BLOCK": .pgpPublicKey
        default: throw KernelASN1.TypedError(.pemReadFailed)
        }
    }
    
    public static func base64Content(_ pem: String) throws -> String {
        let lower = try headerSuffixRange(pem).upperBound
        let upper = try footerPrefixRange(pem).lowerBound
        return String(pem[lower..<upper])
    }
    
    public static func base64ContentBlockWithFormat(_ pem: String) throws -> Base64ContentBlockWithFormat {
        .init(format: try detectFormat(pem), base64Content: try base64Content(pem))
    }
    
    public static func allBase64ContentBlocksWithFormat(_ pem: String) throws -> [Base64ContentBlockWithFormat] {
        var pem = pem.trimmingCharacters(in: .whitespacesAndNewlines)
        var res: [Base64ContentBlockWithFormat] = []
        while !pem.isEmpty {
            let currentBlockUpper = try footerSuffixRange(pem).upperBound
            res.append(try base64ContentBlockWithFormat(pem))
            pem = String(pem[currentBlockUpper...])
        }
        return res
    }
}

extension KernelASN1.PEMFile {
    public struct Base64ContentBlockWithFormat {
        public var format: Format
        public var base64Content: String
        
        public init(
            format: KernelASN1.PEMFile.Format,
            base64Content: String
        ) {
            self.format = format
            self.base64Content = base64Content
        }
    }
}

extension KernelASN1.TypedPEMFile: OpenAPIExampleProvider {
    public static func openAPIExample(using encoder: JSONEncoder) throws -> OpenAPIKit30.AnyCodable? {
        
        .init(samplePEM.pemString)
    }
    
    public static func openAPISchema(using encoder: JSONEncoder) throws -> OpenAPIKit30.JSONSchema {
        .string(format: .byte, required: true, nullable: false, example: .init(samplePEM.pemString))
//        .string(format: .other("byte"), required: true, nullable: false, examples: [.init(samplePEM.pemString)])
    }
    
    public static var samplePEM: KernelASN1.PEMFile {
        .init(for: Format.format, from: .generateSecRandom(count: 64))
    }
}
