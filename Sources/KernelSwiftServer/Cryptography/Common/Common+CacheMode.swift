//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/10/2023.
//

import Foundation

extension KernelCryptography.Common {
    public enum CacheMode: Sendable {
    case disabled(Int)
    case paused(Int)
    case active(Int)
        
        public var isActive: Bool {
            if case .active = self { true } else { false }
        }
    }
}
