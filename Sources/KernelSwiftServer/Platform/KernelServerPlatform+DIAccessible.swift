//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor

public protocol DIAccessible<FeatureContainer> {
    associatedtype FeatureContainer: KernelServerPlatform.FeatureContainer
    var app: Application { get }
}

extension DIAccessible {
    public var featureContainer: FeatureContainer { kernelDI(FeatureContainer.self) }
    
    public func kernelDI<Container: KernelServerPlatform.FeatureContainer>(_ containerType: Container.Type) -> Container {
        app.kernelDI(containerType)
    }
}
