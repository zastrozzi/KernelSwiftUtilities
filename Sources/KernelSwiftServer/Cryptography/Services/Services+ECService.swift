//
//  ECService.swift
//
//
//  Created by Jimmy Hough Jr on 9/23/23.
//

import Foundation
import Vapor
import KernelSwiftCommon
import Fluent
import NIOConcurrencyHelpers



extension KernelCryptography.Services {
    public struct ECService: Sendable {
        public typealias EC = KernelCryptography.EC
        public typealias Common = KernelCryptography.Common
        
        @KernelDI.Injected(\.vapor) var app: Application

        private let keyGenStatuses: KernelServerPlatform.SimpleMemoryCache<KernelNumerics.EC.Curve, Common.KeyGenStatus>
        private let ecCacheModes: KernelServerPlatform.SimpleMemoryCache<KernelNumerics.EC.Curve, Common.CacheMode>
        private let ecCache: KernelServerPlatform.TaggedMemoryCache<KernelNumerics.EC.Curve, UUID, EC.Components>

        init() {

//            self.app = app
            self.ecCache = .init()
            self.ecCacheModes = .init()
            
            self.keyGenStatuses = .init()
            for oid in KernelNumerics.EC.Curve.allCases {
                self.keyGenStatuses.set(oid, value: .ready)
                self.ecCacheModes.set(oid, value: .disabled(0))
            }
        }
        // awaiting abstracted api
        
