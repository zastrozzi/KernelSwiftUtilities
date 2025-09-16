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
    public final class RetentionPolicy: KernelFluentCRUDFields, @unchecked Sendable {
        @OptionalField(key: "eff_time") public var effectiveTime: Date?
        @OptionalField(key: "is_locked") public var isLocked: Bool?
        @OptionalField(key: "period") public var retentionPeriod: Int?
        
        public init() {}
        
        public typealias CreateDTO = KernelGoogleCloud.Core.Common.RetentionPolicy
        public typealias UpdateDTO = KernelGoogleCloud.Core.Common.RetentionPolicy
        public typealias ResponseDTO = KernelGoogleCloud.Core.Common.RetentionPolicy
        
        public static func createFields(
            from dto: CreateDTO
        ) throws -> Self {
            let model = self.init()
            model.effectiveTime = dto.effectiveTime
            model.isLocked = dto.isLocked
            model.retentionPeriod = dto.retentionPeriod
            return model
        }
        
        public static func updateFields(
            for model: FieldsModel,
            from dto: UpdateDTO
        ) throws {
            try model.updateIfChanged(\.effectiveTime, from: dto.effectiveTime)
            try model.updateIfChanged(\.isLocked, from: dto.isLocked)
            try model.updateIfChanged(\.retentionPeriod, from: dto.retentionPeriod)
        }
        
        public func response() throws -> ResponseDTO {
            .init(
                effectiveTime: effectiveTime,
                isLocked: isLocked,
                retentionPeriod: retentionPeriod
            )
        }
    }
}
