//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Core.APIModel {
    public enum NumericDataType: String, FluentStringEnum {
        public static let fluentEnumName: String = "kdq-numeric_data_type"
        
        case int8
        case int16
        case int32
        case int64
        case uint8
        case uint16
        case uint32
        case uint64
        case float
        case double
    }
}
