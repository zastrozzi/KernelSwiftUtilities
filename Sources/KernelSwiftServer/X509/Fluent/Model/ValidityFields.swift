//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/12/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelX509.Fluent.Model {
    public final class Validity: Fields, @unchecked Sendable {
        @Field(key: "not_before") public var notBefore: Date
        @Field(key: "not_after") public var notAfter: Date
        
        public init() {}
        
        public static func createFields(from dto: KernelX509.Certificate.Validity) -> Self {
            let fields: Self = .init()
            fields.notBefore = dto.notBefore
            fields.notAfter = dto.notAfter
            return fields
        }
    }
}
