//
//  File.swift
//
//
//  Created by Jonathan Forbes on 29/03/2022.
//

import Foundation
import NIO

public enum CoroutineState: Int {
    case INITIALIZED = 0
    case STARTED = 1
    case RESTARTED = 2
    case YIELDED = 3
    case EXITED = 4
}

public typealias CoroutineScopeFn<T> = (Coroutine) throws -> T
public typealias CoroutineResumer = () -> Void

public protocol Coroutine {
    var currentState: CoroutineState { get }
    
    func yield() throws -> Void
    
    func yieldUntil(cond: () throws -> Bool) throws -> Void
    
    func yieldUntil(_ beforeYield: (@escaping CoroutineResumer) -> Void) throws -> Void
    
    func delay(_ timeInterval: TimeAmount) throws -> Void
    
    func continueOn(_ scheduler: NIOThreadPool) throws -> Void
    
    func continueOn(_ scheduler: EventLoop) throws -> Void
    
    func continueOn(_ scheduler: DispatchQueue) throws -> Void
}

enum CoroutineTransfer<T> {
    case YIELD
    case DELAY(TimeAmount)
    case CONTINUE_ON_SCHEDULER(CoroutineScheduler)
    case EXIT(Result<T, Error>)
}
