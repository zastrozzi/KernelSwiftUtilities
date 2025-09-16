//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/12/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelDI.Injector {
    public var keystoreService: KernelCryptography.Services.Keystore {
        get { self[KernelCryptography.Services.Keystore.Token.self] }
        set { self[KernelCryptography.Services.Keystore.Token.self] = newValue }
    }
}

extension KernelCryptography.Services {
    public struct Keystore: KernelDI.Injectable, Sendable {
        
        @KernelDI.Injected(\.vapor) var app: Application
        
        public init() {}
        
        public func findPublicKey(
            keyId: Common.KeyIdentifier,
            on db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> FluentModel.PublicKey? {
            try platformActor.systemOrAdmin()
            let publicKey = switch keyId {
            case let .db(id): try await FluentModel.PublicKey.find(id, on: self.app.withDBLock(db))
            case let .skid(id): try await FluentModel.PublicKey.query(on: self.app.withDBLock(db)).filter(\.$keyIdentifier.$hex == id).first()
            case let .jwks(id): try await FluentModel.PublicKey.query(on: self.app.withDBLock(db)).filter(\.$keyIdentifier.$jwks == id).first()
            case let .x509t(id): try await FluentModel.PublicKey.query(on: self.app.withDBLock(db)).filter(\.$keyIdentifier.$x509t == id).first()
            }
            return publicKey
        }
        
        public func storePublicKeyFromX509Cert(
            _ certPubKey: KernelX509.Certificate.PublicKey,
            _ certExtension: KernelX509.Extension.SubjectKeyIdentifier? = nil,
            on db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> FluentModel.PublicKey {
            try platformActor.systemOrAdmin()
            let certExtSkid = certExtension?.keyIdentifier.toHexString(spaced: false, uppercased: true)
            let certPubKeySkid = certPubKey.getDerivedIdentifier(idType: .skid).asString
            let certPubKeyJwks = certPubKey.getDerivedIdentifier(idType: .jwks).asString
            let certPubKeyX509t = certPubKey.getDerivedIdentifier(idType: .x509t).asString
            guard
                try await FluentModel.PublicKey.query(on: self.app.withDBLock(db))
                .group(.or, { or in
                    if let certExtSkid { or.filter(\.$keyIdentifier.$hex == certExtSkid) }
                    or.filter(\.$keyIdentifier.$hex == certPubKeySkid)
                    or.filter(\.$keyIdentifier.$jwks == certPubKeyJwks)
                    or.filter(\.$keyIdentifier.$x509t == certPubKeyX509t)
                })
                .count() == .zero
            else { throw Abort(.badRequest, reason: "Already exists") }
            let publicKey: KernelCryptography.Fluent.Model.PublicKey = .init()
            switch certPubKey.underlyingKey {
            case let .ec(ecKey):
                publicKey.ec = try .createFields(from: ecKey)
            case let .rsa(rsaKey):
                publicKey.rsa = try .createFields(from: rsaKey)
            }
            publicKey.keyIdentifier.hex = certExtSkid ?? certPubKeySkid
            publicKey.keyIdentifier.x509t = certPubKeyX509t
            publicKey.keyIdentifier.jwks = certPubKeyJwks
            
            try await publicKey.create(on: self.app.withDBLock(db))
            return publicKey
        }
        
    }
}
