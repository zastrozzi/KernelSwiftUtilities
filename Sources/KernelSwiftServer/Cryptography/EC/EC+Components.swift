//
//  InternalModel+ECDSAComponents.swift
//
//
//  Created by Jimmy Hough Jr on 9/23/23.
//

import Foundation
import Vapor
import KernelSwiftCommon
import Fluent

extension KernelCryptography.EC {
    
    public struct Components: Sendable {
        public let domain: KernelNumerics.EC.Domain
        public let point: KernelNumerics.EC.Point
        public let secret: KernelNumerics.BigInt
        
        public init(
            domain: KernelNumerics.EC.Domain,
            point: KernelNumerics.EC.Point,
            secret: KernelNumerics.BigInt
        ) {
            self.domain = domain
            self.point = point
            self.secret = secret
        }
        
        public init(
            oid: KernelSwiftCommon.ObjectID,
            x: KernelNumerics.BigInt,
            y: KernelNumerics.BigInt,
            secret: KernelNumerics.BigInt
        ) throws {
            self.domain = try .init(fromOID: oid)
            self.point = .init(x: x, y: y)
            self.secret = secret
        }
        
        public init(domain: KernelNumerics.EC.Domain) async {
            self = await Task.detached {
                let (secret, point) = domain.generateSecretAndPoint()
                return Self(domain: domain, point: point, secret: secret)
            }.value
        }
        
        public init(oid: KernelSwiftCommon.ObjectID) async throws {
            self = try await Task.detached {
                let domain: KernelNumerics.EC.Domain = try .init(fromOID: oid)
                let (secret, point) = domain.generateSecretAndPoint()
                return Self(domain: domain, point: point, secret: secret)
            }.value
        }
        
        public init(oidSync oid: KernelSwiftCommon.ObjectID) throws {
            let domain: KernelNumerics.EC.Domain = try .init(fromOID: oid)
            let (secret, point) = domain.generateSecretAndPoint()
            self = .init(domain: domain, point: point, secret: secret)
        }
        
//        public func publicKey(_ format: KeyFormat) -> PublicKey { .init(n: n, e: e, keySize: keySize, keyFormat: format) }
        public func privateKey(_ format: KeyFormat) -> PrivateKey { .init(domain: domain, s: secret, keyFormat: format) }
        public func publicKey(_ format: KeyFormat) -> PublicKey { .init(domain: domain, point: point, keyFormat: format) }

        public func skidString(hashMode: KernelCryptography.Common.SKIDHashMode) -> String {

            switch hashMode {
            case .sha256pkcs1DerHex: KernelCryptography.MD.hash(.SHA2_256, domain.encode(point)).hexEncodedString(uppercase: true)
            case .sha256X509DerHex: KernelCryptography.MD.hash(.SHA2_256, publicKey(.pkcs8).buildASN1Type().serialise()).hexEncodedString(uppercase: true)
            case .sha1pkcs1DerHex: KernelCryptography.MD.hash(.SHA1, domain.encode(point)).hexEncodedString(uppercase: true)
            case .sha1X509DerHex: KernelCryptography.MD.hash(.SHA1, publicKey(.pkcs8).buildASN1Type().serialise()).hexEncodedString(uppercase: true)
//            case .md5pkcs1DerHex: return Insecure.MD5.hash(data: domain.encode(point)).hexEncodedString(uppercase: true)
//            case .md5X509DerHex: return Insecure.MD5.hash(data: publicKey(.pkcs8).buildASN1Type().serialise()).hexEncodedString(uppercase: true)
            case .sha256pkcs1DerB64: KernelCryptography.MD.hash(.SHA2_256, domain.encode(point)).base64String()
            case .sha256X509DerB64: KernelCryptography.MD.hash(.SHA2_256, publicKey(.pkcs8).buildASN1Type().serialise()).base64String()
            case .sha1pkcs1DerB64: KernelCryptography.MD.hash(.SHA1, domain.encode(point)).base64String()
            case .sha1X509DerB64: KernelCryptography.MD.hash(.SHA1, publicKey(.pkcs8).buildASN1Type().serialise()).base64String()
//            case .md5pkcs1DerB64: return Array(Insecure.MD5.hash(data: publicKey(.pkcs8).buildASN1Type().serialise())).base64String()
//            case .md5X509DerB64: return Array(Insecure.MD5.hash(data: publicKey(.pkcs8).buildASN1Type().serialise())).base64String()
            default: preconditionFailure("md5 not implemented")
            }
        }
        
        public func jwksKidString(hashMode: KernelCryptography.Common.JWKSKIDHashMode) -> String {
            let thumbData: JWKSThumbprintData = .init(crv: JWKEllipticCurveAlgorithm(from: domain.oid)?.rawValue ?? "", kty: "EC", x: point.x.toString(radix: 10), y: point.y.toString(radix: 10))
//            var nonLex: [UInt8] = []
//            print(skidString(hashMode: .sha1pkcs1DerB64))

            guard
                let encoded = try? KernelSwiftCommon.Coding.lexicographicJSONEncoder.encode(thumbData)
            else {
                KernelCryptography.logger.report(error: KernelCryptography.TypedError(.invalidKeyLength))
                preconditionFailure()
            }
//            print(encoded.copyBytes().toHexString())
//            print(Data(Insecure.SHA1.hash(data: encoded)).base64URLEncodedString())
//            print(Data(Insecure.SHA1.hash(data: encoded)).base64URLEncodedString())
            switch hashMode {
            case .sha1ThumbBase64Url: return KernelCryptography.MD.hash(.SHA1, .init(encoded)).base64String().base64URLEscaped()
            case .sha256ThumbBase64Url: return KernelCryptography.MD.hash(.SHA2_256, .init(encoded)).base64String().base64URLEscaped()
            }
            
        }
        
    }
}
