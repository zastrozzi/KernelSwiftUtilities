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
    public final class Billing: KernelFluentCRUDFields, @unchecked Sendable {
        @OptionalBoolean(key: "req_pays") public var requesterPays: Bool?
        
        public init() {}
        
        public typealias CreateDTO = KernelGoogleCloud.Core.Common.Billing
        public typealias UpdateDTO = KernelGoogleCloud.Core.Common.Billing
        public typealias ResponseDTO = KernelGoogleCloud.Core.Common.Billing
        
        public static func createFields(
            from dto: CreateDTO
        ) throws -> Self {
            let model = self.init()
            model.requesterPays = dto.requesterPays
            return model
        }
        
        public static func updateFields(
            for model: FieldsModel,
            from dto: UpdateDTO
        ) throws {
            try model.updateIfChanged(\.requesterPays, from: dto.requesterPays)
        }
        
        public func response() throws -> ResponseDTO {
            .init(
                requesterPays: requesterPays
            )
        }
    }
}
