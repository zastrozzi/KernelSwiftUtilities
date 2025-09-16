//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon

extension KernelWellKnown {
    public enum BinaryTypeCode: UInt32 {
        case point = 1
        case lineString = 2
        case polygon = 3
        case multiPoint = 4
        case multiLineString = 5
        case multiPolygon = 6
        case geometryCollection = 7
    }
}
