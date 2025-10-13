//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/06/2022.
//

import Foundation
import SwiftUI

@available(*, deprecated)
public protocol KernelSwiftApplicationEventHandler {
    associatedtype DIContainer: KernelSwiftDIContainer
    var _container: DIContainer? { get set }
    func handleScenePhaseChange(_ scenePhaseChange: ScenePhase)
    func initialize()
}

@available(*, deprecated)
public extension KernelSwiftApplicationEventHandler {
    mutating func connectToContainer<DI: KernelSwiftDIContainer>(_ newContainer: DI) {
        self._container = newContainer as? DIContainer
    }
    
    var container: DIContainer {
        get {
            guard self._container != nil else { preconditionFailure(KernelSwiftApplicationEventHandlerError.noContainer.localizedDescription) }
            return self._container!
        }
        
        set { preconditionFailure(KernelSwiftApplicationEventHandlerError.noSettingContainer.localizedDescription) }
    }
}

public enum KernelSwiftApplicationEventHandlerError: Error {
    case noContainer
    case noSettingContainer
}

extension KernelSwiftApplicationEventHandlerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noContainer:
            return "[KernelSwiftApplicationEventHandler] No DI Container"
        case .noSettingContainer:
            return "[KernelSwiftApplicationEventHandler] DI Container cannot be altered from outside of connect method"
        }
    }
}
