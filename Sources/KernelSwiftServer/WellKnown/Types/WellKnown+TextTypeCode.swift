//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon

extension KernelWellKnown {
    public enum TextTypeCode: String {
        case point = "Point"
        case lineString = "LineString"
        case polygon = "Polygon"
        case multiPoint = "MultiPoint"
        case multiLineString = "MultiLineString"
        case multiPolygon = "MultiPolygon"
        case geometryCollection = "GeometryCollection"
    }
}
