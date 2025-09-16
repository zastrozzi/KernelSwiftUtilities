//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/05/2023.
//

import Foundation
import Vapor
import Collections
import OpenAPIKit30
import KernelSwiftCommon

extension KernelCSV {
    public struct CSVCodingConfiguration: Codable, Equatable, Content, OpenAPIEncodableSampleable, Sendable {
        public var cellDelimiter: UInt8
        public var cellQualifier: UInt8
        public var boolCodingStrategy: BoolCodingStrategy
        public var dateCodingStrategy: DateCodingStrategy
        public var nilCodingStrategy: NilCodingStrategy
        public var numericCodingStrategy: NumericCodingStrategy
        public var stringCodingStrategy: StringCodingStrategy
        public var uuidCodingStrategy: UUIDCodingStrategy
        public var columnConfigurations: [ColumnConfiguration]?
        
        @usableFromInline
        internal var columnConfigurationsByCodingKey: Dictionary<String, ColumnConfiguration> {
            guard let columnConfigurations else { return [:] }
            guard Array(columnConfigurations.map { $0.codingKeyName }.uniqued()).count == columnConfigurations.count else {
                preconditionFailure("Column Configurations key names must be unique")
            }
            return columnConfigurations.reduce(into: [String: ColumnConfiguration]()) { partialResult, column in
                partialResult[column.codingKeyName] = column
            }
        }
        
        @usableFromInline
        internal var columnConfigurationsByCSVColumnCodingKey: Dictionary<CSVColumnCodingKey, ColumnConfiguration> {
            guard let columnConfigurations else { return [:] }
            guard Array(columnConfigurations.map { $0.codingKeyName }.uniqued()).count == columnConfigurations.count else {
                preconditionFailure("Column Configurations key names must be unique")
            }
            return columnConfigurations.reduce(into: [CSVColumnCodingKey: ColumnConfiguration]()) { partialResult, column in
                partialResult[.init(name: column.columnName, position: column.columnPosition)] = column
            }
        }
        
        @usableFromInline
        internal var columnConfigurationCSVColumnKeys: [CSVColumnCodingKey] {
            guard let columnConfigurations else { return [] }
            let keys = Array(columnConfigurations.map { CSVColumnCodingKey(name: $0.columnName, position: $0.columnPosition) }.uniqued())
            guard keys.count == columnConfigurations.count else {
                preconditionFailure("Column Configurations key names must be unique")
            }
            return keys
        }
        
        public static let defaultConfiguration: CSVCodingConfiguration = .init(
            cellDelimiter: .ascii.comma,
            cellQualifier: .ascii.doubleQuote,
            boolCodingStrategy: .defaultStrategy,
            dateCodingStrategy: .defaultStrategy,
            nilCodingStrategy: .defaultStrategy,
            numericCodingStrategy: .defaultStrategy,
            stringCodingStrategy: .defaultStrategy,
            uuidCodingStrategy: .defaultStrategy,
            columnConfigurations: nil
        )
        
        public static let defaultTSVConfiguration: CSVCodingConfiguration = .init(
            cellDelimiter: .ascii.horizontalTab,
            cellQualifier: .ascii.doubleQuote,
            boolCodingStrategy: .defaultStrategy,
            dateCodingStrategy: .defaultStrategy,
            nilCodingStrategy: .defaultStrategy,
            numericCodingStrategy: .defaultStrategy,
            stringCodingStrategy: .defaultStrategy,
            uuidCodingStrategy: .defaultStrategy,
            columnConfigurations: nil
        )
        
        public static let defaultPSVConfiguration: CSVCodingConfiguration = .init(
            cellDelimiter: .ascii.verticalSlash,
            cellQualifier: .ascii.doubleQuote,
            boolCodingStrategy: .defaultStrategy,
            dateCodingStrategy: .defaultStrategy,
            nilCodingStrategy: .defaultStrategy,
            numericCodingStrategy: .defaultStrategy,
            stringCodingStrategy: .defaultStrategy,
            uuidCodingStrategy: .defaultStrategy,
            columnConfigurations: nil
        )
        
