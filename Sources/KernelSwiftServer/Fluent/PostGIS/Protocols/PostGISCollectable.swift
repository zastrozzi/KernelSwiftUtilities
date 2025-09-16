//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import Foundation

public protocol PostGISCollectable: Equatable, Sendable {
    var baseGeometry: any KernelWellKnown.Geometry { get }
    func isEqual(to other: Any?) -> Bool
}

extension PostGISCollectable {
    public func isEqual(to other: Any?) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}

extension PostGISCollectable where Self: PostGISCodable {
    public var baseGeometry: any KernelWellKnown.Geometry { geometry }
}
