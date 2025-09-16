//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon
import NIOConcurrencyHelpers

extension KernelCryptography.Services {
    public struct RSAService: DBAccessible, Sendable {
        public typealias RSA = KernelCryptography.RSA
        public typealias FeatureContainer = KernelCryptography
        
        private let rsaCache: KernelServerPlatform.TaggedMemoryCache<RSA.KeySize, UUID, RSA.Components>
        private let rsaCacheModes: KernelServerPlatform.SimpleMemoryCache<RSA.KeySize, KernelCryptography.Common.CacheMode>
        private let keyGenStatuses: KernelServerPlatform.SimpleMemoryCache<RSA.KeySize, Common.KeyGenStatus>
        
        @KernelDI.Injected(\.vapor) public var app: Application
        
        public init(
//            app: Application
        ) {
//            self.app = app
            self.rsaCache = .init()
            self.rsaCacheModes = .init()
            self.keyGenStatuses = .init()
            for size in RSA.KeySize.allCases {
                keyGenStatuses.set(size, value: .ready)
                rsaCacheModes.set(size, value: .disabled(0))
            }
        }
        
        public func replenishCaches(
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws {
            try platformActor.systemOrAdmin()
            let activeKeySizes = try rsaCacheModes.filterEntries(selector: { $1.isActive }).map({ $0.0 })
            try await activeKeySizes.asyncForEach { keySize in
                try await self.replenishCache(for: keySize, as: platformActor)
            }
        }
        
        public func replenishCache(
            for keySize: RSA.KeySize,
            round: Int = 0,
            start: TimeInterval = ProcessInfo.processInfo.systemUptime,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws {
            try platformActor.systemOrAdmin()
            guard keyGenStatuses.get(keySize) == .ready else {
                throw Abort(.serviceUnavailable, reason: "RSA KEY GENERATOR FOR [\(keySize.intValue)] IS BUSY. AWAITING NEXT ROUND")
            }
            var mustRetry: Bool = false
            if case let .active(cacheCount) = rsaCacheModes.get(keySize), cacheCount > rsaCache.count(for: keySize) {
                let requiredCount = cacheCount - rsaCache.count(for: keySize)
                KernelCryptography.logger.info("REPLENISHING RSA CACHE [\(keySize.intValue)] - \(requiredCount) REQUIRED")
                keyGenStatuses.set(keySize, value: .busy)
                do {
                    for _ in 0..<requiredCount {
                        let newKey = try await KernelCryptography.RSA.Components(keySize: keySize)
                        rsaCache.set(.timeOrderedUUIDV4(), tag: keySize, value: newKey)
                    }
                    keyGenStatuses.set(keySize, value: .ready)
                } catch let error {
                    keyGenStatuses.set(keySize, value: .ready)
                    guard round < 20 else { throw error }
                    mustRetry = true
                }
            }
            
            if mustRetry {
                try await replenishCache(
                    for: keySize,
                    round: round + 1,
                    start: start,
                    as: platformActor
                )
            } else {
                let end = ProcessInfo.processInfo.systemUptime
                KernelCryptography.logger.info("REPLENISHING RSA CACHE [\(keySize.intValue)] - \(end - start)")
            }
        }
        
        public func configureCache(
            _ configuration: RSA.ConfigureCacheRequest,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws {
            try platformActor.systemOrAdmin()
            for cacheSetting in configuration.cacheSettings {
                let mode: Common.CacheMode = switch cacheSetting.state {
                case .active: .active(cacheSetting.count)
                case .disabled: .disabled(cacheSetting.count)
                case .paused: .paused(cacheSetting.count)
                }
                rsaCacheModes.set(cacheSetting.keySize, value: mode)
            }
        }
        
        public func getCacheStatus(
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws -> RSA.CacheStatusResponse {
            try platformActor.systemOrAdmin()
            var statusReports: [RSA.CacheStatusResponse.KeySizeStatusReport] = []
            for keySize in RSA.KeySize.allCases {
                guard let mode = rsaCacheModes.get(keySize), let status = keyGenStatuses.get(keySize) else { continue }
                let count = rsaCache.count(for: keySize)
                let cacheState: Common.CacheState
                let target: Int
                (cacheState, target) = switch mode {
                case let .active(targetCount): (.active, targetCount)
                case let .paused(targetCount): (.paused, targetCount)
                case let .disabled(targetCount): (.disabled, targetCount)
                }
                statusReports.append(.init(
                    keySize: keySize,
                    cacheState: cacheState,
                    keyGenStatus: status,
                    availableCount: count,
                    targetCount: target
                ))
            }
            return .init(statusReports: statusReports)
        }
        
        public func getRSA(
            for keySize: RSA.KeySize,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> RSA.Components {
            try platformActor.systemOrAdmin()
            if rsaCache.count(for: keySize) > 0 {
                guard let fromCache = rsaCache.takeFirst(for: keySize) else { throw Abort(.badRequest, reason: "Cache did not contain RSA") }
                KernelCryptography.logger.info("Returning cached RSA\(keySize.intValue)...")
                return fromCache
            } else {
                KernelCryptography.logger.info("No cached RSA\(keySize.intValue). Generating a new one...")
                return try await RSA.Components(keySize: keySize)
            }
        }
        
        public func allocateNewSet(
            keySize: RSA.KeySize,
            providedId: UUID? = nil,
            db: DatabaseID? = nil,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> FluentModel.RSASet {
            try platformActor.systemOrAdmin()
            let newRSA = try await getRSA(for: keySize, as: platformActor)
            if let providedId {
                return try await FluentModel.RSASet.create(from: newRSA, onDB: selectDB(db), withAudit: true, as: platformActor, withOptions: .init(providedId: providedId))
            } else {
                return try await FluentModel.RSASet.create(from: newRSA, onDB: selectDB(db), withAudit: true, as: platformActor)
            }
        }
        
        public func getComponents(
            keySetId: Common.KeyIdentifier,
            db: DatabaseID? = nil,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> RSA.Components {
            try platformActor.systemOrAdmin()
            let rsaSet = switch keySetId {
            case let .db(id): try await FluentModel.RSASet.find(id, on: selectDB(db))
            case let .skid(id): try await FluentModel.RSASet.query(on: selectDB(db)).filter(\.$skidHex == id).first()
            case let .jwks(id): try await FluentModel.RSASet.query(on: selectDB(db)).filter(\.$jwksKid == id).first()
            case let .x509t(id): try await FluentModel.RSASet.query(on: selectDB(db)).filter(\.$x509tKid == id).first()
            }
            guard let rsaSet else { throw KernelCryptography.TypedError(.rsaSetNotFound) }
            return try rsaSet.response()
        }
        
        public func getStoredKey(
            keySetId: Common.KeyIdentifier,
            db: DatabaseID? = nil,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> FluentModel.RSASet {
            try platformActor.systemOrAdmin()
            let rsaSet = switch keySetId {
            case let .db(id): try await FluentModel.RSASet.find(id, on: selectDB(db))
            case let .skid(id): try await FluentModel.RSASet.query(on: selectDB(db)).filter(\.$skidHex == id).first()
            case let .jwks(id): try await FluentModel.RSASet.query(on: selectDB(db)).filter(\.$jwksKid == id).first()
            case let .x509t(id): try await FluentModel.RSASet.query(on: selectDB(db)).filter(\.$x509tKid == id).first()
            }
            guard let rsaSet else { throw KernelCryptography.TypedError(.rsaSetNotFound) }
            return rsaSet
        }
        
        public func getPrivateKey(
            keySetId: Common.KeyIdentifier,
            format: KernelCryptography.RSA.KeyFormat,
            db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> KernelASN1.PEMFile {
            try platformActor.systemOrAdmin()
            let rsa = try await getComponents(keySetId: keySetId, db: db, as: platformActor)
            return .init(for: format.privateKeyPEMFormat, from: rsa.privateKey(format))
        }

        public func getPublicKey(
            keySetId: Common.KeyIdentifier,
            format: KernelCryptography.RSA.KeyFormat,
            db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> KernelASN1.PEMFile {
            try platformActor.systemOrAdmin()
            let rsa = try await getComponents(keySetId: keySetId, db: db, as: platformActor)
            return .init(for: format.publicKeyPEMFormat, from: rsa.publicKey(format))
        }
        
        public func getPrivateKeyJSON(
            keySetId: Common.KeyIdentifier,
            db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> KernelCryptography.RSA.PrivateKey.JSONRepresentation {
            try platformActor.systemOrAdmin()
            let rsa = try await getComponents(keySetId: keySetId, db: db, as: platformActor)
            return .init(from: rsa.privateKey(.pkcs1))
        }
        
        public func getPublicKeyJSON(
            keySetId: Common.KeyIdentifier,
            db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> KernelCryptography.RSA.PublicKey.JSONRepresentation {
            try platformActor.systemOrAdmin()
            let rsa = try await getComponents(keySetId: keySetId, db: db, as: platformActor)
            return .init(from: rsa.publicKey(.pkcs1))
        }

        public func getPublicKeyHash(
            keySetId: Common.KeyIdentifier,
            db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> Common.DerivedKeyIdentifierSetResponse {
            try platformActor.systemOrAdmin()
            let rsa = try await getComponents(keySetId: keySetId, db: db, as: platformActor)
            return .init(
                skid: rsa.skidString(hashMode: .sha1pkcs1DerHex),
                jwks: rsa.jwksKidString(hashMode: .sha1ThumbBase64Url),
                x509t: rsa.skidString(hashMode: .sha1X509DerB64)
            )
        }
        
        public func storePrivateKey(
            privateKey: KernelCryptography.RSA.PrivateKey,
            on db: DatabaseID? = nil,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> FluentModel.RSASet {
            try platformActor.systemOrAdmin()
            let components: RSA.Components = try .init(privateKey: privateKey)
//            components.printSkidStrings()
            return try await FluentModel.RSASet.create(from: components, onDB: selectDB(db), withAudit: true, as: platformActor)
        }
    }
}

