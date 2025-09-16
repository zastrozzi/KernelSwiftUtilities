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
    public final class Lifecycle: KernelFluentCRUDFields, @unchecked Sendable {
        @OptionalField(key: "rule") public var rule: [KernelGoogleCloud.Core.Common.Rule]?
        
        public init() {}
        
        public typealias CreateDTO = KernelGoogleCloud.Core.Common.Lifecycle
        public typealias UpdateDTO = KernelGoogleCloud.Core.Common.Lifecycle
        public typealias ResponseDTO = KernelGoogleCloud.Core.Common.Lifecycle
        
        public static func createFields(
            from dto: CreateDTO
        ) throws -> Self {
            let model = self.init()
            model.rule = dto.rule
            return model
        }
        
        public static func updateFields(
            for model: FieldsModel,
            from dto: UpdateDTO
        ) throws {
            try model.updateIfChanged(\.rule, from: dto.rule)
        }
        
        public func response() throws -> ResponseDTO {
            .init(
                rule: rule
            )
        }
    }
}
