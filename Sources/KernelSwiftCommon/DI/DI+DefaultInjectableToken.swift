//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

extension KernelDI {
    public enum DefaultInjectableToken<Base: Injectable & Sendable>: InjectionToken, Sendable, Hashable {
        public static var liveValue: Base { Base() }
        public static var testValue: Base { Base() }
        public static var previewValue: Base { Base() }
    }
}
