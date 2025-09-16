//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/02/2025.
//

import Foundation

extension UUID {
    public typealias Bytes = (
        UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
        UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8
    )
    
    public var uuidByteArray: [UInt8] {
        let uuidByteTuple = self.uuid
        return [
            uuidByteTuple.0,    uuidByteTuple.1,    uuidByteTuple.2,    uuidByteTuple.3,
            uuidByteTuple.4,    uuidByteTuple.5,    uuidByteTuple.6,    uuidByteTuple.7,
            uuidByteTuple.8,    uuidByteTuple.9,    uuidByteTuple.10,   uuidByteTuple.11,
            uuidByteTuple.12,   uuidByteTuple.13,   uuidByteTuple.14,   uuidByteTuple.15
        ]
    }
    
    public init(uuidByteArray: [UInt8]) {
        guard uuidByteArray.count == 16 else { preconditionFailure("Could not UUID from byteArray with length not equal to 16") }
        self.init(uuid: (
            uuidByteArray[0],   uuidByteArray[1],   uuidByteArray[2],   uuidByteArray[3],
            uuidByteArray[4],   uuidByteArray[5],   uuidByteArray[6],   uuidByteArray[7],
            uuidByteArray[8],   uuidByteArray[9],   uuidByteArray[10],  uuidByteArray[11],
            uuidByteArray[12],  uuidByteArray[13],  uuidByteArray[14],  uuidByteArray[15]
        ))
    }
    
    public static let zeroBytes: Bytes = (
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero
    )
    
    public static func setBytes(_ byteArray: [UInt8], to bytes: inout Bytes) {
        var safeByteArray: [UInt8] = Array(repeating: .zero, count: 16)
        for (index, byte) in byteArray.enumerated() {
            safeByteArray[index] = byte
        }
        
        bytes.0 = safeByteArray[0]
        bytes.1 = safeByteArray[1]
        bytes.2 = safeByteArray[2]
        bytes.3 = safeByteArray[3]
        bytes.4 = safeByteArray[4]
        bytes.5 = safeByteArray[5]
        bytes.6 = safeByteArray[6]
        bytes.7 = safeByteArray[7]
        bytes.8 = safeByteArray[8]
        bytes.9 = safeByteArray[9]
        bytes.10 = safeByteArray[10]
        bytes.11 = safeByteArray[11]
        bytes.12 = safeByteArray[12]
        bytes.13 = safeByteArray[13]
        bytes.14 = safeByteArray[14]
        bytes.15 = safeByteArray[15]
    }
}
