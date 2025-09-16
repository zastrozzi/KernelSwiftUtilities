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
    public final class Logging: KernelFluentCRUDFields, @unchecked Sendable {
        @OptionalField(key: "log_bucket") public var logBucket: String?
        @OptionalField(key: "log_object_prefix") public var logObjectPrefix: String?
        
        public init() {}
        
        public typealias CreateDTO = KernelGoogleCloud.Core.Common.Logging
        public typealias UpdateDTO = KernelGoogleCloud.Core.Common.Logging
        public typealias ResponseDTO = KernelGoogleCloud.Core.Common.Logging
        
        public static func createFields(
            from dto: CreateDTO
        ) throws -> Self {
            let model = self.init()
            model.logBucket = dto.logBucket
            model.logObjectPrefix = dto.logObjectPrefix
            return model
        }
        
        public static func updateFields(
            for model: FieldsModel,
            from dto: UpdateDTO
        ) throws {
            try model.updateIfChanged(\.logBucket, from: dto.logBucket)
            try model.updateIfChanged(\.logObjectPrefix, from: dto.logObjectPrefix)
        }
        
        public func response() throws -> ResponseDTO {
            .init(
                logBucket: logBucket,
                logObjectPrefix: logObjectPrefix
            )
        }
    }
}
