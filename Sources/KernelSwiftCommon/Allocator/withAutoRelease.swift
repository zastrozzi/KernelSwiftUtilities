//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 03/06/2025.
//

import Foundation

@inlinable
public func withAutoRelease<T>(_ execute: () throws -> T) rethrows -> T {
#if canImport(Darwin)
    return try autoreleasepool {
        try execute()
    }
#else
    return try execute()
#endif
}
