//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/04/2023.
//

import Foundation

public extension DataProtocol {
    func copyBytes() -> [UInt8] {
        if let array = self.withContiguousStorageIfAvailable({ buffer in
            return [UInt8](buffer)
        }) {
            return array
        } else {
            let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: self.count)
            self.copyBytes(to: buffer)
            defer { buffer.deallocate() }
            return [UInt8](buffer)
        }
    }
}

public extension DataProtocol {
    func base64URLDecodedBytes() -> [UInt8] {
        return Data(base64Encoded: Data(self.copyBytes()).base64URLUnescaped())?.copyBytes() ?? []
    }

    func base64URLEncodedBytes() -> [UInt8] {
        return Data(self.copyBytes()).base64EncodedData().base64URLEscaped().copyBytes()
    }
}

