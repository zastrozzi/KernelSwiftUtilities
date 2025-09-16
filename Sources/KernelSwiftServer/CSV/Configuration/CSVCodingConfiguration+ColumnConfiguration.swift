//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

import Foundation
import Vapor

extension KernelCSV.CSVCodingConfiguration {
    public struct ColumnConfiguration: Codable, Equatable, Content, OpenAPIEncodableSampleable, SampleableOpenAPIExampleProvider, Sendable {
                
        public var columnName: String
        public let columnPosition: Int
        public var codingKeyName: String
        public var dataType: ColumnDataType
        public var isNullable: Bool
        public var boolCodingStrategy: BoolCodingStrategy?
        public var dateCodingStrategy: DateCodingStrategy?
        public var nilCodingStrategy: NilCodingStrategy?
        public var numericCodingStrategy: NumericCodingStrategy?
        public var stringCodingStrategy: StringCodingStrategy?
        public var uuidCodingStrategy: UUIDCodingStrategy?
        
        public init(
            columnName: String,
            columnPosition: Int,
            codingKeyName: String,
            dataType: ColumnDataType,
            isNullable: Bool,
            boolCodingStrategy: BoolCodingStrategy? = nil,
            dateCodingStrategy: DateCodingStrategy? = nil,
            nilCodingStrategy: NilCodingStrategy? = nil,
            numericCodingStrategy: NumericCodingStrategy? = nil,
            stringCodingStrategy: StringCodingStrategy? = nil,
            uuidCodingStrategy: UUIDCodingStrategy? = nil
           
        ) {
            self.columnName = columnName
            self.columnPosition = columnPosition
            self.codingKeyName = codingKeyName
            self.dataType = dataType
            self.isNullable = isNullable
            self.boolCodingStrategy = boolCodingStrategy
            self.dateCodingStrategy = dateCodingStrategy
            self.nilCodingStrategy = nilCodingStrategy
            self.numericCodingStrategy = numericCodingStrategy
            self.stringCodingStrategy = stringCodingStrategy
            self.uuidCodingStrategy = uuidCodingStrategy
        }
    }
}
