//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/09/2023.
//

import Foundation
import KernelSwiftCommon
import FluentPostgresDriver

//extension KernelSwiftCommon.ObjectID: @retroactive PostgresArrayDecodable {}
//extension KernelSwiftCommon.ObjectID: @retroactive PostgresDecodable {}
extension KernelSwiftCommon.ObjectID: PostgresArrayDecodable {}
extension KernelSwiftCommon.ObjectID: PostgresDecodable {}
extension KernelSwiftCommon.ObjectID: FluentStringEnum {
    public static let fluentEnumName: String = "ksc_oid"
}

//extension KernelSwiftCommon.ObjectID: @retroactive _KernelSampleable {}
//extension KernelSwiftCommon.ObjectID: @retroactive _KernelAbstractSampleable {}
extension KernelSwiftCommon.ObjectID: _KernelSampleable {}
extension KernelSwiftCommon.ObjectID: _KernelAbstractSampleable {}
extension KernelSwiftCommon.ObjectID: OpenAPIStringEnumSampleable {}
