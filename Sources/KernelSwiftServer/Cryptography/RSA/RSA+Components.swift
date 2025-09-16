//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//
import Foundation
import KernelSwiftCommon

extension KernelCryptography.RSA {
    public struct Components: Sendable {
        public let n: KernelNumerics.BigInt
        public let e: KernelNumerics.BigInt
        public let d: KernelNumerics.BigInt
        public let p: KernelNumerics.BigInt
        public let q: KernelNumerics.BigInt
        public let keySize: KeySize

        public init(
            n: KernelNumerics.BigInt,
            e: KernelNumerics.BigInt,
            d: KernelNumerics.BigInt,
            p: KernelNumerics.BigInt,
            q: KernelNumerics.BigInt
        ) throws {
            guard n == p * q else { throw KernelCryptography.TypedError(.invalidKeyLength) }
            let phi = (p - 1) * (q - 1)
            guard d == e.modInverse(phi) else { throw KernelCryptography.TypedError(.invalidKeyLength) }
            
            self.n = n
            self.e = e
            self.d = d
            self.p = p
            self.q = q
            self.keySize = try .init(n.bitWidth)
        }
        
        internal init(
            n: KernelNumerics.BigInt,
            e: KernelNumerics.BigInt,
            d: KernelNumerics.BigInt,
            p: KernelNumerics.BigInt,
            q: KernelNumerics.BigInt,
            keySize: KeySize
        ) {
            
            self.n = n
            self.e = e
            self.d = d
            self.p = p
            self.q = q
            self.keySize = keySize
        }
        
        internal init(
            privateKey: PrivateKey
        ) throws {
            try self.init(
                n: privateKey.n,
                e: privateKey.e,
                d: privateKey.d,
                p: privateKey.p,
                q: privateKey.q
            )
        }

        public init(keySize: KeySize, concurrentCoreCount: Int = 10, keySizeTolerance: Int = .zero) async throws {
            var validKeySize = false, p1: KernelNumerics.BigInt = .zero, q1: KernelNumerics.BigInt = .zero, n1: KernelNumerics.BigInt = .zero
            while !validKeySize {
                (p1, q1) = try await KernelNumerics.BigInt.Prime.probable(keySize.intValue / 2, concurrentCoreCount: concurrentCoreCount)
                n1 = p1 * q1
                if let _: KeySize = try? .init(n1.bitWidth, withTolerance: keySizeTolerance) { validKeySize = true }
                else { KernelCryptography.logger.error("Invalid key size - trying again") }
            }
            let e1: KernelNumerics.BigInt = .init(65537)
            let d1 = e1.modInverse((p1 - 1) * (q1 - 1))
            self.n = n1
            self.e = e1
            self.d = d1
            self.p = p1
            self.q = q1
            self.keySize = keySize
        }
        
        public static func generateMultiple(count: Int, keySize: KeySize, concurrentCoreCount: Int = 10, keySizeTolerance: Int = .zero) async throws -> [Self] {
            guard count > .zero else { throw KernelCryptography.TypedError(.rsaGenerationFailed) }
            guard count <= 5000 else { throw KernelCryptography.TypedError(.rsaGenerationFailed) }
            return try await KernelNumerics.BigInt.Prime
                .probablePairs(keySize.intValue / 2, concurrentCoreCount: concurrentCoreCount, total: count, keySizeTolerance: keySizeTolerance)
                .asyncMap { pair in
                    let (p1, q1) = (pair.0, pair.1)
                    let n1 = p1 * q1
                    let e1: KernelNumerics.BigInt = .init(65537)
                    let d1 = e1.modInverse((p1 - 1) * (q1 - 1))
                    return .init(n: n1, e: e1, d: d1, p: p1, q: q1, keySize: keySize)
                }
        }
        
        public static func generateMultipleSingles(count: Int, keySize: KeySize, concurrentCoreCount: Int = 10) async throws -> [Self] {
            guard count > .zero else { throw KernelCryptography.TypedError(.rsaGenerationFailed) }
            guard count <= 1000 else { throw KernelCryptography.TypedError(.rsaGenerationFailed) }
            return try await KernelNumerics.BigInt.Prime
                .probable(keySize.intValue / 2, concurrentCoreCount: concurrentCoreCount, total: count * 2)
                .adjacentPairs()
                .striding(by: 2)
                .asyncMap { pair in
                    let (p1, q1) = (pair.0, pair.1)
                    let n1 = p1 * q1
                    let e1: KernelNumerics.BigInt = .init(65537)
                    let d1 = e1.modInverse((p1 - 1) * (q1 - 1))
                    return .init(n: n1, e: e1, d: d1, p: p1, q: q1, keySize: keySize)
                }
        }
        
