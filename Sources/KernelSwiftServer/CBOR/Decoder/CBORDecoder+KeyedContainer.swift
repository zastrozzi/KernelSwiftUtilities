//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/09/2023.
//

import Foundation

extension KernelCBOR.CBORDecoder {
    public class KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        public var codingPath: [CodingKey] = []
        public var allKeys: [Key] = []
        public var dictionary: [String: String] = [:]
        public var cborType: KernelCBOR.CBORType
        public var index: Int = 0
        public var decodingType: KernelCBOR.CBORDecodable.Type
        
        public init<D: KernelCBOR.CBORDecodable>(codingPath: [CodingKey], cborType: KernelCBOR.CBORType, decoding decodingType: D.Type) {
            self.codingPath = codingPath
            self.cborType = cborType
            self.decodingType = decodingType
        }
        
        public func contains(_ key: Key) -> Bool {
            return allKeys.contains { $0.stringValue == key.stringValue }
        }
        
        public func decodeNil(forKey key: Key) throws -> Bool {
            fatalError()
        }
        
        public func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
            
            let x: KernelCBOR.CBORDecodable.Type = type as! any KernelCBOR.CBORDecodable.Type
            guard case let .array(arr) = cborType else { throw x.decodingError(.array, cborType) }
            
            let cborSubtype = arr[index]
            if (index + 1) < arr.endIndex {
                self.index += 1
            }
            return try x.init(from: cborSubtype) as! T
            
        }
        
        
        public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            preconditionFailure("Not implemented")
        }
        
        public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            preconditionFailure("Not implemented")
        }
        
        public func superDecoder() throws -> Decoder {
            preconditionFailure("Not implemented")
        }
        
        public func superDecoder(forKey key: Key) throws -> Decoder {
            preconditionFailure("Not implemented")
        }
    }
}
