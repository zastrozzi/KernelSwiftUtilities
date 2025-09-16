//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelCryptography.Routes.Keystore_v1_0 {
    public func bootECRoutes(routes: TypedRoutesBuilder, tag: String) throws {
        let jwksRoutes = routes.typeGrouped("jwks")
        let cacheRoutes = routes.typeGrouped("cache")
        
        routes.get(":ecSetId".parameterType(UUID.self), "private-key",  use: getECPrivateKeyHandler)
            .summary("Get EC Private Key")
        
        routes.post(":ecSetId".parameterType(UUID.self), "private-key", "encrypt",  use: encryptECPrivateKeyHandler)
            .summary("Encrypt EC Private Key")
        
        routes.get(":ecSetId".parameterType(UUID.self), "public-key",  use: getECPublicKeyHandler)
            .summary("Get EC Public Key")
        
        routes.get(":ecSetId".parameterType(UUID.self), "public-key-hash",  use: getECPublicKeyHashHandler)
            .summary("Get EC Public Key Hash")
        
        routes.post("create", use: createECKeyPairHandler)
            .summary("Create EC Key Pair")
        
        jwksRoutes.get(":jwksKeyId".parameterType(String.self), "public-key",  use: getECPublicKeyForJWKSKeyIDHandler)
            .summary("Get EC Public Key for JWKS Key ID")
        
        jwksRoutes.get(":jwksKeyId".parameterType(String.self), "private-key",  use: getECPrivateKeyForJWKSKeyIDHandler)
            .summary("Get EC Private Key for JWKS Key ID")
        
        cacheRoutes.post("config", use: configureECCacheHandler)
            .summary("Configure EC Cache")
        
        cacheRoutes.get("status", use: getECCacheStatusHandler)
            .summary("Get EC Cache Status")
        
        try cacheRoutes.register(
            collection: KernelTaskScheduler.Routes.TaskSchedulerAdmin_v1_0(
                forContext: .other(tag),
                jobType: KernelCryptography.EC.ReplenishECCaches.self
            )
        )
    }
}

extension KernelCryptography.Routes.Keystore_v1_0 {
    public func getECPrivateKeyHandler(_ req: TypedRequest<GetECPrivateKeyContext>) async throws -> Response {
        let ecSetId = try req.parameters.require("ecSetId", as: UUID.self)
        let format: KernelCryptography.EC.KeyFormat = .init(from: req.headers.accept.first?.mediaType ?? .pemFile)
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        if case .json = format {
            return try await req.response.successJSON.encode(
                try await req.kernelDI(KernelCryptography.self).ec.getPrivateKeyJSON(
                    keySetId: .db(ecSetId),
                    db: databaseId,
                    as: req.platformActor
                )
            )
        }
        let pemFile = try await req.kernelDI(KernelCryptography.self).ec.getPrivateKey(
            keySetId: .db(ecSetId),
            format: format,
            db: databaseId,
            as: req.platformActor
        )
        switch format {
        case .pkcs1: return try await req.response.successPKCS1.encode(.init(pemFile))
        case .pkcs8: return try await req.response.successPKCS8.encode(.init(pemFile))
        default: throw KernelCryptography.TypedError(.implementationMissing)
        }
    }
    
    public func encryptECPrivateKeyHandler(_ req: TypedRequest<EncryptECPrivateKeyContext>) async throws -> Response {
        let ecSetId = try req.parameters.require("ecSetId", as: UUID.self)
        let reqBody = try req.decodeBody()
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        let pemFile = try await req.kernelDI(KernelCryptography.self).ec.getPrivateKey(
            keySetId: .db(ecSetId),
            format: .pkcs8Encrypted(password: reqBody.passwordBytes, aes: reqBody.aes),
            db: databaseId,
            as: req.platformActor
        )
        return try await req.response.success.encode(.init(pemFile))
    }
    
    public func getECPrivateKeyForJWKSKeyIDHandler(_ req: TypedRequest<GetECPrivateKeyContext>) async throws -> Response {
        let jwksKeyId = try req.parameters.require("jwksKeyId", as: String.self)
        let format: KernelCryptography.EC.KeyFormat = .init(from: req.headers.accept.first?.mediaType ?? .pemFile)
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        if case .json = format {
            return try await req.response.successJSON.encode(
                try await req.kernelDI(KernelCryptography.self).ec.getPrivateKeyJSON(
                    keySetId: .jwks(jwksKeyId),
                    db: databaseId,
                    as: req.platformActor
                )
            )
        }
        let pemFile = try await req.kernelDI(KernelCryptography.self).ec.getPrivateKey(
            keySetId: .jwks(jwksKeyId),
            format: format,
            db: databaseId,
            as: req.platformActor
        )
        switch format {
        case .pkcs1: return try await req.response.successPKCS1.encode(.init(pemFile))
        case .pkcs8: return try await req.response.successPKCS8.encode(.init(pemFile))
        default: throw KernelCryptography.TypedError(.implementationMissing)
        }
    }
    