        public init(
            cellDelimiter: UInt8 = .ascii.comma,
            cellQualifier: UInt8 = .ascii.doubleQuote,
            boolCodingStrategy: BoolCodingStrategy = .defaultStrategy,
            dateCodingStrategy: DateCodingStrategy = .defaultStrategy,
            nilCodingStrategy: NilCodingStrategy = .defaultStrategy,
            numericCodingStrategy: NumericCodingStrategy = .defaultStrategy,
            stringCodingStrategy: StringCodingStrategy = .defaultStrategy,
            uuidCodingStrategy: UUIDCodingStrategy = .defaultStrategy,
            columnConfigurations: [ColumnConfiguration]? = nil
        ) {
            self.cellDelimiter = cellDelimiter
            self.cellQualifier = cellQualifier
            self.boolCodingStrategy = boolCodingStrategy
            self.dateCodingStrategy = dateCodingStrategy
            self.nilCodingStrategy = nilCodingStrategy
            self.numericCodingStrategy = numericCodingStrategy
            self.stringCodingStrategy = stringCodingStrategy
            self.uuidCodingStrategy = uuidCodingStrategy
            self.columnConfigurations = columnConfigurations
        }

        @inlinable
        public func strategyForKey(_ key: CodingKey) -> CodingStrategy? {
            guard let configurationForKey = columnConfigurationsByCodingKey[key.stringValue] else { return nil }
            switch configurationForKey.dataType {
            case .boolean: return .boolean(boolStrategyForKey(key))
            case .date: return .date(dateStrategyForKey(key))
            case .number: return .number(numericStrategyForKey(key))
            case .string: return .string(stringStrategyForKey(key))
            case .uuid: return .uuid(uuidStrategyForKey(key))
            case .stringEnum: return .stringEnum(UnknownStringEnum.self, stringStrategyForKey(key))
            case .intEnum: return .intEnum(UnknownIntEnum.self, numericStrategyForKey(key))
            }
        }
        
        @inlinable
        public func nilStrategyForKey(_ key: CodingKey) -> NilCodingStrategy {
            guard let configurationForKey = columnConfigurationsByCodingKey[key.stringValue] else { return nilCodingStrategy }
            //        guard configurationForKey.dataType == .boolean else { return boolCodingStrategy }
            guard let foundStrategy = configurationForKey.nilCodingStrategy else { return nilCodingStrategy }
            return foundStrategy
        }
        
        @inlinable
        public func boolStrategyForKey(_ key: CodingKey) -> BoolCodingStrategy {
            guard let configurationForKey = columnConfigurationsByCodingKey[key.stringValue] else { return boolCodingStrategy }
            guard configurationForKey.dataType == .boolean else { return boolCodingStrategy }
            guard let foundStrategy = configurationForKey.boolCodingStrategy else { return boolCodingStrategy }
            return foundStrategy
        }
        
        @inlinable
        public func dateStrategyForKey(_ key: CodingKey) -> DateCodingStrategy {
            guard let configurationForKey = columnConfigurationsByCodingKey[key.stringValue] else { return dateCodingStrategy }
            guard configurationForKey.dataType == .date else { return dateCodingStrategy }
            guard let foundStrategy = configurationForKey.dateCodingStrategy else { return dateCodingStrategy }
            return foundStrategy
        }
        
        @inlinable
        public func numericStrategyForKey(_ key: CodingKey) -> NumericCodingStrategy {
            guard let configurationForKey = columnConfigurationsByCodingKey[key.stringValue] else { return numericCodingStrategy }
            guard configurationForKey.dataType == .number else { return numericCodingStrategy }
            guard let foundStrategy = configurationForKey.numericCodingStrategy else { return numericCodingStrategy }
            return foundStrategy
        }
        
