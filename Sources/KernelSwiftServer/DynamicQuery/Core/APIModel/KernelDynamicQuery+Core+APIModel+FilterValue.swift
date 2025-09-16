//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/02/2025.
//

import KernelSwiftCommon
import Vapor
import SQLKit

extension KernelDynamicQuery.Core.APIModel {
    public enum FilterValue {
        case boolean(Bool)
        case date(Date)
        case dateArray([Date])
        case `enum`(String)
        case enumArray([String])
        case int8(Int8)
        case int8Array([Int8])
        case int16(Int16)
        case int16Array([Int16])
        case int32(Int32)
        case int32Array([Int32])
        case int64(Int64)
        case int64Array([Int64])
        case uint8(UInt8)
        case uint8Array([UInt8])
        case uint16(UInt16)
        case uint16Array([UInt16])
        case uint32(UInt32)
        case uint32Array([UInt32])
        case uint64(UInt64)
        case uint64Array([UInt64])
        case float(Float)
        case floatArray([Float])
        case double(Double)
        case doubleArray([Double])
        case string(String)
        case stringArray([String])
        case uuid(UUID)
        case uuidArray([UUID])
        
        public var filterValueIsArray: Bool {
            switch self {
            case    .dateArray, .enumArray, .int8Array, .int16Array, .int32Array, .int64Array,
                    .uint8Array, .uint16Array, .uint32Array, .uint64Array,
                    .floatArray, .doubleArray,
                    .stringArray, .uuidArray:
                return true
            default:
                return false
            }
        }
    }
}
