//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.NumericFilter {
    public struct CreateNumericFilterRequest: OpenAPIContent {
        public var column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var fieldIsArray: Bool
        public var filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod
        public var numericDataType: KernelDynamicQuery.Core.APIModel.NumericDataType
        public var int8FilterValue: Int8?
        public var int8ArrayFilterValue: [Int8]?
        public var int16FilterValue: Int16?
        public var int16ArrayFilterValue: [Int16]?
        public var int32FilterValue: Int32?
        public var int32ArrayFilterValue: [Int32]?
        public var int64FilterValue: Int64?
        public var int64ArrayFilterValue: [Int64]?
        public var uint8FilterValue: UInt8?
        public var uint8ArrayFilterValue: [UInt8]?
        public var uint16FilterValue: UInt16?
        public var uint16ArrayFilterValue: [UInt16]?
        public var uint32FilterValue: UInt32?
        public var uint32ArrayFilterValue: [UInt32]?
        public var uint64FilterValue: UInt64?
        public var uint64ArrayFilterValue: [UInt64]?
        public var doubleFilterValue: Double?
        public var doubleArrayFilterValue: [Double]?
        public var floatFilterValue: Float?
        public var floatArrayFilterValue: [Float]?
        
        public init(
            column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            fieldIsArray: Bool,
            filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod,
            numericDataType: KernelDynamicQuery.Core.APIModel.NumericDataType,
            int8FilterValue: Int8? = nil,
            int8ArrayFilterValue: [Int8]? = nil,
            int16FilterValue: Int16? = nil,
            int16ArrayFilterValue: [Int16]? = nil,
            int32FilterValue: Int32? = nil,
            int32ArrayFilterValue: [Int32]? = nil,
            int64FilterValue: Int64? = nil,
            int64ArrayFilterValue: [Int64]? = nil,
            uint8FilterValue: UInt8? = nil,
            uint8ArrayFilterValue: [UInt8]? = nil,
            uint16FilterValue: UInt16? = nil,
            uint16ArrayFilterValue: [UInt16]? = nil,
            uint32FilterValue: UInt32? = nil,
            uint32ArrayFilterValue: [UInt32]? = nil,
            uint64FilterValue: UInt64? = nil,
            uint64ArrayFilterValue: [UInt64]? = nil,
            doubleFilterValue: Double? = nil,
            doubleArrayFilterValue: [Double]? = nil,
            floatFilterValue: Float? = nil,
            floatArrayFilterValue: [Float]? = nil
        ) {
            self.column = column
            self.fieldIsArray = fieldIsArray
            self.filterMethod = filterMethod
            self.numericDataType = numericDataType
            self.int8FilterValue = int8FilterValue
            self.int8ArrayFilterValue = int8ArrayFilterValue
            self.int16FilterValue = int16FilterValue
            self.int16ArrayFilterValue = int16ArrayFilterValue
            self.int32FilterValue = int32FilterValue
            self.int32ArrayFilterValue = int32ArrayFilterValue
            self.int64FilterValue = int64FilterValue
            self.int64ArrayFilterValue = int64ArrayFilterValue
            self.uint8FilterValue = uint8FilterValue
            self.uint8ArrayFilterValue = uint8ArrayFilterValue
            self.uint16FilterValue = uint16FilterValue
            self.uint16ArrayFilterValue = uint16ArrayFilterValue
            self.uint32FilterValue = uint32FilterValue
            self.uint32ArrayFilterValue = uint32ArrayFilterValue
            self.uint64FilterValue = uint64FilterValue
            self.uint64ArrayFilterValue = uint64ArrayFilterValue
            self.doubleFilterValue = doubleFilterValue
            self.doubleArrayFilterValue = doubleArrayFilterValue
            self.floatFilterValue = floatFilterValue
            self.floatArrayFilterValue = floatArrayFilterValue
        }
        
        public static var sample: Self {
            .init(
                column: .sample,
                fieldIsArray: false,
                filterMethod: .equal,
                numericDataType: .int64,
                int64FilterValue: 1
            )
        }
    }
}
