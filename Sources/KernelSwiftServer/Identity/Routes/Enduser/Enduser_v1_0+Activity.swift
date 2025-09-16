//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/08/2024.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelIdentity.Routes.Enduser_v1_0 {
    public func bootActivityRoutesForEnduser(routes: TypedRoutesBuilder) throws {
        routes.get(use: listActivityHandler).summary("List Enduser Activity")
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public func listActivityHandler(_ req: TypedRequest<ListEnduserActivityContext>) async throws -> Response {
        let enduserId = try req.parameters.require("enduserId", as: UUID.self)
        let queryEnduser = try await req.kernelDI(KernelIdentity.self).enduser.getEnduser(
            id: enduserId,
            as: req.platformActor
        )
        
        let pagedActivity = try await req.kernelDI(KernelAudit.self).auditEvent
            .listEvents(
                forActor: .enduser(id: try queryEnduser.requireID()),
                eventType: req.query.eventType,
                forModel: .init(schema: req.query.affectedSchema, table: req.query.affectedTable, id: req.query.affectedId),
                withPagination: req.decodeDefaultPagination(),
                as: req.platformActor
            )
        return try await req.response.success.encode(.init(results: pagedActivity.results.map { $0.response() }, total: pagedActivity.total))
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public struct ListEnduserActivityContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public var success: ResponseContext<KPPaginatedResponse<KernelFluentModel.Audit.EventResponse>> = .success(.ok)
        
        public let affectedSchema: QueryParam<String> = .init(name: "affected_schema")
        public let affectedTable: QueryParam<String> = .init(name: "affected_table")
        public let affectedId: QueryParam<UUID> = .init(name: "affected_id")
        public let eventType: QueryParam<KernelFluentModel.Audit.EventActionType> = .init(name: "event_type")
    }
}
