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
    public final class Website: KernelFluentCRUDFields, @unchecked Sendable {
        @OptionalField(key: "main_page_suffix") public var mainPageSuffix: String?
        @OptionalField(key: "not_found_page") public var notFoundPage: String?
        
        public init() {}
        
        public typealias CreateDTO = KernelGoogleCloud.Core.Common.Website
        public typealias UpdateDTO = KernelGoogleCloud.Core.Common.Website
        public typealias ResponseDTO = KernelGoogleCloud.Core.Common.Website
        
        public static func createFields(
            from dto: CreateDTO
        ) throws -> Self {
            let model = self.init()
            model.mainPageSuffix = dto.mainPageSuffix
            model.notFoundPage = dto.notFoundPage
            return model
        }
        
        public static func updateFields(
            for model: FieldsModel,
            from dto: UpdateDTO
        ) throws {
            try model.updateIfChanged(\.mainPageSuffix, from: dto.mainPageSuffix)
            try model.updateIfChanged(\.notFoundPage, from: dto.notFoundPage)
        }
        
        public func response() throws -> ResponseDTO {
            .init(
                mainPageSuffix: mainPageSuffix,
                notFoundPage: notFoundPage
            )
        }
    }
}
