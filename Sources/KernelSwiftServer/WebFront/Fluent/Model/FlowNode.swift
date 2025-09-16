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
    public final class FlowNode: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.flowNode
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        @Field(key: "header") public var header: String
        @Field(key: "headline") public var headline: String
        @Field(key: "subheadline") public var subheadline: String
        @Field(key: "body") public var body: String
        @Parent(key: "container_id") public var container: FlowContainer
        @Children(for: \.$parentNode) public var continuations: [FlowContinuation]
        @Siblings(through: FlowContinuation.self, from: \.$parentNode, to: \.$childNode) public var childNodes: [FlowNode]
        
        public init() {}
    }
}

extension KernelWebFront.Fluent.Model.FlowNode: CRUDModel {
    public typealias CreateDTO = KernelWebFront.Model.Flows.CreateFlowNodeRequest
    public typealias UpdateDTO = KernelWebFront.Model.Flows.UpdateFlowNodeRequest
    public typealias ResponseDTO = KernelWebFront.Model.Flows.FlowNodeResponse
    
    public struct CreateOptions: Sendable {
        public var containerId: UUID
        
        public init(
            containerId: UUID
        ) {
            self.containerId = containerId
        }
    }
    
    public typealias UpdateOptions = KernelFluentModel.EmptyUpdateOptions
    
    public struct ResponseOptions: Sendable {
        public var withContinuations: Bool?
        
        public init(
            withContinuations: Bool? = nil
        ) {
            self.withContinuations = withContinuations
        }
    }
    
    public static func createFields(
        from dto: KernelWebFront.Model.Flows.CreateFlowNodeRequest,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        guard let options else { throw Abort(.badRequest, reason: "No container id provided") }
        let model = self.init()
        model.$container.id = options.containerId
        model.header = dto.header
        model.headline = dto.headline
        model.subheadline = dto.subheadline
        model.body = dto.body
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: KernelWebFront.Model.Flows.UpdateFlowNodeRequest,
        withOptions options: UpdateOptions? = nil
    ) throws {
        model.header = dto.header ?? model.header
        model.headline = dto.headline ?? model.headline
        model.subheadline = dto.subheadline ?? model.subheadline
        model.body = dto.body ?? model.body
    }
    
    public func response(
        onDB db: @escaping () -> (any Database),
        withOptions options: ResponseOptions? = nil
    ) async throws -> KernelWebFront.Model.Flows.FlowNodeResponse {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            header: header,
            headline: headline,
            subheadline: subheadline,
            body: body,
            containerId: $container.id,
            continuations: try await $continuations.get(on: db()).map { try $0.response() }
        )
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> KernelWebFront.Model.Flows.FlowNodeResponse {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            header: header,
            headline: headline,
            subheadline: subheadline,
            body: body,
            containerId: $container.id,
            continuations: try self._continuations.value?.map { try $0.response() } ?? []
        )
    }
}
