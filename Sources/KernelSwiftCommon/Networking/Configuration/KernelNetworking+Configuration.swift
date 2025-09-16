//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelNetworking {
    public struct Configuration: Sendable {
        public var dateTranscoder: any DateTranscoder
        public var jsonEncodingOptions: JSONEncodingOptions
        public var multipartBoundaryGenerator: any MultipartBoundaryGenerator
        public var xmlCoder: (any CustomCoder)?
        
        public init(
            dateTranscoder: any DateTranscoder = .iso8601,
            jsonEncodingOptions: JSONEncodingOptions = [.sortedKeys, .prettyPrinted],
            multipartBoundaryGenerator: any MultipartBoundaryGenerator = .random,
            xmlCoder: (any CustomCoder)? = nil
        ) {
            self.dateTranscoder = dateTranscoder
            self.jsonEncodingOptions = jsonEncodingOptions
            self.multipartBoundaryGenerator = multipartBoundaryGenerator
            self.xmlCoder = xmlCoder
        }
    }
}
