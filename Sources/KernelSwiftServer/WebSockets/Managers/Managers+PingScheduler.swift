//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import Foundation

extension KernelWebSockets.Managers {
    public actor PingScheduler {
        public weak var node: KernelWebSockets.Nodes.RemoteNode?
        let frequency: TimeInterval
        var loop: Task<Void, Error>?
        
        public init(
            node: KernelWebSockets.Nodes.RemoteNode,
            frequency: TimeInterval
        ) {
            self.node = node
            self.frequency = frequency
        }
        
        deinit {
            loop?.cancel()
            loop = nil
        }
        
        public func start() {
            stop()
            loop = Task.detached {
                while !Task.isCancelled {
                    try await Task.sleep(for: .seconds(self.frequency))
                    if Task.isCancelled { break }
                    guard let node = await self.node else { break }
                    try? await node.ping()
                }
            }
        }
        
        public func stop() {
            loop?.cancel()
            loop = nil
        }
    }
}
