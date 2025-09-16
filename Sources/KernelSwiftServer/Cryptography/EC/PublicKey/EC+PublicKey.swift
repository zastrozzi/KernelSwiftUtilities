//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.EC {
    public struct PublicKey: Sendable, Equatable, Hashable {
        public let domain: KernelNumerics.EC.Domain
        public let point: KernelNumerics.EC.Point
        public let keyFormat: KeyFormat
        public let wPoints: [KernelNumerics.EC.Point]
        
        public init(domain: KernelNumerics.EC.Domain, point: KernelNumerics.EC.Point, keyFormat: KeyFormat) {
            self.domain = domain
            self.point = point
            self.wPoints = KernelNumerics.EC.Arithmetic.Windowing.compute(point, d: domain)
            self.keyFormat = keyFormat
        }
    }
}

extension KernelCryptography.EC.PublicKey {
    public func keyAlg(restricted: Bool = false) -> KernelCryptography.Algorithms.AlgorithmIdentifier {
        .init(algorithm: restricted ? .x962PublicKeyRestricted : .x962PublicKey, parameters: .objectIdentifier(.init(oid: domain.oid)))
    }
}

extension KernelCryptography.EC.PublicKey: ASN1Decodable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        try self.init(pkcs8: asn1Type)
    }
}

extension KernelCryptography.EC.PublicKey: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        buildASN1TypePKCS8()
    }
}

extension KernelCryptography.EC.PublicKey {
    public func generateRS() throws -> (r: [UInt8], s: [UInt8]) {
        let (sec, pnt) = domain.generateSecretAndPoint()
        let pntb = domain.encode(pnt)
        let secp = KernelNumerics.EC.Arithmetic.Windowing.multiply(sec, points: wPoints, d: domain)
        let secpxb = secp.x.magnitudeBytes()
        return (r: pntb, s: secpxb)
    }
    
    public func encryptChaCha(input: [UInt8], aad: [UInt8] = []) throws -> [UInt8] {
        let (r, s) = try generateRS()
        let (key, nonce) = KernelCryptography.Cipher.deriveKey(32, 12, s, r)
        let aead = try KernelCryptography.ChaCha.ChaChaPoly(key, nonce)
        var b = input
        let tag = aead.encrypt(&b, aad)
        return r + b + tag
    }
    
    public func encrypt<S: KernelCryptography.Cipher.CipherStrategy>(input: [UInt8], keySize: KernelCryptography.AES.KeySize, as: S.Type = KernelCryptography.Cipher.GCM.self) throws -> [UInt8] {
        let (r, s) = try generateRS()
        var cipher = KernelCryptography.Cipher.initialise(keySize, S.self, s, r)
        var b = input
        let tag = try cipher.encrypt(&b)
        return r + b + tag
    }
    
    public func verify(signature: KernelCryptography.EC.Signature, message: [UInt8], bitWidth: Int? = nil) -> Bool {
        let r: KernelNumerics.BigInt = .init(magnitudeBytes: signature.r.magnitudeBytes())
        let s: KernelNumerics.BigInt = .init(magnitudeBytes: signature.s.magnitudeBytes())
        let order = domain.order
        guard r > .zero && r < domain.order else { return false }
        guard s > .zero && s < domain.order else { return false }
        var md = KernelCryptography.MD.Digest(signature.digestAlg)
        md.update(message)
        let dig = md.digest()
        var e: KernelNumerics.BigInt = .init(magnitudeBytes: dig)
        let d = dig.count * 8 - order.bitWidth
        if d > .zero { e >>= d }
        let x = s.modInverse(order)
        let u1 = (e * x).mod(order), u2 = (r * x).mod(order)
        let pu2 = KernelNumerics.EC.Arithmetic.Windowing.multiply(u2, points: wPoints, d: domain)
        let pu1 = domain.generatePointForSecret(u1)
        let puSum = domain.add(pu1, pu2)
        guard !puSum.isInfinite else { return false }
        return puSum.x.mod(order) == r
    }
    
    public func skidString(hashMode: KernelCryptography.Common.SKIDHashMode) -> String {
        
        switch hashMode {
        case .sha256pkcs1DerHex: KernelCryptography.MD.hash(.SHA2_256, domain.encode(point)).hexEncodedString(uppercase: true)
        case .sha256X509DerHex: KernelCryptography.MD.hash(.SHA2_256, buildASN1TypePKCS8().serialise()).hexEncodedString(uppercase: true)
        case .sha1pkcs1DerHex: KernelCryptography.MD.hash(.SHA1, domain.encode(point)).hexEncodedString(uppercase: true)
        case .sha1X509DerHex: KernelCryptography.MD.hash(.SHA1, buildASN1TypePKCS8().serialise()).hexEncodedString(uppercase: true)
            //            case .md5pkcs1DerHex: return Insecure.MD5.hash(data: domain.encode(point)).hexEncodedString(uppercase: true)
            //            case .md5X509DerHex: return Insecure.MD5.hash(data: publicKey(.pkcs8).buildASN1Type().serialise()).hexEncodedString(uppercase: true)
        case .sha256pkcs1DerB64: KernelCryptography.MD.hash(.SHA2_256, domain.encode(point)).base64String()
        case .sha256X509DerB64: KernelCryptography.MD.hash(.SHA2_256, buildASN1TypePKCS8().serialise()).base64String()
        case .sha1pkcs1DerB64: KernelCryptography.MD.hash(.SHA1, domain.encode(point)).base64String()
        case .sha1X509DerB64: KernelCryptography.MD.hash(.SHA1, buildASN1TypePKCS8().serialise()).base64String()
            //            case .md5pkcs1DerB64: return Array(Insecure.MD5.hash(data: publicKey(.pkcs8).buildASN1Type().serialise())).base64String()
            //            case .md5X509DerB64: return Array(Insecure.MD5.hash(data: publicKey(.pkcs8).buildASN1Type().serialise())).base64String()
        default: preconditionFailure("md5 not implemented")
        }
    }
    
    public func jwksKidString(hashMode: KernelCryptography.Common.JWKSKIDHashMode) -> String {
        let thumbData: KernelCryptography.EC.JWKSThumbprintData = .init(crv: JWKEllipticCurveAlgorithm(from: domain.oid)?.rawValue ?? "", kty: "EC", x: point.x.toString(radix: 10), y: point.y.toString(radix: 10))
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
