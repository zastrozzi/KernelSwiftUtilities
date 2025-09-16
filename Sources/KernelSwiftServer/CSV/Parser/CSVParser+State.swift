//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

import Foundation

extension KernelCSV.CSVParser {
    internal struct State {
        var columnHeaders: [[UInt8]]
        var position: Position
        var inQualifier: Bool
        var storedCell: [UInt8]
        var headerIndex: Int
        var bytesLeft: Int?
        
        init() {
            self.columnHeaders = []
            self.position = .header
            self.inQualifier = false
            self.storedCell = []
            self.headerIndex = 0
            self.bytesLeft = nil
        }
    }
}
