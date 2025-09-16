//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Services.SchemaService {
    public func addRelationship(
        _ relationship: APIModel.QueryableSchema.RelationshipResponse
    ) throws {
        guard !relationshipCache.has(relationship.id) else {
            FeatureContainer.logger.error("Failed to add relationship \(relationship.fromColumn.description) -> \(relationship.toColumn.description): \(relationship.id)")
            throw Abort(.conflict, reason: "Relationship already registered")
        }
        
        relationshipCache.set(relationship.id, value: relationship)
    }
    
    public func getRelationship(
        id relationshipId: UUID
    ) throws -> APIModel.QueryableSchema.RelationshipResponse {
        guard let relationship = relationshipCache.get(relationshipId) else {
            FeatureContainer.logger.error("Failed to get relationship \(relationshipId)")
            throw Abort(.notFound, reason: "Relationship not found")
        }
        return relationship
    }
    
    public func listRelationships(
        forTable tableId: UUID? = nil,
        ofType relationshipType: APIModel.QueryableSchema.RelationshipType? = nil,
        limit: Int? = nil,
        offset: Int? = nil,
        order: KPPaginationOrder? = nil,
        orderBy: String = "id"
    ) throws -> KPPaginatedResponse<APIModel.QueryableSchema.RelationshipResponse> {
        let relationships = try relationshipCache.paginatedFilter(
            limit: limit,
            offset: offset,
            order: (order ?? .ascending).asSortOrder,
            orderBy: orderBy
        ) { relationship in
            var predicate = true
            if let tableId, predicate {
                if let relationshipType {
                    switch relationshipType {
                    case .manyToMany, .oneToMany: predicate = relationship.fromTableId == tableId
                    case .manyToOne, .oneToOne: predicate = relationship.toTableId == tableId
                    }
                } else {
                    predicate = relationship.fromTableId == tableId || relationship.toTableId == tableId
                }
            }
            if let relationshipType, predicate {
                predicate = relationship.relationshipType == relationshipType
            }
            return predicate
        }
        return .init(results: relationships.0, total: relationships.1)
        
    }
    
    public func listChildRelationships(
        forTable tableId: UUID,
        limit: Int? = nil,
        offset: Int? = nil
    ) throws -> KPPaginatedResponse<APIModel.QueryableSchema.RelationshipResponse> {
        let relationships = try relationshipCache.paginatedFilter(
            limit: limit,
            offset: offset,
            orderBy: \.id.uuidString
        ) { relationship in
            relationship.fromTableId == tableId && relationship.relationshipType == .oneToOne
        }
        return .init(results: relationships.0, total: relationships.1)
    }
    
    public func listChildrenRelationships(
        forTable tableId: UUID,
        limit: Int? = nil,
        offset: Int? = nil
    ) throws -> KPPaginatedResponse<APIModel.QueryableSchema.RelationshipResponse> {
        let relationships = try relationshipCache.paginatedFilter(
            limit: limit,
            offset: offset,
            orderBy: \.id.uuidString
        ) { relationship in
            relationship.fromTableId == tableId && relationship.relationshipType == .oneToMany
        }
        return .init(results: relationships.0, total: relationships.1)
    }
    
    public func listParentRelationships(
        forTable tableId: UUID,
        limit: Int? = nil,
        offset: Int? = nil
    ) throws -> KPPaginatedResponse<APIModel.QueryableSchema.RelationshipResponse> {
        let relationships = try relationshipCache.paginatedFilter(
            limit: limit,
            offset: offset,
            orderBy: \.id.uuidString
        ) { relationship in
            relationship.toTableId == tableId && [.oneToOne, .manyToOne].contains(relationship.relationshipType)
        }
        return .init(results: relationships.0, total: relationships.1)
    }
    
    public func listSiblingRelationships(
        forTable tableId: UUID,
        limit: Int? = nil,
        offset: Int? = nil
    ) throws -> KPPaginatedResponse<APIModel.QueryableSchema.RelationshipResponse> {
        let relationships = try relationshipCache.paginatedFilter(
            limit: limit,
            offset: offset,
            orderBy: \.id.uuidString
        ) { relationship in
            relationship.fromTableId == tableId && relationship.relationshipType == .manyToMany
        }
        return .init(results: relationships.0, total: relationships.1)
    }
}
