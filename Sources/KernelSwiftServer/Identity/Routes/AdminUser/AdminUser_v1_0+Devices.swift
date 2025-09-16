//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public func bootDeviceRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":deviceId".parameterType(UUID.self), use: getDeviceHandler).summary("Get Admin User Device")
        routes.get(use: listDevicesHandler).summary("List Admin User Devices")
    }
    
    public func bootDeviceRoutesForAdminUser(routes: TypedRoutesBuilder) throws {
        routes.get(use: listDevicesHandler).summary("List Devices for Admin User")
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public func getDeviceHandler(_ req: TypedRequest<GetAdminUserDeviceContext>) async throws -> Response {
        let deviceId = try req.parameters.require("deviceId", as: UUID.self)
        let device = try await req.kernelDI(KernelIdentity.self).adminUser.getDevice(id: deviceId, as: req.platformActor)
        return try await req.response.success.encode(device.response())
    }
    
    public func listDevicesHandler(_ req: TypedRequest<ListAdminUserDevicesContext>) async throws -> Response {
        let pagedDevices = try await req.kernelDI(KernelIdentity.self).adminUser
            .listDevices(
                forAdminUser: req.parameters.get("adminUserId"),
                withPagination: req.decodeDefaultPagination(),
                dbCreatedAtFilters: req.query.dbCreatedAt,
                dbUpdatedAtFilters: req.query.dbUpdatedAt,
                dbDeletedAtFilters: req.query.dbDeletedAt,
                userAgentFilters: req.query.userAgent,
                systemFilters: req.query.system,
                osVersionFilters: req.query.osVersion,
                apnsPushTokenFilters: req.query.apnsPushToken,
                fcmPushTokenFilters: req.query.fcmPushToken,
                localDeviceIdentifierFilters: req.query.localDeviceIdentifier,
                lastSeenAtFilters: req.query.lastSeenAt,
                as: req.platformActor
            )
        return try await req.response.success.encode(pagedDevices.paginatedResponse())
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public typealias GetAdminUserDeviceContext = GetRouteContext<KernelIdentity.Core.Model.AdminUserDeviceResponse>
    
    public struct ListAdminUserDevicesContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<KernelIdentity.Core.Model.AdminUserDeviceResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
        public let userAgent: StringFilterQueryParam = .init(name: "user_agent")
        public let system: FluentEnumFilterQueryParam<KernelIdentity.Core.Model.DeviceSystem> = .init(name: "system")
        public let osVersion: StringFilterQueryParam = .init(name: "os_version")
        public let apnsPushToken: StringFilterQueryParam = .init(name: "apns_push_token")
        public let fcmPushToken: StringFilterQueryParam = .init(name: "fcm_push_token")
        public let localDeviceIdentifier: StringFilterQueryParam = .init(name: "local_device_identifier")
        public let lastSeenAt: DateFilterQueryParam = .init(name: "last_seen_at")
    }
    
    public typealias DeleteAdminUserDeviceContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}

