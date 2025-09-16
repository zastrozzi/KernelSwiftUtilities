//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 01/06/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCSV {
    public struct CSVColumnCodingKey: CodingKey, Hashable {
        public let stringValue: String
        public let intValue: Int?
        
        public func hash(into hasher: inout Hasher) {
            stringValue.hash(into: &hasher)
        }
        
        public init?(stringValue: String) {
            // CSV Column Coding Keys must be initialised with both name and position
            KernelCSV.logger.warning("CSV Column Coding Keys must be initialised with both name and position")
            return nil
        }
        
        // String Value defines column name, Int Value defines column position
        public init(name: String, position: Int) {
            self.stringValue = name
            self.intValue = position
        }
        
        public init(name: String) {
            self.stringValue = name
            self.intValue = nil
        }
        
        public init?(intValue: Int) {
            KernelCSV.logger.warning("CSV Column Coding Keys must be initialised with both name and position")
            return nil
        }
    }
}