        public func replenishCaches(
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws {
            try platformActor.systemOrAdmin()
            let activeKeyTypes = try ecCacheModes.filterEntries(selector: { $1.isActive }).map({ $0.0 })
//            try await activeKeyTypes.chunks(ofCount: 5).asyncForEach { keyTypeChunk in
//                try await keyTypeChunk.concurrentForEach { keyType in
                try await activeKeyTypes.asyncForEach { keyType in
                    try await self.replenishCache(for: keyType, as: platformActor)
                }
//            }
        }
        
        public func replenishCache(
            for keyType: KernelNumerics.EC.Curve,
            round: Int = 0,
            start: TimeInterval = ProcessInfo.processInfo.systemUptime,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws {
            try platformActor.systemOrAdmin()
            guard keyGenStatuses.get(keyType) == .ready else {
                throw Abort(.serviceUnavailable, reason: "EC KEY GENERATOR FOR [\(keyType)] IS BUSY. AWAITING NEXT ROUND")
            }
            var mustRetry: Bool = false
            if case let .active(cacheCount) = ecCacheModes.get(keyType), cacheCount > ecCache.count(for: keyType) {
                let requiredCount = cacheCount - ecCache.count(for: keyType)
                KernelCryptography.logger.info("REPLENISHING EC CACHE [\(keyType)] - \(requiredCount) REQUIRED")
                keyGenStatuses.set(keyType, value: .busy)
                do {
                    for _ in 0..<requiredCount {
                        let newKey = try await KernelCryptography.EC.Components(domain: .init(fromOID: keyType.asObjectId))
                        ecCache.set(.timeOrderedUUIDV4(), tag: keyType, value: newKey)
                    }
                    keyGenStatuses.set(keyType, value: .ready)
                } catch let error {
                    keyGenStatuses.set(keyType, value: .ready)
                    guard round < 20 else { throw error }
                    mustRetry = true
                }
            }
            
            if mustRetry { try await replenishCache(for: keyType, round: round + 1, start: start, as: platformActor) } else {
                let end = ProcessInfo.processInfo.systemUptime
                KernelCryptography.logger.info("REPLENISHING EC CACHE [\(keyType)] - \(end - start)")
            }
        }
        
        public func configureCache(
            _ configuration: KernelCryptography.EC.ConfigureCacheRequest,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws {
            try platformActor.systemOrAdmin()
            for cacheSetting in configuration.cacheSettings {
                let mode: Common.CacheMode = switch cacheSetting.state {
                case .active: .active(cacheSetting.count)
                case .disabled: .disabled(cacheSetting.count)
                case .paused: .paused(cacheSetting.count)
                }
                ecCacheModes.set(cacheSetting.keyType, value: mode)
            }
        }
        
        // get functions
        public func getCacheStatus(
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) throws -> EC.CacheStatusResponse {
            try platformActor.systemOrAdmin()
            var statusReports: [EC.CacheStatusResponse.KeyTypeStatusReport] = []
            for keyType in KernelNumerics.EC.Curve.allCases {
                guard let mode = ecCacheModes.get(keyType), let status = keyGenStatuses.get(keyType) else { continue }
                let count = ecCache.count(for: keyType)
                let cacheState: Common.CacheState
                let target: Int
                (cacheState, target) = switch mode {
                case let .active(targetCount): (.active, targetCount)
                case let .paused(targetCount): (.paused, targetCount)
                case let .disabled(targetCount): (.disabled, targetCount)
                }
                statusReports.append(.init(
                    keyType: keyType,
                    cacheState: cacheState,
                    keyGenStatus: status,
                    availableCount: count,
                    targetCount: target
                ))
            }
            return .init(statusReports: statusReports)
        }

        public func allocateNewSet(
            for keyType: KernelNumerics.EC.Curve,
            on db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> KernelCryptography.Fluent.Model.ECSet {
            try platformActor.systemOrAdmin()
            let newEC = try await getEC(for: keyType, as: platformActor)
            let savedEC = try await KernelCryptography.Fluent.Model.ECSet.create(from: newEC, onDB: self.app.withDBLock(db), withAudit: true, as: platformActor)
            return savedEC
        }
        
        public func getComponents(
            keySetId: Common.KeyIdentifier,
            db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> EC.Components {
            try platformActor.systemOrAdmin()
            let ecSet = switch keySetId {
            case let .db(id): try await KernelCryptography.Fluent.Model.ECSet.find(id, on: self.app.withDBLock(db))
            case let .skid(id): try await KernelCryptography.Fluent.Model.ECSet.query(on: self.app.withDBLock(db)).filter(\.$skidHex == id).first()
            case let .jwks(id): try await KernelCryptography.Fluent.Model.ECSet.query(on: self.app.withDBLock(db)).filter(\.$jwksKid == id).first()
            case let .x509t(id): try await KernelCryptography.Fluent.Model.ECSet.query(on: self.app.withDBLock(db)).filter(\.$x509tKid == id).first()
            }
            guard let ecSet else { throw KernelCryptography.TypedError(.ecSetNotFound) }
            return try await ecSet.response(onDB: self.app.withDBLock(db), withOptions: nil)
        }
        
        public func getPrivateKey(
            keySetId: Common.KeyIdentifier,
            format: EC.KeyFormat,
            db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> KernelASN1.PEMFile {
            try platformActor.systemOrAdmin()
            let ec = try await getComponents(keySetId: keySetId, db: db, as: platformActor)
//            let privateKeyDER = ec.privateKeyPKCS1DER()
            
//            let underlyingKey: KernelX509.Certificate.PrivateKey.UnderlyingKey = .rsa(try .init(derRepresentation: privateKeyDER))
            return .init(for: format.privateKeyPEMFormat, from: ec.privateKey(format))
        }
        
        public func getPublicKey(
            keySetId: Common.KeyIdentifier,
            format: EC.KeyFormat,
            db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> KernelASN1.PEMFile {
            try platformActor.systemOrAdmin()
            let ec = try await getComponents(keySetId: keySetId, db: db, as: platformActor)
//            let key: KernelX509.Certificate.PublicKey = .init(keyAlgorithm: .init(algorithm: .ecPublicKey, parameters: .objectIdentifier(.init(oid: ec.domain.oid))), underlyingKey: .p256(try .init(derRepresentation: ec.publicKeyPKCS1DER())))
            return .init(for: format.publicKeyPEMFormat, from: ec.publicKey(format))
        }
        
        public func getPrivateKeyJSON(
            keySetId: Common.KeyIdentifier,
            db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> KernelCryptography.EC.PrivateKey.JSONRepresentation {
            try platformActor.systemOrAdmin()
            let ec = try await getComponents(keySetId: keySetId, db: db, as: platformActor)
            return .init(from: ec.privateKey(.pkcs8))
        }
        
        public func getPublicKeyJSON(
            keySetId: Common.KeyIdentifier,
            db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> KernelCryptography.EC.PublicKey.JSONRepresentation {
            try platformActor.systemOrAdmin()
            let ec = try await getComponents(keySetId: keySetId, db: db, as: platformActor)
            return .init(from: ec.publicKey(.pkcs8))
        }
        
        public func getPublicKeyHash(
            keySetId: Common.KeyIdentifier,
            db: DatabaseID,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> Common.DerivedKeyIdentifierSetResponse {
            try platformActor.systemOrAdmin()
            let ec = try await getComponents(keySetId: keySetId, db: db, as: platformActor)
            return .init(
                skid: ec.skidString(hashMode: .sha1pkcs1DerHex),
                jwks: ec.jwksKidString(hashMode: .sha1ThumbBase64Url),
                x509t: ec.skidString(hashMode: .sha1X509DerB64)
            )
        }

        // awaiting abstracted api
        func getEC(
            for keyType: KernelNumerics.EC.Curve,
            as platformActor: KernelIdentity.Core.Model.PlatformActor
        ) async throws -> EC.Components {
            try platformActor.systemOrAdmin()
            if ecCache.count(for: keyType) > 0 {
                guard let fromCache = ecCache.takeFirst(for: keyType) else { throw Abort(.badRequest, reason: "No cached EC") }
                KernelCryptography.logger.info("Returning cached EC...")
                return fromCache
            } else {
                KernelCryptography.logger.info("No cached EC. Generating a new one...")
                return try await KernelCryptography.EC.Components(domain: .init(fromOID: keyType.asObjectId))
            }
        }
    }
}
