//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import Foundation

public protocol _KernelWellKnownGeometry: Equatable {
    var srid: UInt { get }
    func isEqual(to other: Self) -> Bool
}

extension _KernelWellKnownGeometry {
    public func isEqual(to other: some _KernelWellKnownGeometry) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
    
    static func equate(_ geo0: any _KernelWellKnownGeometry, _ geo1: any _KernelWellKnownGeometry) -> Bool {
        ((geo0, geo1) as? (Self, Self)).map(==) ?? false
    }
}

extension KernelWellKnown {
    public typealias Geometry = _KernelWellKnownGeometry
}
