//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/05/2023.
//

import Foundation

extension KernelCSV {
    public class CSVParser {
        public typealias ByteDictionary = [[UInt8]: [[UInt8]?]]
        public typealias HeaderCellHandler = (_ headerData: [UInt8]) throws -> ()
        public typealias BodyCellHandler = (_ headerData: [UInt8], _ cellData: [UInt8]) async throws -> ()
        
        public var parseHeaderCell: HeaderCellHandler?
        public var parseBodyCell: BodyCellHandler?
        public var configuration: CSVCodingConfiguration
        
        private var state: State
        
        internal var currentHeaderCell: [UInt8] {
            return self.state.columnHeaders[self.state.headerIndex % self.state.columnHeaders.count]
        }
        
        public init(
            parseHeaderCell: HeaderCellHandler? = nil,
            parseBodyCell: BodyCellHandler? = nil,
            configuration: CSVCodingConfiguration
        ) {
            self.parseHeaderCell = parseHeaderCell
            self.parseBodyCell = parseBodyCell
            self.configuration = configuration
            self.state = .init()
        }
        
        public func parse(_ data: [UInt8], length: Int? = nil) async throws {
            var currentCell: [UInt8] = self.state.storedCell
            var index = data.startIndex
            var updateState = false
            var parseError: KernelCSV.CSVCodingError = .init()
            var slice: (start: Int, end: Int) = (index, index)

            while index < data.endIndex {
                let byte = data[index]
                switch byte {
                case configuration.cellQualifier:
                    currentCell.append(contentsOf: data[slice.start..<slice.end])
                    slice = (index + 1, index + 1)
                    if self.state.inQualifier && (index + 1) < data.endIndex && data[index + 1] == configuration.cellQualifier { index += 1 }
                    else { self.state.inQualifier.toggle() }
                    
                case .ascii.carriageReturn:
                    if self.state.inQualifier { slice.end += 1 }
                    else {
                        if index + 1 < data.endIndex, data[index + 1] == .ascii.lineFeed { index += 1 }
                        fallthrough
                    }
                case .ascii.lineFeed:
                    if self.state.inQualifier { slice.end += 1 }
                    else {
                        if self.state.position == .header { updateState = true }
                        fallthrough
                    }
                case configuration.cellDelimiter:
                    let headCell = self.state.columnHeaders.isEmpty ? [] : self.state.columnHeaders[self.state.headerIndex % self.state.columnHeaders.count]
                    if self.state.inQualifier { slice.end += 1 }
                    else {
                        currentCell.append(contentsOf: data[slice.start..<slice.end])
                        switch self.state.position {
                        case .header:
                            self.state.columnHeaders.append(currentCell)
                            do { try self.parseHeaderCell?(currentCell) }
                            catch let error { parseError.errorList.append(error) }
                        case .body:
                            
                            do { try await self.parseBodyCell?(headCell, currentCell); self.state.headerIndex += 1 }
                            catch let error { parseError.errorList.append(error) }
                            
                        }
                        
                        currentCell = []
                        slice = (index + 1, index + 1)
                        if updateState { self.state.position = .body }
                    }
                default: slice.end += 1
                }
                
                index += 1
            }
            
            currentCell.append(contentsOf: data[slice.start..<slice.end])
            if let length {
                self.state.bytesLeft = (self.state.bytesLeft ?? length) - ((self.state.storedCell.count + data.count) - currentCell.count)
                if (self.state.bytesLeft ?? 0) > currentCell.count {
                    self.state.storedCell = currentCell
                    guard parseError.errorList.isEmpty else { parseError.errorList = []; return }
                    return
                }
            }
            let headCell = self.state.columnHeaders.isEmpty ? [] : self.state.columnHeaders[self.state.headerIndex % self.state.columnHeaders.count]
            switch self.state.position {
            case .header:
                self.state.columnHeaders.append(currentCell)
                do { try self.parseHeaderCell?(currentCell) }
                catch let error { parseError.errorList.append(error) }
            case .body:
                
                do {  try await self.parseBodyCell?(headCell, currentCell) }
                catch let error { parseError.errorList.append(error) }
            }
            
            guard parseError.errorList.isEmpty else { parseError.errorList = []; return }
            return
        }
    }
    
    
    
}
