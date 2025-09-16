//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/10/2023.
//  WIP migrating universal v1/v4/v6 without underlying C shim
//

@available(iOS 9999, macOS 9999, *)
extension KernelUUID {
    public typealias Bytes = (
        UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
        UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8
    )
    
    public static let zeroBytes: Bytes = (
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero
    )
}
