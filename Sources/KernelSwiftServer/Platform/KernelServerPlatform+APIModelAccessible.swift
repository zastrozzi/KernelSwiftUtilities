//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import Vapor

public protocol FeatureContainerAPIModelAccessible {
    associatedtype APIModel
}

public protocol APIModelAccessible {
    associatedtype FeatureContainer: KernelServerPlatform.FeatureContainer & FeatureContainerAPIModelAccessible
}

extension APIModelAccessible {
    public typealias APIModel = FeatureContainer.APIModel
}

public protocol APIModelAccess<APIModel>: APIModelAccessible {
    associatedtype APIModel = Never
}
