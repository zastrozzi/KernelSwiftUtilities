//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 1/5/24.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelWebFront.Fluent.Model {
    public final class FlowContinuation: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.flowContinuation
        
        @ID(key: .id) public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        @Field(key: "condition") public var condition: String
        @Parent(key: "parent_node_id") public var parentNode: FlowNode
        @Parent(key: "child_node_id") public var childNode: FlowNode
        
        public init() {}
    }
}

extension KernelWebFront.Fluent.Model.FlowContinuation: CRUDModel {
    public typealias CreateDTO = KernelWebFront.Model.Flows.CreateFlowContinuationRequest
    public typealias UpdateDTO = KernelWebFront.Model.Flows.UpdateFlowContinuationRequest
    public typealias ResponseDTO = KernelWebFront.Model.Flows.FlowContinuationResponse
    
    public struct CreateOptions: Sendable {
        public var parentNodeId: UUID
        
        public init(
            parentNodeId: UUID
        ) {
            self.parentNodeId = parentNodeId
        }
    }
    
    public struct UpdateOptions: Sendable {
        public var parentNodeId: UUID
        
        public init(
            parentNodeId: UUID
        ) {
            self.parentNodeId = parentNodeId
        }
    }
    
    public typealias ResponseOptions = KernelFluentModel.EmptyResponseOptions
    
    public static func createFields(
        from dto: KernelWebFront.Model.Flows.CreateFlowContinuationRequest,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        guard let options else { throw Abort(.badRequest, reason: "No create options provided") }
        let model = self.init()
        model.$childNode.id = dto.childNodeId
        model.$parentNode.id = options.parentNodeId
        model.condition = dto.condition
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: KernelWebFront.Model.Flows.UpdateFlowContinuationRequest,
        withOptions options: UpdateOptions? = nil
    ) throws {
        model.$childNode.id = dto.childNodeId
        model.$parentNode.id = options?.parentNodeId ?? model.$parentNode.id
        model.condition = dto.condition ?? model.condition
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> KernelWebFront.Model.Flows.FlowContinuationResponse {
        .init(
            dbCreatedAt: dbCreatedAt,
            dbUpdatedAt: dbUpdatedAt,
            dbDeletedAt: dbDeletedAt,
            condition: condition,
            childNodeId: $childNode.id
        )
    }
}
