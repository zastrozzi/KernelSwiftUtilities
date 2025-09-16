//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/06/2023.
//

import Vapor

extension KernelServerPlatform {
    public struct StorageKeyWrapper<Wrapped: Any & Sendable>: StorageKey {
        public typealias Value = Wrapped
    }
}