    public func getECPublicKeyHandler(_ req: TypedRequest<GetECPublicKeyContext>) async throws -> Response {
        let ecSetId = try req.parameters.require("ecSetId", as: UUID.self)
        let format: KernelCryptography.EC.KeyFormat = .init(from: req.headers.accept.first?.mediaType ?? .pemFile)
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        if case .json = format {
            return try await req.response.successJSON.encode(
                try await req.kernelDI(KernelCryptography.self).ec.getPublicKeyJSON(
                    keySetId: .db(ecSetId),
                    db: databaseId,
                    as: req.platformActor
                )
            )
        }
        let pemFile = try await req.kernelDI(KernelCryptography.self).ec.getPublicKey(
            keySetId: .db(ecSetId),
            format: format,
            db: databaseId,
            as: req.platformActor
        )
        switch format {
        case .pkcs1: return try await req.response.successPKCS1.encode(.init(pemFile))
        case .pkcs8: return try await req.response.successPKCS8.encode(.init(pemFile))
        default: throw KernelCryptography.TypedError(.implementationMissing)
        }
    }
    
    public func getECPublicKeyForJWKSKeyIDHandler(_ req: TypedRequest<GetECPublicKeyContext>) async throws -> Response {
        let jwksKeyId = try req.parameters.require("jwksKeyId", as: String.self)
        let format: KernelCryptography.EC.KeyFormat = .init(from: req.headers.accept.first?.mediaType ?? .pemFile)
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        if case .json = format {
            return try await req.response.successJSON.encode(
                try await req.kernelDI(KernelCryptography.self).ec.getPublicKeyJSON(
                    keySetId: .jwks(jwksKeyId),
                    db: databaseId,
                    as: req.platformActor
                )
            )
        }
        let pemFile = try await req.kernelDI(KernelCryptography.self).ec.getPublicKey(
            keySetId: .jwks(jwksKeyId),
            format: format,
            db: databaseId,
            as: req.platformActor
        )
        switch format {
        case .pkcs1: return try await req.response.successPKCS1.encode(.init(pemFile))
        case .pkcs8: return try await req.response.successPKCS8.encode(.init(pemFile))
        default: throw KernelCryptography.TypedError(.implementationMissing)
        }
    }
    
    public func getECPublicKeyHashHandler(_ req: TypedRequest<GetECPublicKeyHashContext>) async throws -> Response {
        let ecSetId = try req.parameters.require("ecSetId", as: UUID.self)
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        let hashes = try await req.kernelDI(KernelCryptography.self).ec.getPublicKeyHash(
            keySetId: .db(ecSetId),
            db: databaseId,
            as: req.platformActor
        )
        return try await req.response.success.encode(hashes)
    }
    
    public func createECKeyPairHandler(_ req: TypedRequest<CreateECKeyPairContext>) async throws -> Response {
        let requestBody = try req.decodeBody()
        KernelCryptography.logger.debug("\(requestBody)")
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        let newEC = try await req.kernelDI(KernelCryptography.self).ec.allocateNewSet(
            for: requestBody.keyType,
            on: databaseId,
            as: req.platformActor
        )
        return try await req.response.success.encode(newEC.toKeyPairResponse())
    }
    
    public func configureECCacheHandler(_ req: TypedRequest<ConfigureECCacheContext>) async throws -> Response {
        let requestBody = try req.decodeBody()
        KernelCryptography.logger.debug("\(requestBody)")
        try req.kernelDI(KernelCryptography.self).ec.configureCache(
            requestBody,
            as: req.platformActor
        )
        let status = try req.kernelDI(KernelCryptography.self).ec.getCacheStatus(as: req.platformActor)
        return try await req.response.success.encode(status)
    }
    
    public func getECCacheStatusHandler(_ req: TypedRequest<GetECCacheStatusContext>) async throws -> Response {
        let status = try req.kernelDI(KernelCryptography.self).ec.getCacheStatus(as: req.platformActor)
        return try await req.response.success.encode(status)
    }
}

extension KernelCryptography.Routes.Keystore_v1_0 {
    public struct GetECPrivateKeyContext: RouteContext {
        public init() {}
        
        let successPKCS1: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.ECPrivateKey>> = .success(.ok, .pemFile)
        let successPKCS8: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.PrivateKey>> = .success(.ok, .pkcs8)
        let successJSON: ResponseContext<KernelCryptography.EC.PrivateKey.JSONRepresentation> = .success(.ok, .json)
    }
    
    public struct EncryptECPrivateKeyContext: RouteContext {
        public init() {}
        public typealias RequestBodyType = KernelCryptography.EC.EncryptPrivateKeyRequest
        let success: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.EncryptedPrivateKey>> = .success(.ok, .pkcs8Encrypted)
    }
    
    public struct GetECPublicKeyContext: RouteContext {
        public init() {}
        let successPKCS1: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.PublicKey>> = .success(.ok, .pemFile)
        let successPKCS8: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.PublicKey>> = .success(.ok, .pkcs8)
        let successJSON: ResponseContext<KernelCryptography.EC.PublicKey.JSONRepresentation> = .success(.ok, .json)
    }
    
    public struct GetECPublicKeyHashContext: RouteContext {
        public init() {}
        let success: ResponseContext<KernelCryptography.Common.DerivedKeyIdentifierSetResponse> = .success(.ok)
    }
    
    public typealias CreateECKeyPairContext = PostRouteContext<KernelCryptography.EC.CreateKeyPairRequest, KernelCryptography.EC.KeyPairResponse>
    public typealias ConfigureECCacheContext = PostRouteContext<KernelCryptography.EC.ConfigureCacheRequest, KernelCryptography.EC.CacheStatusResponse>.WithStatus<HTTPStatus.Accepted>
    public typealias GetECCacheStatusContext = GetRouteContext< KernelCryptography.EC.CacheStatusResponse>
}
