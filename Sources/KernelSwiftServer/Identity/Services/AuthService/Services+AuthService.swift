//
//  File.swift
//
//
//  Created by Jonathan Forbes on 1/5/24.
//

import Foundation
import Vapor
import KernelSwiftCommon
import Fluent

extension KernelIdentity.Services {
    public struct AuthService: DBAccessible, Sendable {
        @KernelDI.Injected(\.vapor) public var app
        public typealias FeatureContainer = KernelIdentity
        
        let publicKeyCache: KernelServerPlatform.SimpleMemoryCache<UUID, KernelCryptography.RSA.PublicKey>
        let privateKeyCache: KernelServerPlatform.SimpleMemoryCache<UUID, KernelCryptography.RSA.PrivateKey>
        let sigAlg: KernelCryptography.Algorithms.MessageDigestAlgorithm = .SHA2_256
        
        let encoder: JSONEncoder = .init()
        let decoder: JSONDecoder = .init()
        
        public init() {
            publicKeyCache = .init()
            privateKeyCache = .init()
        }
        
        func initialise(
            storedKeyId: UUID? = nil,
            db: DatabaseID? = nil,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws {
//            guard let cryptoDatabaseID = app.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self) else { throw Abort(.badRequest, reason: "No database") }
            if let storedKeyId {
                app.kernelDI(KernelIdentity.self).config.set(.cryptographyKeyID, value: storedKeyId)
                if let rsaKey = try? await app.kernelDI(KernelCryptography.self).rsa.getComponents(
                    keySetId: .db(storedKeyId),
                    db: db,
                    as: platformActor
                ) {
                    privateKeyCache.set(storedKeyId, value: rsaKey.privateKey(.pkcs1))
                    publicKeyCache.set(storedKeyId, value: rsaKey.publicKey(.pkcs1))
                } else {
                    let newSet = try await app.kernelDI(KernelCryptography.self).rsa.allocateNewSet(
                        keySize: .b2048,
                        providedId: storedKeyId,
                        db: db,
                        as: platformActor
                    )
                    let rsaKey = try newSet.response(withOptions: nil)
                    privateKeyCache.set(storedKeyId, value: rsaKey.privateKey(.pkcs1))
                    publicKeyCache.set(storedKeyId, value: rsaKey.publicKey(.pkcs1))
                }
            } else {
                let newSet = try await app.kernelDI(KernelCryptography.self).rsa.allocateNewSet(
                    keySize: .b2048,
                    db: db,
                    as: platformActor
                )
                let rsaKey = try newSet.response(withOptions: nil)
                let keyId = try newSet.requireID()
                app.kernelDI(KernelIdentity.self).config.set(.cryptographyKeyID, value: storedKeyId)
                privateKeyCache.set(keyId, value: rsaKey.privateKey(.pkcs1))
                publicKeyCache.set(keyId, value: rsaKey.publicKey(.pkcs1))
            }
        }
        
        public func makeJWT<Payload: Codable>(_ payload: Payload) throws -> String {
            guard let cryptographyKeyId = app.kernelDI(KernelIdentity.self).config.get(.cryptographyKeyID, as: UUID.self) else {
                throw Abort(.internalServerError, reason: "No cryptography key ID")
            }
            let header: AuthJWTHeader = .init(alg: "PS256")
            let encodedHeader = try encoder.encode(header).base64URLEncodedBytes()
            let encodedPayload = try encoder.encode(payload).base64URLEncodedBytes()
            let signatureMessage = encodedHeader + [.ascii.period] + encodedPayload
            guard let signature = try privateKeyCache.get(cryptographyKeyId)?.sign(algorithm: sigAlg, message: signatureMessage) else {
                throw Abort(.internalServerError, reason: "Failed to sign JWT")
            }
            let bytes = encodedHeader + [.ascii.period] + encodedPayload + [.ascii.period] + signature.base64URLEncodedBytes()
            return .init(decoding: bytes, as: UTF8.self)
        }
        
        public func verifyJWT<Payload: Codable>(_ jwt: String, as: Payload.Type = Payload.self) throws -> Payload {
            guard let cryptographyKeyId = app.kernelDI(KernelIdentity.self).config.get(.cryptographyKeyID, as: UUID.self) else {
                throw Abort(.internalServerError, reason: "No cryptography key ID")
            }
            let jwtParts: [[UInt8]] = jwt.utf8Bytes.split(separator: .ascii.period).map { .init($0) }
            guard jwtParts.count == 3 else { throw Abort(.badRequest, reason: "Invalid JWT") }
            let signaturePayload = jwtParts[0] + [.ascii.period] + jwtParts[1]
            let signature = jwtParts[2]
            guard let verified = publicKeyCache.get(cryptographyKeyId)?.verify(algorithm: sigAlg, signature: signature.base64URLDecodedBytes(), message: signaturePayload), verified else {
                throw Abort(.unauthorized, reason: "Invalid JWT signature")
            }
            return try decoder.decode(Payload.self, from: .init(jwtParts[1].base64URLDecodedBytes()))
        }
    }
}