        @inlinable
        public func stringStrategyForKey(_ key: CodingKey) -> StringCodingStrategy {
            guard let configurationForKey = columnConfigurationsByCodingKey[key.stringValue] else { return stringCodingStrategy }
            guard configurationForKey.dataType == .string else { return stringCodingStrategy }
            guard let foundStrategy = configurationForKey.stringCodingStrategy else { return stringCodingStrategy }
            return foundStrategy
        }
        
        @inlinable
        public func uuidStrategyForKey(_ key: CodingKey) -> UUIDCodingStrategy {
            guard let configurationForKey = columnConfigurationsByCodingKey[key.stringValue] else { return uuidCodingStrategy }
            guard configurationForKey.dataType == .uuid else { return uuidCodingStrategy }
            guard let foundStrategy = configurationForKey.uuidCodingStrategy else { return uuidCodingStrategy }
            return foundStrategy
        }
    }
}

extension KernelCSV.CSVCodingConfiguration {
    public enum CodingStrategy: Sendable {
        case boolean(BoolCodingStrategy)
        case date(DateCodingStrategy)
        case number(NumericCodingStrategy)
        case string(StringCodingStrategy)
        case uuid(UUIDCodingStrategy)
        case nilStrategy(NilCodingStrategy)
        case stringEnum(any RawRepresentableAsString.Type, StringCodingStrategy)
        case intEnum(any RawRepresentableAsInt.Type, NumericCodingStrategy)
    }
}

extension KernelCSV.CSVCodingConfiguration {
    public struct ResolvedConfiguration<CodableCSVRow: KernelCSV.CSVCodable>: Sendable {
        @usableFromInline
        internal let csvColumnCodingKeyConfigurations: Dictionary<KernelCSV.CSVColumnCodingKey, ColumnConfiguration>
        @usableFromInline
        internal let codableCodingKeyStrategies: [KernelCSV.CSVCodingTransformableCodingKey:CodingStrategy]
        @usableFromInline
        internal let csvColumnCodingKeyStrategies: Dictionary<KernelCSV.CSVColumnCodingKey, CodingStrategy>
        @usableFromInline
        internal let codableKeysToCSVColumnKeys: Dictionary<KernelCSV.CSVCodingTransformableCodingKey, KernelCSV.CSVColumnCodingKey>
        @usableFromInline
        internal let codableKeys: [KernelCSV.CSVCodingTransformableCodingKey]
        @usableFromInline
        internal let nilCodingStrategy: NilCodingStrategy
        @usableFromInline
        internal lazy var decoder: CSVRowDecoder<CodableCSVRow> = { .init(for: self ) }()
        
