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
    public final class FlowContainer: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.flowContainer
        
        @ID(key: .id) public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        @Field(key: "name") public var name: String
        @OptionalParent(key: "entry_node_id") public var entryNode: FlowNode?
        
        public init() {}
    }
}

extension KernelWebFront.Fluent.Model.FlowContainer: CRUDModel {
    public typealias CreateDTO = KernelWebFront.Model.Flows.CreateFlowContainerRequest
    public typealias UpdateDTO = KernelWebFront.Model.Flows.UpdateFlowContainerRequest
    public typealias ResponseDTO = KernelWebFront.Model.Flows.FlowContainerResponse
    public typealias CreateOptions = KernelFluentModel.EmptyCreateOptions
    public typealias UpdateOptions = KernelFluentModel.EmptyUpdateOptions
    public typealias ResponseOptions = KernelFluentModel.EmptyResponseOptions
    
    public static func createFields(
        from dto: KernelWebFront.Model.Flows.CreateFlowContainerRequest,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        let model = self.init()
        model.name = dto.name
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: KernelWebFront.Model.Flows.UpdateFlowContainerRequest,
        withOptions options: UpdateOptions? = nil
    ) throws {
        model.name = dto.name ?? model.name
        model.$entryNode.id = dto.entryNodeId ?? model.$entryNode.id
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> KernelWebFront.Model.Flows.FlowContainerResponse {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            name: name,
            entryNodeId: $entryNode.id
        )
    }
}
