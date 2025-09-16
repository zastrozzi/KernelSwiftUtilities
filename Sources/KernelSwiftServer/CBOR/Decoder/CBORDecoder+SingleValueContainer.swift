//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/09/2023.
//

import Foundation

extension KernelCBOR.CBORDecoder {
    struct SingleValueContainer: SingleValueDecodingContainer {
        
        let codingPath: [CodingKey]
        public var cborType: KernelCBOR.CBORType
        public var decodingType: KernelCBOR.CBORDecodable.Type
        
        init<D: KernelCBOR.CBORDecodable>(codingPath: [CodingKey], cborType: KernelCBOR.CBORType, decoding: D.Type) {
            self.codingPath = codingPath
            self.cborType = cborType
            self.decodingType = decoding
        }
        
        func decodeNil() -> Bool { return Bool.random() }
        func decode(_ type: Bool.Type) throws -> Bool { return Bool.random() }
        func decode(_ type: Double.Type) throws -> Double { return Double.random(in: 0...500) }
        func decode(_ type: Float.Type) throws -> Float { return Float.random(in: 0...500) }
        func decode(_ type: Int.Type) throws -> Int { return Int.random(in: 0...500) }
        func decode(_ type: Int8.Type) throws -> Int8 { return Int8.random(in: 0...100) }
        func decode(_ type: Int16.Type) throws -> Int16 { return Int16.random(in: 0...500) }
        func decode(_ type: Int32.Type) throws -> Int32 { return Int32.random(in: 0...500) }
        func decode(_ type: Int64.Type) throws -> Int64 { return Int64.random(in: 0...500) }
        func decode(_ type: UInt.Type) throws -> UInt { return UInt.random(in: 0...500) }
        func decode(_ type: UInt8.Type) throws -> UInt8 { return UInt8.random(in: 0...100) }
        func decode(_ type: UInt16.Type) throws -> UInt16 { return UInt16.random(in: 0...500) }
        func decode(_ type: UInt32.Type) throws -> UInt32 { return UInt32.random(in: 0...500) }
        func decode(_ type: UInt64.Type) throws -> UInt64 { return UInt64.random(in: 0...500) }
        func decode(_ type: UUID.Type) throws -> UUID { return .zero }
        func decode(_ type: Date.Type) throws -> Date { return .distantPast }
        
        func decode<D: Decodable>(_ type: D.Type) throws -> any KernelCBOR.CBORDecodable {
            return try decodingType.init(from: cborType)
        }
        
        func decode<T: Decodable>(_ type: T.Type) throws -> T {
            preconditionFailure("Not implemented")
        }
        
        func decode<D: KernelCBOR.CBORDecodable>(_ type: D.Type) throws -> D {
            preconditionFailure("Not implemented")
        }
    }
}