        public init(coding: CodableCSVRow.Type, configuration: KernelCSV.CSVCodingConfiguration) {
            self.codableCodingKeyStrategies = coding.codingKeySet.reduce(into: [KernelCSV.CSVCodingTransformableCodingKey:CodingStrategy]()) { result, codingKey in
                switch codingKey.dataType {
                case .boolean: result[codingKey] = .boolean(configuration.boolStrategyForKey(codingKey))
                case .date: result[codingKey] = .date(configuration.dateStrategyForKey(codingKey))
                case .number: result[codingKey] = .number(configuration.numericStrategyForKey(codingKey))
                case .string: result[codingKey] = .string(configuration.stringStrategyForKey(codingKey))
                case .uuid: result[codingKey] = .uuid(configuration.uuidStrategyForKey(codingKey))
                case .stringEnum(let type): result[codingKey] = .stringEnum(type, configuration.stringStrategyForKey(codingKey))
                case .intEnum(let type): result[codingKey] = .intEnum(type, configuration.numericStrategyForKey(codingKey))
                }
            }
            
            self.csvColumnCodingKeyStrategies = configuration.columnConfigurationCSVColumnKeys.reduce(into: [KernelCSV.CSVColumnCodingKey:CodingStrategy]()) { result, codingKey in
                if let strategy = configuration.strategyForKey(codingKey) {
                    if
                        case let .intEnum(_,numericStrategy) = strategy,
                        let codableCodingKeyName = configuration.columnConfigurationsByCSVColumnCodingKey[codingKey]?.codingKeyName,
                        let codableCodingKey = coding.codingKeySet.first(where: { $0.stringValue == codableCodingKeyName }),
                        case let .intEnum(intEnumType) = codableCodingKey.dataType
                    { result[codingKey] = .intEnum(intEnumType, numericStrategy) }
                    else if
                        case let .stringEnum(_,stringStrategy) = strategy,
                        let codableCodingKeyName = configuration.columnConfigurationsByCSVColumnCodingKey[codingKey]?.codingKeyName,
                        let codableCodingKey = coding.codingKeySet.first(where: { $0.stringValue == codableCodingKeyName }),
                        case let .stringEnum(stringEnumType) = codableCodingKey.dataType
                    { result[codingKey] = .stringEnum(stringEnumType, stringStrategy) }
                    else
                    { result[codingKey] = strategy }
                }
                
            }
            
            self.csvColumnCodingKeyConfigurations = configuration.columnConfigurationsByCSVColumnCodingKey
            self.codableKeysToCSVColumnKeys = coding.codingKeySet.reduce(into: [KernelCSV.CSVCodingTransformableCodingKey:KernelCSV.CSVColumnCodingKey]()) { result, codingKey in
                if let entity = configuration.columnConfigurationsByCSVColumnCodingKey.first(where: { $0.value.codingKeyName == codingKey.stringValue }) {
                    result[codingKey] = entity.key
                }
            }
            self.codableKeys = coding.codingKeySet
            self.nilCodingStrategy = configuration.nilCodingStrategy
        }
        @inlinable
        public mutating func decodeRow(fromByteDict byteDictionary: OrderedByteDictionary) throws -> CodableCSVRow? {
            do {
                return try self.decoder.decode(fromByteDict: byteDictionary)
            } catch let error {
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode \(CodableCSVRow.self) from CSV row \(byteDictionary)", underlyingError: error))
            }
            
        }
        
        @inlinable
        public func codableKeyRowPosition(key: KernelCSV.CSVCodingTransformableCodingKey) -> Int? {
            return codableKeysToCSVColumnKeys[key]?.intValue ?? codableKeys.firstIndex(of: key)
        }
    }
    
    @usableFromInline
    enum UnknownStringEnum: String, Codable, Equatable, CaseIterable, RawRepresentableAsString {
        case noCase = "noCase"
    }
    
    @usableFromInline
    enum UnknownIntEnum: Int, Codable, Equatable, CaseIterable, RawRepresentableAsInt {
        case noCase = 0
    }
}

extension UInt8: RawOpenAPISchemaType {
    public static func rawOpenAPISchema() throws -> OpenAPIKit30.JSONSchema { .integer(format: .other("UInt8")) }
    
    
}

extension KernelCSV {
    public struct CSVCodingTransformableCodingKey: CodingKey, Hashable {
        public var stringValue: String
        public var intValue: Int?
        public var dataType: CSVCodingConfiguration.ComplexColumnDataType
        
        public init?(stringValue: String) {
            return nil
        }
        
        public init(from codingKey: CodingKey, dataType: CSVCodingConfiguration.ComplexColumnDataType) {
            self.intValue = codingKey.intValue
            self.stringValue = codingKey.stringValue
            self.dataType = dataType
        }
        
        public init?(intValue: Int) {
            return nil
        }
        
        
    }
}


public protocol _KernelCSVCodable: Codable, Sendable {
    associatedtype CodingKeys: CodingKey & Hashable & CaseIterable
    static var codingKeySet: Array<KernelCSV.CSVCodingTransformableCodingKey> { get }
}

extension KernelCSV {
    public typealias CSVCodable = _KernelCSVCodable
}
