//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation

@available(*, deprecated)
public protocol KernelSwiftHttpService {
    var sessionManager: URLSession { get set }
    func request(_ urlRequest: URLRequest) -> URLSessionDataTask
    func isConnectedToInternet() -> Bool
}

@available(*, deprecated)
final class KernelSwiftDefaultHttpService: KernelSwiftHttpService {

    init(rootQueueLabel: String) {
        let rootQueue = DispatchQueue(label: rootQueueLabel)
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.underlyingQueue = rootQueue
//        let delegate = URLSessionDelegate.()
        let configuration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: configuration,
                                    delegate: nil,
                                    delegateQueue: queue)
        self.sessionManager = urlSession
//        self.networkReachabilityManager = NetworkReachabilityManager()!
    }
    
    var sessionManager: URLSession
//    var networkReachabilityManager: NetworkReachabilityManager
    
    
    func createConfiguredSession() {
        
    }
    
    func request(_ urlRequest: URLRequest) -> URLSessionDataTask {
        return sessionManager.dataTask(with: urlRequest)
    }
    
    func isConnectedToInternet() -> Bool {
        true
//        return self.networkReachabilityManager.isReachable
    }
}
