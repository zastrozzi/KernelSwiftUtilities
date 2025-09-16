//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML {
    public struct XMLKey: CodingKey {
        public let stringValue: String
        public let intValue: Int?
        
        public init?(stringValue: String) {
            self.init(key: stringValue)
        }
        
        public init?(intValue: Int) {
            self.init(index: intValue)
        }
        
        public init(stringValue: String, intValue: Int?) {
            self.stringValue = stringValue
            self.intValue = intValue
        }
        
        public init(key: String) {
            self.init(stringValue: key, intValue: nil)
        }
        
        public init(index: Int) {
            self.init(stringValue: "\(index)", intValue: index)
        }
        
        public static let `super` = KernelXML.XMLKey(stringValue: "super")!
    }
}
