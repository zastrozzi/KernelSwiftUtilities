//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/06/2023.
//

import Vapor

//extension Application {
//    public struct KernelServicesStorageKey: StorageKey {
//        public typealias Value = KernelServices
//    }
//    
//    open class KernelServices {
//        public let app: Application
//        
//        public init(app: Application) {
//            self.app = app
//        }
//    }
//    
//    public var kServices: KernelServices {
//        get {
//            guard let kernelServices = storage[KernelServicesStorageKey.self] else { fatalError("Kernel Services container has not been initialised") }
//            return kernelServices
//        }
//        set { storage[KernelServicesStorageKey.self] = newValue }
//    }
//    
//    public static func configureKernelServices(for app: Application) async throws {
//        app.kServices = .init(app: app)
//        app.kServices.resolvedHost = .init()
//    }
//}
