//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/04/2023.
//

import Foundation
import Collections

extension String {
//    public func addByteLimiter(maximumLimitInByte: Int = 1024) -> String {
//        guard
//            let utf8DecodedData = data(using: .utf8),
//            let utf8DecodedString = String(data: utf8DecodedData, encoding: .utf8)
//        else {
//            return self
//        }
//        
//        var byteLimitedString = utf8DecodedString
//        while byteLimitedString.count > maximumLimitInByte {
//            byteLimitedString.removeLast(1)
//        }
//        
//        return byteLimitedString
//    }
    
    public init(utf8EncodedBytes: [UInt8]) {
        self = String(decoding: utf8EncodedBytes, as: UTF8.self)
    }
    
    public init(utf8EncodedBytes: Deque<UInt8>) {
        self = String(decoding: utf8EncodedBytes, as: UTF8.self)
    }
}

extension CustomStringConvertible {
    public var utf8Bytes: [UInt8] { Array(self.description.utf8) }
}
