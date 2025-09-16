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
    public func bootActivityRoutesForAdminUser(routes: TypedRoutesBuilder) throws {
        routes.get(use: listActivityHandler).summary("List Admin User Activity")
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public func listActivityHandler(_ req: TypedRequest<ListAdminUserActivityContext>) async throws -> Response {
        let adminUserId = try req.parameters.require("adminUserId", as: UUID.self)
        let queryAdminUser = try await req.kernelDI(KernelIdentity.self).adminUser.getAdminUser(
            id: adminUserId,
            as: req.platformActor
        )
        
        let pagedActivity = try await req.kernelDI(KernelAudit.self).auditEvent
            .listEvents(
                forActor: .adminUser(id: try queryAdminUser.requireID()),
                eventType: req.query.eventType,
                forModel: .init(schema: req.query.affectedSchema, table: req.query.affectedTable, id: req.query.affectedId),
                withPagination: req.decodeDefaultPagination(),
                as: req.platformActor
            )
        return try await req.response.success.encode(.init(results: pagedActivity.results.map { $0.response() }, total: pagedActivity.total))
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public struct ListAdminUserActivityContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public var success: ResponseContext<KPPaginatedResponse<KernelFluentModel.Audit.EventResponse>> = .success(.ok)
        
        public let affectedSchema: QueryParam<String> = .init(name: "affected_schema")
        public let affectedTable: QueryParam<String> = .init(name: "affected_table")
        public let affectedId: QueryParam<UUID> = .init(name: "affected_id")
        public let eventType: QueryParam<KernelFluentModel.Audit.EventActionType> = .init(name: "event_type")
    }
}

