//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/05/2023.
//

//import Foundation
import DequeModule

struct QueueBufferStateMachine<Element> {
    private enum State {
        case idle
        case buffering(buffer: Deque<Element>)
        case waitingForUpstream(downstreamContinuation: UnsafeContinuation<Result<Element?, Error>, Never>)
        case finished(buffer: Deque<Element>?, error: (Error)?)
        case modifying
    }
    
    private var state: State
    private let policy: QueueBufferPolicy

    init(policy: QueueBufferPolicy) {
        self.policy = policy
        self.state = .idle
    }
}
