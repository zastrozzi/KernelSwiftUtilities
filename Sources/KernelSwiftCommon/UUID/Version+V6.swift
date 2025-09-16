//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/10/2023.
//  WIP migrating universal v1/v4/v6 without underlying C shim
//

@available(iOS 9999, macOS 9999, *)
extension KernelUUID.Version {
    public enum V6 {}
}

@available(iOS 9999, macOS 9999, *)
extension KernelUUID.Version.V6 {
    public typealias RawTimestamp = UInt64
    public typealias Sequence = UInt16
    public typealias Node = UInt64
    
    public static func generateRandomBytes(
        rawTimestamp: RawTimestamp? = nil,
        sequence: Sequence? = nil,
        node: Node? = nil
    ) -> KernelUUID.Bytes {
        preconditionFailure("Not implemented")
    }
}
