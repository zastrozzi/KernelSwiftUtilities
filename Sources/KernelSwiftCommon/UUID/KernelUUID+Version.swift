//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/10/2023.
//  WIP migrating universal v1/v4/v6 without underlying C shim
//

@available(iOS 9999, macOS 9999, *)
extension KernelUUID {
    public enum Version {
        case v1
        case v4
        case v6(rawTimestamp: V6.RawTimestamp?, sequence: V6.Sequence?, node: V6.Node?)
    }
}
