//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/10/2023.
//  WIP migrating universal v1/v4/v6 without underlying C shim
//

//public struct KernelUUID: Codable, Equatable, Comparable, Hashable, CustomReflectable, CustomStringConvertible, Sendable {
@available(iOS 9999, macOS 9999, *)
public struct KernelUUID {
    public private(set) var storage: Bytes = KernelUUID.zeroBytes
    
    public init(version: Version) {
        switch version {
        case .v1: self.storage = Version.V1.generateRandomBytes()
        case .v4: self.storage = Version.V4.generateRandomBytes()
        case let .v6(rawTimestamp, sequence, node):
            self.storage = Version.V6.generateRandomBytes(rawTimestamp: rawTimestamp, sequence: sequence, node: node)
        }
    }
}
