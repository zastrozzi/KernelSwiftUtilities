//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon

public enum KernelWellKnown: FeatureLoggable {
//    public static let logger = makeLogger()
}

extension KernelWellKnown {
    public enum ByteOrder: UInt8 {
        case bigEndian = 0
        case littleEndian = 1
    }
}
