//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/05/2023.
//

import Foundation



extension KernelCSV.CSVDecoder {
    public typealias DecodedObjectHandler = @Sendable (Decodable) async throws -> ()
    final class AsynchronousDecoder: Decoder, @unchecked Sendable {
        typealias StringKeyedHandler = @Sendable ([String: [UInt8]]) async throws -> ()
        
        
        enum DataStorage: Sendable {
            case none
            case bytes([UInt8])
            case stringKeyedBytes([String: [UInt8]])
            case codingKeyKeyedBytes([KeyCodingFormat.CasedCodingKey: [UInt8]])
        }
        
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey : Any]
        var decoding: (Decodable & Sendable).Type
        var handler: Handler
        var configuration: KernelCSV.CSVCodingConfiguration
        var decodedObjectHandler: DecodedObjectHandler
        var data: DataStorage
        
        init(
            decoding: (Decodable & Sendable).Type,
            path: [CodingKey],
            info: [CodingUserInfoKey : Any] = [:],
            data: DataStorage = .none,
            configuration: KernelCSV.CSVCodingConfiguration,
            decodedObjectHandler: @escaping DecodedObjectHandler
        ) {
            self.codingPath = path
            self.userInfo = info
            self.decoding = decoding
            
            self.configuration = configuration
            self.decodedObjectHandler = decodedObjectHandler
            self.data = data
            self.handler = .init(configuration: configuration, rowHandler: { _ in })
            
            let rowHandler: StringKeyedHandler = { [self, decoding] row in
                self.data = .stringKeyedBytes(row)
                let decoded = try decoding.init(from: self)
                self.data = .none
                
                try await decodedObjectHandler(decoded)
                
            }
            
            self.handler = .init(configuration: configuration, rowHandler: rowHandler)
            
            if self.userInfo[CodingUserInfoKey(rawValue: "decoder")!] == nil {
                self.userInfo[CodingUserInfoKey(rawValue: "decoder")!] = "CSVAsynchronousDecoder"
            }
        }
        
        func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
            if case .stringKeyedBytes = self.data {
                let container = try AsynchronousStringKeyedDecoder<Key>(path: self.codingPath, decoder: self)
                return KeyedDecodingContainer(container)
            }
            if case .codingKeyKeyedBytes = self.data {
                let container = try AsynchronousStringKeyedDecoder<Key>(path: self.codingPath, decoder: self)
                return KeyedDecodingContainer(container)
            }
            throw DecodingError.dataCorrupted(.init(codingPath: self.codingPath, debugDescription: "Attempted to created keyed container with unkeyed data"))
        }
        
        func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            fatalError("Not implemented")
        }
        
        func singleValueContainer() throws -> SingleValueDecodingContainer {
            guard case .bytes = self.data else {
                throw DecodingError.dataCorrupted(.init(
                    codingPath: self.codingPath,
                    debugDescription: "Attempted to create single value container with keyed data"
                ))
            }
            
            return try AsynchronousSingleValueDecoder(path: self.codingPath, decoder: self)
        }
        
        func decode(_ data: [UInt8], length: Int? = nil) async throws {
            try await self.handler.parse(data, length: length)
        }
    }
}

extension KernelCSV.CSVDecoder.AsynchronousDecoder {
    internal class Handler {
        
        
        lazy var parser: KernelCSV.CSVParser = {
            .init(parseHeaderCell: headerCellHandler, parseBodyCell: bodyCellHandler, configuration: configuration)
        }()
        var currentRow: [String: [UInt8]]
        var rowHandler: StringKeyedHandler
        
        private var columnCount: Int
        private var currentColumn: Int
        
        var configuration: KernelCSV.CSVCodingConfiguration
        
        var headerCellHandler: KernelCSV.CSVParser.HeaderCellHandler { { _ in
            self.columnCount += 1
        }}
        
        var bodyCellHandler: KernelCSV.CSVParser.BodyCellHandler { { headerData, cellData in
            self.currentRow[String(decoding: headerData, as: UTF8.self)] = cellData
            if self.currentColumn == (self.columnCount - 1) {
                self.currentColumn = 0

                try await self.rowHandler(self.currentRow)
            } else {

                self.currentColumn += 1
            }
        }}
        
        init(configuration: KernelCSV.CSVCodingConfiguration, rowHandler: @escaping StringKeyedHandler) {
            self.currentRow = [:]
            self.rowHandler = rowHandler
            self.columnCount = 0
            self.currentColumn = 0
            self.configuration = configuration
        }
        
        public func parse(_ bytes: [UInt8], length: Int? = nil) async throws {
            try await self.parser.parse(bytes, length: length)
        }
    }
}

