//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 20/09/2024.
//

extension KernelSwiftCommon.Coding {
    public struct DynamicCodingKeys: CodingKey {
        public var stringValue: String
        public var intValue: Int?
        
        public init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        public init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
        
        public init(_ stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
    }
}
