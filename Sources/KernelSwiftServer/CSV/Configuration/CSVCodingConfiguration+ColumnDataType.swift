//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension KernelCSV.CSVCodingConfiguration {
    public enum ColumnDataType: String, Codable, Equatable, CaseIterable, OpenAPIStringEnumSampleable, Sendable {
        case string = "string"
        case number = "number"
        case boolean = "boolean"
        case date = "date"
        case uuid = "uuid"
        case stringEnum = "stringEnum"
        case intEnum = "intEnum"
    }
    
    public enum ComplexColumnDataType: Equatable, Hashable, Sendable {
        public static func == (lhs: KernelCSV.CSVCodingConfiguration.ComplexColumnDataType, rhs: KernelCSV.CSVCodingConfiguration.ComplexColumnDataType) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
        
        public func hash(into hasher: inout Hasher) {
            String(describing: self).hash(into: &hasher)
        }
        
        case string
        case number
        case boolean
        case date
        case uuid
        case stringEnum(any RawRepresentableAsString.Type)
        case intEnum(any RawRepresentableAsInt.Type)
    }
}
