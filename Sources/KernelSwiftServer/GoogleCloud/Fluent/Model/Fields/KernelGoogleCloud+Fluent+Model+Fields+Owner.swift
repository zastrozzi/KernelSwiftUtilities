//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelGoogleCloud.Fluent.Model.Fields {
    public final class Owner: KernelFluentCRUDFields, @unchecked Sendable {
        @OptionalField(key: "entity") public var entity: String?
        @OptionalField(key: "entity_id") public var entityId: String?
        
        public init() {}
        
        public typealias CreateDTO = KernelGoogleCloud.Core.Common.Owner
        public typealias UpdateDTO = KernelGoogleCloud.Core.Common.Owner
        public typealias ResponseDTO = KernelGoogleCloud.Core.Common.Owner
        
        public static func createFields(
            from dto: CreateDTO
        ) throws -> Self {
            let model = self.init()
            model.entity = dto.entity
            model.entityId = dto.entityId
            return model
        }
        
        public static func updateFields(
            for model: FieldsModel,
            from dto: UpdateDTO
        ) throws {
            try model.updateIfChanged(\.entity, from: dto.entity)
            try model.updateIfChanged(\.entityId, from: dto.entityId)
        }
        
        public func response() throws -> ResponseDTO {
            .init(
                entity: entity,
                entityId: entityId
            )
        }
    }
}
