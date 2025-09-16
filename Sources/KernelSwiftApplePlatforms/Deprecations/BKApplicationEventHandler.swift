//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/06/2022.
//

import Foundation
import SwiftUI

@available(*, deprecated)
public protocol BKApplicationEventHandler {
    associatedtype DIContainer: BKDIContainer
    var _container: DIContainer? { get set }
    func handleScenePhaseChange(_ scenePhaseChange: ScenePhase)
    func initialize()
}

@available(*, deprecated)
public extension BKApplicationEventHandler {
    mutating func connectToContainer<DI: BKDIContainer>(_ newContainer: DI) {
        self._container = newContainer as? DIContainer
    }
    
    var container: DIContainer {
        get {
            guard self._container != nil else { preconditionFailure(BKApplicationEventHandlerError.noContainer.localizedDescription) }
            return self._container!
        }
        
        set { preconditionFailure(BKApplicationEventHandlerError.noSettingContainer.localizedDescription) }
    }
}

public enum BKApplicationEventHandlerError: Error {
    case noContainer
    case noSettingContainer
}

extension BKApplicationEventHandlerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noContainer:
            return "[BKApplicationEventHandler] No DI Container"
        case .noSettingContainer:
            return "[BKApplicationEventHandler] DI Container cannot be altered from outside of connect method"
        }
    }
}
