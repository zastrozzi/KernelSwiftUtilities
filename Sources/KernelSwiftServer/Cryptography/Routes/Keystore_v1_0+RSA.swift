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
    public func bootRSARoutes(routes: TypedRoutesBuilder, tag: String) throws {
        let jwksRoutes = routes.typeGrouped("jwks")
        let cacheRoutes = routes.typeGrouped("cache")
        
        routes.get(":rsaSetId".parameterType(UUID.self), "private-key",  use: getRSAPrivateKeyHandler)
            .summary("Get RSA Private Key")
        
        routes.post(":rsaSetId".parameterType(UUID.self), "private-key", "encrypt",  use: encryptRSAPrivateKeyHandler)
            .summary("Encrypt RSA Private Key")
        
        routes.get(":rsaSetId".parameterType(UUID.self), "public-key",  use: getRSAPublicKeyHandler)
            .summary("Get RSA Public Key")
        
        routes.get(":rsaSetId".parameterType(UUID.self), "public-key-hash",  use: getRSAPublicKeyHashHandler)
            .summary("Get RSA Public Key Hash")
        
        routes.post("create", use: createRSAKeyPairHandler)
            .summary("Create RSA Key Pair")
        
        routes.post("import", "private-key", use: importRSAPrivateKeyHandler).contentTypes(.fromHTTP(.pkcs8))
            .summary("Import RSA Private Key")
        
        jwksRoutes.get(":jwksKeyId".parameterType(String.self), "public-key",  use: getRSAPublicKeyForJWKSKeyIDHandler)
            .summary("Get RSA Public Key for JWKS Key ID")
        
        jwksRoutes.get(":jwksKeyId".parameterType(String.self), "private-key",  use: getRSAPrivateKeyForJWKSKeyIDHandler)
            .summary("Get RSA Private Key for JWKS Key ID")
        
        cacheRoutes.post("config", use: configureRSACacheHandler)
            .summary("Configure RSA Cache")
        
        cacheRoutes.get("status", use: getRSACacheStatusHandler)
            .summary("Get RSA Cache Status")
        
        try cacheRoutes.register(
            collection: KernelTaskScheduler.Routes.TaskSchedulerAdmin_v1_0(
                forContext: .other(tag),
                jobType: KernelCryptography.RSA.ReplenishRSACaches.self
            )
        )
    }
}

