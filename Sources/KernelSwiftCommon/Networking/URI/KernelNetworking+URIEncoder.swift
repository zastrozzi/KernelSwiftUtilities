//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelNetworking {
    public struct URIEncoder: Sendable {
        private let serializer: URISerializer
        
        public init(
            serializer: URISerializer
        ) {
            self.serializer = serializer
        }
        
        public init(
            configuration: Configuration.URICoderConfiguration
        ) {
            self.init(serializer: .init(configuration: configuration))
        }
    }
}

extension KernelNetworking.URIEncoder {
    public func encode(_ value: some Encodable, forKey key: String) throws -> String {
        let encoder = KernelNetworking.URIValueToNodeEncoder()
        let node = try encoder.encodeValue(value)
        var serializer = serializer
        let encodedString = try serializer.serializeNode(node, forKey: key)
        return encodedString
    }
    
    public func encodeIfPresent(_ value: (some Encodable)?, forKey key: String) throws -> String {
        guard let value else { return "" }
        let encoder = KernelNetworking.URIValueToNodeEncoder()
        let node = try encoder.encodeValue(value)
        var serializer = serializer
        let encodedString = try serializer.serializeNode(node, forKey: key)
        return encodedString
    }
}

extension KernelNetworking {
    struct URICoderCodingKey {
        var stringValue: String
        var intValue: Int?
        
        init(_ key: some CodingKey) {
            self.stringValue = key.stringValue
            self.intValue = key.intValue
        }
    }
}

extension KernelNetworking.URICoderCodingKey: CodingKey {
    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}
