//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

extension KernelDI {
    public enum InjectionContext: Sendable {
        case live
        case preview
        case test
    }
    
    public enum InjectionContextToken: KernelDI.InjectionToken {
        public static let liveValue = InjectionContext.live
        public static let previewValue = InjectionContext.preview
        public static let testValue = InjectionContext.test
    }
}

extension KernelDI.InjectionContext {
    public static let defaultContext: Self = {
        let env = ProcessInfo.processInfo.environment
        var inferredContext: Self {
            if env["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return .preview }
            else if _DestinationIsTesting { return .test }
            else { return .live }
        }
        
        guard let value = env["DI_CONTEXT"] else { return inferredContext }
        
        switch value {
        case "live": return .live
        case "preview": return .preview
        case "test": return .test
        default:
            KernelDI.logger.warning("DI_CONTEXT value \(value) is invalid")
            return inferredContext
        }
    }()
}

extension KernelDI.Injector {
    public var context: KernelDI.InjectionContext {
        get { self[KernelDI.InjectionContextToken.self] }
        set { self[KernelDI.InjectionContextToken.self] = newValue }
    }
    
//    public func setContext(_ context: KernelDI.InjectionContext) {
//        self[KernelDI.InjectionContextToken.self] = context
//    }
}
