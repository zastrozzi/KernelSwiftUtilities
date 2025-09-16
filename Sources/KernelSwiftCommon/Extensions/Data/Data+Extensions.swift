//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/04/2023.
//

import Foundation

// MARK: - JSON
public extension Data {
    static func anyJSON() -> Data {
        return Data("{}".utf8)
    }
}

// MARK: - UTF8
public extension Data {
    var utf8Description: String {
        count > 0 ? String(data: self, encoding: .utf8) ?? "<unavailable>" : "<empty>"
    }
}

// MARK: - MemoryBoundBytes
extension Data {
    public func memoryBoundBytes() -> [UInt8] {
        return self.withUnsafeBytes { bytes in
            return [UInt8](bytes.bindMemory(to: UInt8.self))
        }
    }
}

// MARK: - HEX
extension Data {
    public init?(hex: String) {
        if let hexBytes: [UInt8] = .init(fromHexString: hex) {
            self.init(hexBytes)
        }
        else { return nil }
    }
}
