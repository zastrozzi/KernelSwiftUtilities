//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/06/2023.
//

import Vapor

extension Request {
    public func kernelDI<Container: KernelServerPlatform.FeatureContainer>(_ containerType: Container.Type) -> Container {
        self.application.kernelDI(containerType)
    }
}

extension TypedRequest {
    public func kernelDI<Container: KernelServerPlatform.FeatureContainer>(_ containerType: Container.Type) -> Container {
        self.application.kernelDI(containerType)
    }
}
