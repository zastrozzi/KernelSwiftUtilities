//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/10/2023.
//  WIP migrating universal v1/v4/v6 without underlying C shim
//

@available(iOS 9999, macOS 9999, *)
extension KernelUUID.Version {
    public enum V4 {}
}

@available(iOS 9999, macOS 9999, *)
extension KernelUUID.Version.V4 {
    public static func generateRandomBytes() -> KernelUUID.Bytes {
        preconditionFailure("Not implemented")
    }
}
