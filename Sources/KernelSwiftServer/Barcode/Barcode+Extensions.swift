//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/06/2024.
//

import KernelSwiftCommon
import FluentPostgresDriver

extension KernelSwiftCommon.Barcode.CodeType: PostgresArrayDecodable {}
extension KernelSwiftCommon.Barcode.CodeType: PostgresDecodable {}
extension KernelSwiftCommon.Barcode.CodeType: @retroactive KernelSwiftCommon.AbstractSampleable {}
extension KernelSwiftCommon.Barcode.CodeType: @retroactive KernelSwiftCommon.Sampleable {}

extension KernelSwiftCommon.Barcode.CodeType: FluentStringEnum {
    public static let fluentEnumName: String = "ksc_barcode_type"
}
