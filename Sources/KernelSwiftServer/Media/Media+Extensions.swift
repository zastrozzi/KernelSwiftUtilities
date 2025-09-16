//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/06/2024.
//

import KernelSwiftCommon
import FluentPostgresDriver

//extension KernelSwiftCommon.Media.FileExtension: @retroactive PostgresArrayDecodable {}
//extension KernelSwiftCommon.Media.FileExtension: @retroactive PostgresDecodable {}
//extension KernelSwiftCommon.Media.FileExtension: @retroactive KernelSwiftCommon.AbstractSampleable {}
//extension KernelSwiftCommon.Media.FileExtension: @retroactive KernelSwiftCommon.Sampleable {}

extension KernelSwiftCommon.Media.FileExtension: PostgresArrayDecodable {}
extension KernelSwiftCommon.Media.FileExtension: PostgresDecodable {}
extension KernelSwiftCommon.Media.FileExtension: KernelSwiftCommon.AbstractSampleable {}
extension KernelSwiftCommon.Media.FileExtension: KernelSwiftCommon.Sampleable {}

extension KernelSwiftCommon.Media.FileExtension: FluentStringEnum {
    public static let fluentEnumName: String = "ksc_media_file_ext"
}
