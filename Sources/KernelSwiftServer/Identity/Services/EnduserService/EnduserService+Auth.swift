//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelIdentity.Services.EnduserService {
    public func loginUser(
        credentials: KernelIdentity.Core.Model.LoginEnduserEmailPasswordRequest,
        localDeviceIdentifier: String,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelIdentity.Core.Model.AuthedUserResponse<KernelIdentity.Core.Model.EnduserResponse> {
        let emails = try await FluentModel.EnduserEmail.query(on: try selectDB(db))
            .filter(\.$emailAddressValue, .equal, credentials.email)
            .with(\.$enduser) {
                $0.with(\.$credentials)
            }
            .all()
        let enduserCredential = emails
            .map { $0.enduser }
            .uniqued { $0.id }
            .map { $0.credentials }
            .reduce(into: []) { $0.append(contentsOf: $1) }
            .filter { $0.credentialType == .emailPassword }
            .first {
                (try? Bcrypt.verify(credentials.password, created: $0.passwordHash ?? "")) ?? false
            }
        guard let enduserCredential else { throw Abort(.unauthorized, reason: "Incorrect email or password") }
        guard enduserCredential.isValid else { throw Abort(.unauthorized, reason: "Invalid email or password") }
        let enduser = try await enduserCredential.$enduser.get(on: selectDB(db))
        guard enduser.onboardingComplete else { throw Abort(.badRequest, reason: "You'll need to complete your onboarding before you can log in.") }
        let device = try await createOrUpdateDevice(forEnduser: enduser.requireID(), deviceIdentifier: localDeviceIdentifier, on: db, as: platformActor)
        try await invalidateSessions(forEnduser: enduser.requireID(), forDevice: device.requireID(), on: db, as: platformActor)
        let session = try await createSession(forEnduser: enduser.requireID(), forDevice: device.requireID(), on: db, as: platformActor)
        let accessToken = try KernelIdentity.Core.Model.AccessTokenPayload(
            userId: enduser.requireID(),
            deviceId: device.requireID(),
            sessionId: session.requireID(),
            roles: "",
            platformRole: .enduser
        )
        let refreshToken = try KernelIdentity.Core.Model.RefreshTokenPayload(
            userId: enduser.requireID(),
            deviceId: device.requireID(),
            sessionId: session.requireID()
        )
        let accessTokenJWT = try app.kernelDI(KernelIdentity.self).auth.makeJWT(accessToken)
        let refreshTokenJWT = try app.kernelDI(KernelIdentity.self).auth.makeJWT(refreshToken)
        return .init(accessToken: accessTokenJWT, refreshToken: refreshTokenJWT, userData: try enduser.response())
    }
    
    public func registerUser(
        from requestBody: KernelIdentity.Core.Model.CreateEnduserRequest,
        localDeviceIdentifier: String,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelIdentity.Core.Model.AuthedUserResponse<KernelIdentity.Core.Model.EnduserResponse> {
        let enduser = try await FluentModel.Enduser.create(from: requestBody, onDB: selectDB(db), withAudit: true, as: platformActor)
        let device = try await createOrUpdateDevice(forEnduser: enduser.requireID(), deviceIdentifier: localDeviceIdentifier, on: db, as: platformActor)
        try await invalidateSessions(forEnduser: enduser.requireID(), forDevice: device.requireID(), on: db, as: platformActor)
        let session = try await createSession(forEnduser: enduser.requireID(), forDevice: device.requireID(), on: db, as: platformActor)
        let accessToken = try KernelIdentity.Core.Model.AccessTokenPayload(
            userId: enduser.requireID(),
            deviceId: device.requireID(),
            sessionId: session.requireID(),
            roles: "",
            platformRole: .enduser
        )
        let refreshToken = try KernelIdentity.Core.Model.RefreshTokenPayload(
            userId: enduser.requireID(),
            deviceId: device.requireID(),
            sessionId: session.requireID()
        )
        let accessTokenJWT = try app.kernelDI(KernelIdentity.self).auth.makeJWT(accessToken)
        let refreshTokenJWT = try app.kernelDI(KernelIdentity.self).auth.makeJWT(refreshToken)
        return .init(accessToken: accessTokenJWT, refreshToken: refreshTokenJWT, userData: try enduser.response())
    }
    
    public func refreshUserToken(
        refreshToken: String,
        localDeviceIdentifier: String,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelIdentity.Core.Model.AuthedUserResponse<KernelIdentity.Core.Model.EnduserResponse> {
        let refreshTokenPayload = try KernelIdentity.Core.Model.RefreshTokenPayload.verify(refreshToken, on: app)
        let session = try await getSession(id: refreshTokenPayload.sessionId, on: db, as: platformActor)
        guard session.isActive else { throw Abort(.unauthorized, reason: "Session has already been logged out") }
        let device = try await session.$device.get(on: selectDB(db))
        guard device.localDeviceIdentifier == localDeviceIdentifier else { throw Abort(.unauthorized, reason: "Wrong device") }
        let enduser = try await getEnduser(id: refreshTokenPayload.userId, on: db, as: platformActor)
        let updatedDevice = try await updateDevice(id: device.requireID(), as: platformActor)
        let accessToken = try KernelIdentity.Core.Model.AccessTokenPayload(
            userId: enduser.requireID(),
            deviceId: updatedDevice.requireID(),
            sessionId: session.requireID(),
            roles: "",
            platformRole: .enduser
        )
        let refreshToken = try KernelIdentity.Core.Model.RefreshTokenPayload(
            userId: enduser.requireID(),
            deviceId: updatedDevice.requireID(),
            sessionId: session.requireID()
        )
        let accessTokenJWT = try app.kernelDI(KernelIdentity.self).auth.makeJWT(accessToken)
        let refreshTokenJWT = try app.kernelDI(KernelIdentity.self).auth.makeJWT(refreshToken)
        return .init(accessToken: accessTokenJWT, refreshToken: refreshTokenJWT, userData: try enduser.response())
    }
    
    public func refreshUserSession(
        forEnduser enduserId: UUID,
        localDeviceIdentifier: String,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelIdentity.Core.Model.AuthedUserResponse<KernelIdentity.Core.Model.EnduserResponse> {
        let enduser = try await getEnduser(id: enduserId, on: db, as: platformActor)
        let device = try await createOrUpdateDevice(forEnduser: enduser.requireID(), deviceIdentifier: localDeviceIdentifier, on: db, as: platformActor)
        let session = try await createSession(forEnduser: enduser.requireID(), forDevice: device.requireID(), on: db, as: platformActor)
        let updatedDevice = try await updateDevice(id: device.requireID(), as: platformActor)
        let accessToken = try KernelIdentity.Core.Model.AccessTokenPayload(
            userId: enduser.requireID(),
            deviceId: updatedDevice.requireID(),
            sessionId: session.requireID(),
            roles: "",
            platformRole: .enduser
        )
        let refreshToken = try KernelIdentity.Core.Model.RefreshTokenPayload(
            userId: enduser.requireID(),
            deviceId: updatedDevice.requireID(),
            sessionId: session.requireID()
        )
        let accessTokenJWT = try app.kernelDI(KernelIdentity.self).auth.makeJWT(accessToken)
        let refreshTokenJWT = try app.kernelDI(KernelIdentity.self).auth.makeJWT(refreshToken)
        return .init(accessToken: accessTokenJWT, refreshToken: refreshTokenJWT, userData: try enduser.response())
    }
        
    
    public func logoutUser(
        sessionId: UUID,
        deviceSet: KernelIdentity.Core.Model.DeviceSet? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        let session = try await getSession(id: sessionId, on: db, as: platformActor)
        guard let deviceSet else { return try await invalidateSessions(forEnduser: session.$enduser.id, forDevice: session.$device.id, on: db, as: platformActor) }
        switch deviceSet {
        case .all: try await invalidateSessions(forEnduser: session.$enduser.id, on: db, as: platformActor)
        case .others: try await invalidateSessions(forEnduser: session.$enduser.id, excludingDevice: session.$device.id, on: db, as: platformActor)
        case let .id(deviceId): try await invalidateSessions(forEnduser: session.$enduser.id, forDevice: deviceId, on: db, as: platformActor)
        }
    }
    
    public func createCredential(
        forEnduser enduserId: UUID,
        from requestBody: KernelIdentity.Core.Model.CreateEnduserCredentialRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserCredential {
        try platformActor.checkEnduser(id: enduserId)
        let newCredential = try await FluentModel.EnduserCredential.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(enduserId: enduserId)
        )
        return newCredential
    }
    
    public func getCredential(
        id credentialId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserCredential {
        guard let credential = try await FluentModel.EnduserCredential.find(credentialId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Credential not found")
        }
        try platformActor.checkEnduser(id: credential.$enduser.id)
        return credential
    }
    
    public func listCredentials(
        forEnduser enduserId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<FluentModel.EnduserCredential> {
        let enduserId = try platformActor.replaceEnduserId(enduserId)
        let credentialCount = try await FluentModel.EnduserCredential.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .count()
        let credentials = try await FluentModel.EnduserCredential.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .paginatedSort(pagination)
            .all()
        return .init(results: credentials, total: credentialCount)
    }
    
    public func updateCredential(
        id credentialId: UUID,
        from requestBody: KernelIdentity.Core.Model.UpdateEnduserCredentialRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserCredential {
        let _ = try await getCredential(id: credentialId, on: db, as: platformActor)
        return try await FluentModel.EnduserCredential.update(
            id: credentialId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteCredential(
        id credentialId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        let _ = try await getCredential(id: credentialId, on: db, as: platformActor)
        try await FluentModel.EnduserCredential.delete(
            force: force,
            id: credentialId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}

