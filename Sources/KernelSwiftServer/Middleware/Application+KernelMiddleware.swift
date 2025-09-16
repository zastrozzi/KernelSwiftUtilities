//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/06/2023.
//

import Vapor
//
//extension Application {
//    public struct KernelMiddlewareStorageKey: StorageKey {
//        public typealias Value = KernelMiddleware
//    }
//    
//    open class KernelMiddleware {
//        public let app: Application
//        
//        public init(app: Application) {
//            self.app = app
//        }
//    }
//    
//    public var kMiddleware: KernelMiddleware {
//        get {
//            guard let kernelMiddleware = storage[KernelMiddlewareStorageKey.self] else { fatalError("Kernel Middleware container has not been initialised") }
//            return kernelMiddleware
//        }
//        set { storage[KernelMiddlewareStorageKey.self] = newValue }
//    }
//    
//    public static func configureKernelMiddleware(for app: Application) async throws {
////        app.kMiddleware = .init(app: app)
////        app.kMiddleware.resolvedHost = .init()
//        app.middleware.use(app.kMiddleware.resolvedHost)
//    }
//}
