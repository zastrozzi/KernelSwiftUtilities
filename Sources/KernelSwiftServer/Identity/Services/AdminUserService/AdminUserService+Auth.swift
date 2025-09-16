//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelIdentity.Services.AdminUserService {
    public func loginUser(
        credentials: KernelIdentity.Core.Model.LoginAdminUserEmailPasswordRequest,
        localDeviceIdentifier: String,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelIdentity.Core.Model.AuthedUserResponse<KernelIdentity.Core.Model.AdminUserResponse> {
        let emails = try await FluentModel.AdminUserEmail.query(on: try selectDB(db))
            .filter(\.$emailAddressValue, .equal, credentials.email)
            .with(\.$adminUser) {
                $0.with(\.$credentials)
            }
            .all()
        let adminUserCredential = emails
            .map { $0.adminUser }
            .uniqued { $0.id }
            .map { $0.credentials }
            .reduce(into: []) { $0.append(contentsOf: $1) }
            .filter { $0.credentialType == .emailPassword }
            .first {
                (try? Bcrypt.verify(credentials.password, created: $0.passwordHash ?? "")) ?? false
            }
        guard let adminUserCredential else { throw Abort(.unauthorized, reason: "Incorrect email or password") }
        guard adminUserCredential.isValid else { throw Abort(.unauthorized, reason: "Invalid email or password") }
        let adminUser = try await adminUserCredential.$adminUser.get(on: selectDB(db))
        let adminUserPlatformActor = KernelIdentity.Core.Model.PlatformActor.adminUser(id: try adminUser.requireID())
        
        let device = try await createOrUpdateDevice(
            forAdminUser: adminUser.requireID(),
            deviceIdentifier: localDeviceIdentifier,
            on: db,
            as: adminUserPlatformActor
        )
        
        try await invalidateSessions(
            forAdminUser: adminUser.requireID(),
            forDevice: device.requireID(),
            on: db,
            as: adminUserPlatformActor
        )
        
        let session = try await createSession(
            forAdminUser: adminUser.requireID(),
            forDevice: device.requireID(),
            on: db,
            as: adminUserPlatformActor
        )
        
        let accessToken = try KernelIdentity.Core.Model.AccessTokenPayload(
            userId: adminUser.requireID(),
            deviceId: device.requireID(),
            sessionId: session.requireID(),
            roles: adminUser.role,
            platformRole: .adminUser
        )
        let refreshToken = try KernelIdentity.Core.Model.RefreshTokenPayload(
            userId: adminUser.requireID(),
            deviceId: device.requireID(),
            sessionId: session.requireID()
        )
        let accessTokenJWT = try app.kernelDI(KernelIdentity.self).auth.makeJWT(accessToken)
        let refreshTokenJWT = try app.kernelDI(KernelIdentity.self).auth.makeJWT(refreshToken)
        return .init(accessToken: accessTokenJWT, refreshToken: refreshTokenJWT, userData: try adminUser.response())
    }
    
    public func refreshUserToken(
        refreshToken: String,
        localDeviceIdentifier: String,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelIdentity.Core.Model.AuthedUserResponse<KernelIdentity.Core.Model.AdminUserResponse> {
        guard case .system = platformActor else { throw Abort(.unauthorized, reason: "Insufficicent permissions") }
        let refreshTokenPayload = try KernelIdentity.Core.Model.RefreshTokenPayload.verify(refreshToken, on: app)
        let session = try await getSession(id: refreshTokenPayload.sessionId, on: db, as: platformActor)
        guard session.isActive else { throw Abort(.unauthorized, reason: "Session has already been logged out") }
        let device = try await session.$device.get(on: selectDB(db))
        guard device.localDeviceIdentifier == localDeviceIdentifier else { throw Abort(.unauthorized, reason: "Wrong device") }
        let adminUser = try await getAdminUser(id: refreshTokenPayload.userId, on: db, as: platformActor)
        let updatedDevice = try await updateDevice(id: device.requireID(), as: platformActor)
        let accessToken = try KernelIdentity.Core.Model.AccessTokenPayload(
            userId: adminUser.requireID(),
            deviceId: updatedDevice.requireID(),
            sessionId: session.requireID(),
            roles: adminUser.role,
            platformRole: .adminUser
        )
        let refreshToken = try KernelIdentity.Core.Model.RefreshTokenPayload(
            userId: adminUser.requireID(),
            deviceId: updatedDevice.requireID(),
            sessionId: session.requireID()
        )
        let accessTokenJWT = try app.kernelDI(KernelIdentity.self).auth.makeJWT(accessToken)
        let refreshTokenJWT = try app.kernelDI(KernelIdentity.self).auth.makeJWT(refreshToken)
        return .init(accessToken: accessTokenJWT, refreshToken: refreshTokenJWT, userData: try adminUser.response())
    }
    
    public func logoutUser(
        sessionId: UUID,
        deviceSet: KernelIdentity.Core.Model.DeviceSet? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let session = try await getSession(id: sessionId, on: db, as: platformActor)
        switch deviceSet {
        case .all: try await invalidateSessions(forAdminUser: session.$adminUser.id, on: db, as: platformActor)
        case .others: try await invalidateSessions(forAdminUser: session.$adminUser.id, excludingDevice: session.$device.id, on: db, as: platformActor)
        case let .id(deviceId): try await invalidateSessions(forAdminUser: session.$adminUser.id, forDevice: deviceId, on: db, as: platformActor)
        case .none: try await invalidateSessions(forAdminUser: session.$adminUser.id, forDevice: session.$device.id, on: db, as: platformActor)
        }
    }
    
    public func createCredential(
        forAdminUser adminUserId: UUID,
        from requestBody: KernelIdentity.Core.Model.CreateAdminUserCredentialRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserCredential {
        try platformActor.systemOrAdmin()
        let newCredential = try await FluentModel.AdminUserCredential.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(adminUserId: adminUserId)
        )
        return newCredential
    }
    
    public func getCredential(
        id credentialId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserCredential {
        try platformActor.systemOrAdmin()
        guard let credential = try await FluentModel.AdminUserCredential.find(credentialId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Credential not found")
        }
        return credential
    }
    
    public func listCredentials(
        forAdminUser adminUserId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        credentialTypeFilters: FluentEnumFilterQueryParamObject<KernelIdentity.Core.Model.CredentialType>? = nil,
        isValid: Bool? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<FluentModel.AdminUserCredential> {
        try platformActor.systemOrAdmin()
        let selectedDB: Database = try selectDB(db)
        
        let dateFilters = FluentModel.AdminUserCredential.query(on: selectedDB)
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
        
        let enumFilters = FluentModel.AdminUserCredential.query(on: selectedDB)
            .filterIfPresent(\.$credentialType, enumFilters: credentialTypeFilters)
        
        let boolFilters = FluentModel.AdminUserCredential.query(on: selectedDB)
            .filterIfPresent(\.$isValid, .equal, isValid)
        
        let relationFilters = FluentModel.AdminUserCredential.query(on: selectedDB)
            .filterIfPresent(\.$adminUser.$id, .equal, adminUserId)
        
        let credentialCount = try await FluentModel.AdminUserCredential.query(on: selectedDB)
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, enumFilters, boolFilters, relationFilters)
            .count()
        
        let credentials = try await FluentModel.AdminUserCredential.query(on: selectedDB)
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, enumFilters, boolFilters, relationFilters)
            .paginatedSort(pagination)
            .all()
        
        return .init(results: credentials, total: credentialCount)
    }
    
    public func updateCredential(
        id credentialId: UUID,
        from requestBody: KernelIdentity.Core.Model.UpdateAdminUserCredentialRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserCredential {
        try platformActor.systemOrAdmin()
        return try await FluentModel.AdminUserCredential.update(
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
        try platformActor.systemOrAdmin()
        try await FluentModel.AdminUserCredential.delete(
            force: force,
            id: credentialId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}