extension KernelCryptography.Routes.Keystore_v1_0 {
    public func getRSAPrivateKeyHandler(_ req: TypedRequest<GetRSAPrivateKeyContext>) async throws -> Response {
        let rsaSetId = try req.parameters.require("rsaSetId", as: UUID.self)
        let format: KernelCryptography.RSA.KeyFormat = .init(from: req.headers.accept.first?.mediaType ?? .pemFile)
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        if case .json = format {
            return try await req.response.successJSON.encode(
                try await req.kernelDI(KernelCryptography.self).rsa.getPrivateKeyJSON(
                    keySetId: .db(rsaSetId),
                    db: databaseId,
                    as: req.platformActor
                )
            )
        }
        let pemFile = try await req.kernelDI(KernelCryptography.self).rsa.getPrivateKey(
            keySetId: .db(rsaSetId),
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
    
    public func getRSAPrivateKeyForJWKSKeyIDHandler(_ req: TypedRequest<GetRSAPrivateKeyContext>) async throws -> Response {
        let jwksKeyId = try req.parameters.require("jwksKeyId", as: String.self)
        let format: KernelCryptography.RSA.KeyFormat = .init(from: req.headers.accept.first?.mediaType ?? .pemFile)
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        if case .json = format {
            return try await req.response.successJSON.encode(
                try await req.kernelDI(KernelCryptography.self).rsa.getPrivateKeyJSON(
                    keySetId: .jwks(jwksKeyId),
                    db: databaseId,
                    as: req.platformActor
                )
            )
        }
        let pemFile = try await req.kernelDI(KernelCryptography.self).rsa.getPrivateKey(
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
    
    public func encryptRSAPrivateKeyHandler(_ req: TypedRequest<EncryptRSAPrivateKeyContext>) async throws -> Response {
        let ecSetId = try req.parameters.require("rsaSetId", as: UUID.self)
        let reqBody = try req.decodeBody()
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        let pemFile = try await req.kernelDI(KernelCryptography.self).rsa.getPrivateKey(
            keySetId: .db(ecSetId),
            format: .pkcs8Encrypted(password: reqBody.passwordBytes, aes: reqBody.aes),
            db: databaseId,
            as: req.platformActor
        )
        return try await req.response.success.encode(.init(pemFile))
    }
    
    public func getRSAPublicKeyHandler(_ req: TypedRequest<GetRSAPublicKeyContext>) async throws -> Response {
        let rsaSetId = try req.parameters.require("rsaSetId", as: UUID.self)
        let format: KernelCryptography.RSA.KeyFormat = .init(from: req.headers.accept.first?.mediaType ?? .pemFile)
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        if case .json = format {
            return try await req.response.successJSON.encode(
                try await req.kernelDI(KernelCryptography.self).rsa.getPublicKeyJSON(
                    keySetId: .db(rsaSetId),
                    db: databaseId,
                    as: req.platformActor
                )
            )
        }
        let pemFile = try await req.kernelDI(KernelCryptography.self).rsa.getPublicKey(
            keySetId: .db(rsaSetId),
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
    
    public func getRSAPublicKeyForJWKSKeyIDHandler(_ req: TypedRequest<GetRSAPublicKeyContext>) async throws -> Response {
        let jwksKeyId = try req.parameters.require("jwksKeyId", as: String.self)
        let format: KernelCryptography.RSA.KeyFormat = .init(from: req.headers.accept.first?.mediaType ?? .pemFile)
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        if case .json = format {
            return try await req.response.successJSON.encode(
                try await req.kernelDI(KernelCryptography.self).rsa.getPublicKeyJSON(
                    keySetId: .jwks(jwksKeyId),
                    db: databaseId,
                    as: req.platformActor
                )
            )
        }
        let pemFile = try await req.kernelDI(KernelCryptography.self).rsa.getPublicKey(
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
    
    public func getRSAPublicKeyHashHandler(_ req: TypedRequest<GetRSAPublicKeyHashContext>) async throws -> Response {
        let rsaSetId = try req.parameters.require("rsaSetId", as: UUID.self)
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        let hashes = try await req.kernelDI(KernelCryptography.self).rsa.getPublicKeyHash(
            keySetId: .db(rsaSetId),
            db: databaseId,
            as: req.platformActor
        )
        return try await req.response.success.encode(hashes)
    }
    
    public func createRSAKeyPairHandler(_ req: TypedRequest<CreateRSAKeyPairContext>) async throws -> Response {
        let requestBody = try req.decodeBody()
        let databaseId = req.kernelDI(KernelCryptography.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
        let newRSA = try await req.kernelDI(KernelCryptography.self).rsa.allocateNewSet(
            keySize: requestBody.keySize,
            db: databaseId,
            as: req.platformActor
        )
        return try await req.response.success.encode(newRSA.toRSAKeyPairResponse())
    }
    
    public func importRSAPrivateKeyHandler(_ req: TypedRequest<ImportRSAPrivateKeyContext>) async throws -> Response {
        let requestPem = try req.decodeBody()
        guard let parsed = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: requestPem.pemString) else {
            throw Abort(.badRequest, reason: "Failed to parse PEM string")
        }
        KernelASN1.ASN1Printer.printObjectVerbose(parsed, decodedOctets: true, decodedBits: true)
        let privateKey: KernelCryptography.RSA.PrivateKey = try .init(from: parsed.asn1())
        let storedSet = try await featureContainer.rsa.storePrivateKey(privateKey: privateKey, as: req.platformActor)
        return try await req.response.success.encode(storedSet.toRSAKeyPairResponse())
    }
    
    public func configureRSACacheHandler(_ req: TypedRequest<ConfigureRSACacheContext>) async throws -> Response {
        let requestBody = try req.decodeBody()
        KernelCryptography.logger.debug("\(requestBody)")
        try req.kernelDI(KernelCryptography.self).rsa.configureCache(
            requestBody,
            as: req.platformActor
        )
        let status = try req.kernelDI(KernelCryptography.self).rsa.getCacheStatus(as: req.platformActor)
        return try await req.response.success.encode(status)
    }
    
    public func getRSACacheStatusHandler(_ req: TypedRequest<GetRSACacheStatusContext>) async throws -> Response {
        let status = try req.kernelDI(KernelCryptography.self).rsa.getCacheStatus(as: req.platformActor)
        return try await req.response.success.encode(status)
    }
}

extension KernelCryptography.Routes.Keystore_v1_0 {
    public struct GetRSAPrivateKeyContext: RouteContext {
        public init() {}
        let successPKCS1: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.RSAPrivateKey>> = .success(.ok, .pemFile)
        let successPKCS8: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.PrivateKey>> = .success(.ok, .pkcs8)
        let successJSON: ResponseContext<KernelCryptography.RSA.PrivateKey.JSONRepresentation> = .success(.ok, .json)
    }
    
    public struct EncryptRSAPrivateKeyContext: RouteContext {
        public init() {}
        public typealias RequestBodyType = KernelCryptography.RSA.EncryptPrivateKeyRequest
        let success: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.EncryptedPrivateKey>> = .success(.ok, .pkcs8Encrypted)
    }
    
    public struct GetRSAPublicKeyContext: RouteContext {
        public init() {}
        let successPKCS1: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.RSAPublicKey>> = .success(.ok, .pemFile)
        let successPKCS8: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.PublicKey>> = .success(.ok, .pkcs8)
        let successJSON: ResponseContext<KernelCryptography.RSA.PublicKey.JSONRepresentation> = .success(.ok, .json)
    }
    
    public struct GetRSAPublicKeyHashContext: RouteContext {
        public init() {}
        let success: ResponseContext<KernelCryptography.Common.DerivedKeyIdentifierSetResponse> = .success(.ok)
    }
    
    public typealias CreateRSAKeyPairContext = PostRouteContext<KernelCryptography.RSA.CreateKeyPairRequest, KernelCryptography.RSA.KeyPairResponse>
    public typealias ConfigureRSACacheContext = PostRouteContext<KernelCryptography.RSA.ConfigureCacheRequest, KernelCryptography.RSA.CacheStatusResponse>.WithStatus<HTTPStatus.Accepted>
    public typealias GetRSACacheStatusContext = GetRouteContext<KernelCryptography.RSA.CacheStatusResponse>
    
    public struct ImportRSAPrivateKeyContext: RouteContext {
        public typealias RequestBodyType = KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.PrivateKey>
        public static var defaultContentType: HTTPMediaType? { .pkcs8 }
        public init() {}
        public let success: ResponseContext<KernelCryptography.RSA.KeyPairResponse> = .success(.created)
    }
}
