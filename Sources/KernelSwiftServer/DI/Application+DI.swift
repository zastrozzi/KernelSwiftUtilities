//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension KernelDI.Injector {
    public var vapor: Application {
        get { self[Application.Token.self] }
        set { self[Application.Token.self] = newValue }
    }
}

extension Application: _KernelDIInjectable {
    public convenience init() {
        fatalError("Default DI init is deprecated. Application must be initialised via initDI(...)")
    }
    
    public static func initDI(
        _ environment: inout Environment,
        _ eventLoopGroupProvider: EventLoopGroupProvider = .singleton
    ) async throws -> Application {
        KernelDI.setInjectable(try await Application.make(environment))
    }
    
    struct AsyncLifecycleHandler: Vapor.LifecycleHandler {
        func shutdownAsync(_ application: Application) async {
            do {
                try await application.threadPool.shutdownGracefully()
            } catch {
                application.logger.debug("Failed to shutdown threadpool", metadata: ["error": "\(error)"])
            }
        }
    }
}
