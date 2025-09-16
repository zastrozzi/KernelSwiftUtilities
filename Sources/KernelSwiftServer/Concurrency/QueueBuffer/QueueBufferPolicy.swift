//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/05/2023.
//

import Foundation
import AsyncAlgorithms

public enum QueueBufferPolicy: Sendable {
    case unbounded
    case bufferingNewest(limit: UInt)
    case bufferingOldest(limit: UInt)
    
    var positiveLimit: Bool {
        switch self {
        case .unbounded: return true
        case .bufferingNewest(let limit), .bufferingOldest(let limit): return limit > 0
        }
    }
}

struct QueueBufferStorage<Element>: Sendable {
//    private let state: AsyncManagedCriticalState<QueueBufferStateMachine<Element>>
}
