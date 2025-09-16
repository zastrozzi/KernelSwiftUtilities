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
    public final class Versioning: KernelFluentCRUDFields, @unchecked Sendable {
        @OptionalBoolean(key: "enabled") public var enabled: Bool?
        
        public init() {}
        
        public typealias CreateDTO = KernelGoogleCloud.Core.Common.Versioning
        public typealias UpdateDTO = KernelGoogleCloud.Core.Common.Versioning
        public typealias ResponseDTO = KernelGoogleCloud.Core.Common.Versioning
        
        public static func createFields(
            from dto: CreateDTO
        ) throws -> Self {
            let model = self.init()
            model.enabled = dto.enabled
            return model
        }
        
        public static func updateFields(
            for model: FieldsModel,
            from dto: UpdateDTO
        ) throws {
            try model.updateIfChanged(\.enabled, from: dto.enabled)
        }
        
        public func response() throws -> ResponseDTO {
            .init(
                enabled: enabled
            )
        }
    }
}
