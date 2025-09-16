//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelGoogleCloud.Fluent.Model.Fields {
    public final class CustomerEncryption: KernelFluentCRUDFields, @unchecked Sendable {
        @OptionalField(key: "alg") public var encryptionAlgorithm: String?
        @OptionalField(key: "key_sha256") public var keySha256: String?
        
        public init() {}
        
        public typealias CreateDTO = KernelGoogleCloud.Core.Common.CustomerEncryption
        public typealias UpdateDTO = KernelGoogleCloud.Core.Common.CustomerEncryption
        public typealias ResponseDTO = KernelGoogleCloud.Core.Common.CustomerEncryption
        
        public static func createFields(
            from dto: CreateDTO
        ) throws -> Self {
            let model = self.init()
            model.encryptionAlgorithm = dto.encryptionAlgorithm
            model.keySha256 = dto.keySha256
            return model
        }
        
        public static func updateFields(
            for model: FieldsModel,
            from dto: UpdateDTO
        ) throws {
            try model.updateIfChanged(\.encryptionAlgorithm, from: dto.encryptionAlgorithm)
            try model.updateIfChanged(\.keySha256, from: dto.keySha256)
        }
        
        public func response() throws -> ResponseDTO {
            .init(
                encryptionAlgorithm: encryptionAlgorithm,
                keySha256: keySha256
            )
        }
    }
}
