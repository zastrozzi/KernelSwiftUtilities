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
    public final class Encryption: KernelFluentCRUDFields, @unchecked Sendable {
        @OptionalField(key: "def_kms_key_name") public var defaultKmsKeyName: String?
        
        public init() {}
        
        public typealias CreateDTO = KernelGoogleCloud.Core.Common.Encryption
        public typealias UpdateDTO = KernelGoogleCloud.Core.Common.Encryption
        public typealias ResponseDTO = KernelGoogleCloud.Core.Common.Encryption
        
        public static func createFields(
            from dto: CreateDTO
        ) throws -> Self {
            let model = self.init()
            model.defaultKmsKeyName = dto.defaultKmsKeyName
            return model
        }
        
        public static func updateFields(
            for model: FieldsModel,
            from dto: UpdateDTO
        ) throws {
            try model.updateIfChanged(\.defaultKmsKeyName, from: dto.defaultKmsKeyName)
        }
        
        public func response() throws -> ResponseDTO {
            .init(
                defaultKmsKeyName: defaultKmsKeyName
            )
        }
    }
}
