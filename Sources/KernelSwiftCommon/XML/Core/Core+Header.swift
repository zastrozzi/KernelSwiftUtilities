//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML {
    public struct Header {
        public let version: Double?
        public let encoding: String?
        public let standalone: String?
        
        public init(version: Double? = nil, encoding: String? = nil, standalone: String? = nil) {
            self.version = version
            self.encoding = encoding
            self.standalone = standalone
        }
        
        public func isEmpty() -> Bool {
            return version == nil && encoding == nil && standalone == nil
        }
        
        public func toXML() -> String? {
            guard !isEmpty() else { return nil }
            
            var string = "<?xml"
            if let version { string += " version=\"\(version)\"" }
            if let encoding { string += " encoding=\"\(encoding)\"" }
            if let standalone { string += " standalone=\"\(standalone)\"" }
            string += "?>\n"
            return string
        }
    }
}