        public func publicKey(_ format: KeyFormat) -> PublicKey { .init(n: n, e: e, keySize: keySize, keyFormat: format) }
        public func privateKey(_ format: KeyFormat) -> PrivateKey { .init(n: n, e: e, d: d, p: p, q: q, keySize: keySize, keyFormat: format) }
        
        public func skidString(hashMode: KernelCryptography.Common.SKIDHashMode) -> String {
            switch hashMode {
            case .sha256pkcs1DerHex: return KernelCryptography.MD.hash(.SHA2_256, publicKey(.pkcs1).serialiseForASN1()).hexEncodedString(uppercase: true)
            case .sha256X509DerHex: return KernelCryptography.MD.hash(.SHA2_256, publicKey(.pkcs8).serialiseForASN1()).hexEncodedString(uppercase: true)
            case .sha1pkcs1DerHex: return KernelCryptography.MD.hash(.SHA1, publicKey(.pkcs1).serialiseForASN1()).hexEncodedString(uppercase: true)
            case .sha1X509DerHex: return KernelCryptography.MD.hash(.SHA1, publicKey(.pkcs8).serialiseForASN1()).hexEncodedString(uppercase: true)
//            case .md5pkcs1DerHex: return Insecure.MD5.hash(data: publicKeyPKCS1DER()).hexEncodedString(uppercase: true)
//            case .md5X509DerHex: return Insecure.MD5.hash(data: publicKeyX509DER()).hexEncodedString(uppercase: true)
            case .sha256pkcs1DerB64: return KernelCryptography.MD.hash(.SHA2_256, publicKey(.pkcs1).serialiseForASN1()).base64String()
            case .sha256X509DerB64: return KernelCryptography.MD.hash(.SHA2_256, publicKey(.pkcs8).serialiseForASN1()).base64String()
            case .sha1pkcs1DerB64: return KernelCryptography.MD.hash(.SHA1, publicKey(.pkcs1).serialiseForASN1()).base64String()
            case .sha1X509DerB64: return KernelCryptography.MD.hash(.SHA1, publicKey(.pkcs8).serialiseForASN1()).base64String()
//            case .md5pkcs1DerB64: return Array(Insecure.MD5.hash(data: publicKeyPKCS1DER())).base64String()
//            case .md5X509DerB64: return Array(Insecure.MD5.hash(data: publicKeyX509DER())).base64String()
            default: preconditionFailure("md5 not implemented")
            }
        }
        
        public func printSkidStrings() {
            let sha256pkcs1DerHex = KernelCryptography.MD.hash(.SHA2_256, publicKey(.pkcs1).serialiseForASN1()).hexEncodedString(uppercase: true)
            let sha256X509DerHex = KernelCryptography.MD.hash(.SHA2_256, publicKey(.pkcs8).serialiseForASN1()).hexEncodedString(uppercase: true)
            let sha1pkcs1DerHex = KernelCryptography.MD.hash(.SHA1, publicKey(.pkcs1).serialiseForASN1()).hexEncodedString(uppercase: true)
            let sha1X509DerHex = KernelCryptography.MD.hash(.SHA1, publicKey(.pkcs8).serialiseForASN1()).hexEncodedString(uppercase: true)
            let sha256pkcs1DerB64 = KernelCryptography.MD.hash(.SHA2_256, publicKey(.pkcs1).serialiseForASN1()).base64String()
            let sha256X509DerB64 = KernelCryptography.MD.hash(.SHA2_256, publicKey(.pkcs8).serialiseForASN1()).base64String()
            let sha1pkcs1DerB64 = KernelCryptography.MD.hash(.SHA1, publicKey(.pkcs1).serialiseForASN1()).base64String()
            let sha1X509DerB64 = KernelCryptography.MD.hash(.SHA1, publicKey(.pkcs8).serialiseForASN1()).base64String()
            print("sha256pkcs1DerHex", sha256pkcs1DerHex)
            print("sha256X509DerHex", sha256X509DerHex)
            print("sha1pkcs1DerHex", sha1pkcs1DerHex)
            print("sha1X509DerHex", sha1X509DerHex)
            print("sha256pkcs1DerB64", sha256pkcs1DerB64)
            print("sha256X509DerB64", sha256X509DerB64)
            print("sha1pkcs1DerB64", sha1pkcs1DerB64)
            print("sha1X509DerB64", sha1X509DerB64)
            
        }
        
        public func jwksKidString(hashMode: KernelCryptography.Common.JWKSKIDHashMode) -> String {
            let thumbData: JWKSThumbprintData = .init(
                e: e.signedBytes().base64String(),
                kty: "RSA",
                n: n.signedBytes().base64String()
            )
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
            case .sha1ThumbBase64Url: return KernelCryptography.MD.hash(.SHA1, .init(encoded)).base64String()
            case .sha256ThumbBase64Url: return KernelCryptography.MD.hash(.SHA2_256, .init(encoded)).base64String()
            }
            
        }
        
    }
}

