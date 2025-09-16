//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

import Foundation

extension KernelCSV.CSVParser {
    public final class SynchronousParser {
        public var configuration: KernelCSV.CSVCodingConfiguration
        
        public init(configuration: KernelCSV.CSVCodingConfiguration) {
            self.configuration = configuration
        }
        
        public func parse(_ data: [UInt8]) async throws -> ByteDictionary {
            var results: ByteDictionary = [:]
            let parser: KernelCSV.CSVParser = .init(
                parseHeaderCell: { headerData in
                    results[headerData] = []
                },
                parseBodyCell: { headerData, cellData in
                    results[headerData, default: []].append(cellData.isEmpty ? nil : cellData)
                    
                },
                configuration: configuration
            )
            try await parser.parse(data)
            return results
        }
        
        public func parse(_ data: String) async throws -> [String: [String?]] {
            var results: [String: [String?]] = [:]
            let parser: KernelCSV.CSVParser = .init(
                parseHeaderCell: { headerData in
                    results[.init(utf8EncodedBytes: headerData)] = []
                },
                parseBodyCell: { headerData, cellData in
                    let header: String = .init(utf8EncodedBytes: headerData)
                    let cell: String = .init(utf8EncodedBytes: cellData)
                    results[header, default: []].append(cellData.isEmpty ? nil : cell)
                },
                configuration: configuration
            )
            try await parser.parse(data.utf8Bytes)
            return results
        }
    }
}
