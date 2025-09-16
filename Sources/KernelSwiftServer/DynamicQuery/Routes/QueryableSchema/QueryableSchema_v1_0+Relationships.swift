//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Routes.QueryableSchema_v1_0 {
    public func bootRelationshipRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(use: listRelationshipsHandler).summary("List Relationships")
        routes.get(":relationshipId".parameterType(UUID.self).description("Relationship ID"), use: getRelationshipHandler).summary("Get Relationship")
    }
    
    public func bootRelationshipRoutesForTable(routes: TypedRoutesBuilder) throws {
        routes.get("child", use: listChildRelationshipsHandler).summary("List Child Relationships for Table")
        routes.get("children", use: listChildrenRelationshipsHandler).summary("List Children Relationships for Table")
        routes.get("parent", use: listParentRelationshipsHandler).summary("List Parent Relationships for Table")
        routes.get("siblings", use: listSiblingRelationshipsHandler).summary("List Sibling Relationships for Table")
        routes.get(use: listRelationshipsHandler).summary("List Relationships for Table")
    }
}

extension KernelDynamicQuery.Routes.QueryableSchema_v1_0 {
    public func getRelationshipHandler(_ req: TypedRequest<GetRelationshipContext>) async throws -> Response {
        let relationship = try featureContainer.services.schema.getRelationship(
            id: req.parameters.require("relationshipId")
        )
        return try await req.response.success.encode(relationship)
    }
    
    public func listRelationshipsHandler(_ req: TypedRequest<ListRelationshipsContext>) async throws -> Response {
        let relationships = try featureContainer.services.schema.listRelationships(
            forTable: req.parameters.get("tableId"),
            ofType: req.query.relationshipType?.value,
            limit: req.query.limit,
            offset: req.query.offset,
            order: req.query.order?.value,
            orderBy: req.query.withDefault(\.orderBy)
        )
        return try await req.response.success.encode(relationships)
    }
    
    public func listChildRelationshipsHandler(_ req: TypedRequest<ListRelationshipsContext>) async throws -> Response {
        let relationships = try featureContainer.services.schema.listChildRelationships(
            forTable: req.parameters.require("tableId"),
            limit: req.query.limit,
            offset: req.query.offset
        )
        return try await req.response.success.encode(relationships)
    }
    
    public func listChildrenRelationshipsHandler(_ req: TypedRequest<ListRelationshipsContext>) async throws -> Response {
        let relationships = try featureContainer.services.schema.listChildrenRelationships(
            forTable: req.parameters.require("tableId"),
            limit: req.query.limit,
            offset: req.query.offset
        )
        return try await req.response.success.encode(relationships)
    }
    
    public func listParentRelationshipsHandler(_ req: TypedRequest<ListRelationshipsContext>) async throws -> Response {
        let relationships = try featureContainer.services.schema.listParentRelationships(
            forTable: req.parameters.require("tableId"),
            limit: req.query.limit,
            offset: req.query.offset
        )
        return try await req.response.success.encode(relationships)
    }
    
    public func listSiblingRelationshipsHandler(_ req: TypedRequest<ListRelationshipsContext>) async throws -> Response {
        let relationships = try featureContainer.services.schema.listSiblingRelationships(
            forTable: req.parameters.require("tableId"),
            limit: req.query.limit,
            offset: req.query.offset
        )
        return try await req.response.success.encode(relationships)
    }
    
}

extension KernelDynamicQuery.Routes.QueryableSchema_v1_0 {
    public typealias GetRelationshipContext = GetRouteContext<APIModel.QueryableSchema.RelationshipResponse>
    
    public struct ListRelationshipsContext: RouteContext {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<APIModel.QueryableSchema.RelationshipResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit")
        public let offset: QueryParam<Int> = .init(name: "offset")
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .ascending)
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "id")
        public let relationshipType: EnumQueryParam<APIModel.QueryableSchema.RelationshipType> = .init(name: "relationship_type")
    }
}
