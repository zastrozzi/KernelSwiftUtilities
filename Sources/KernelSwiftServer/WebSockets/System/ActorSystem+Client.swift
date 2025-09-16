//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/02/2025.
//

extension KernelWebSockets.ActorSystem {
    public func createClientManager(to address: Core.ServerAddress) async -> Managers.ClientManager {
        let manager: Managers.ClientManager = .init(system: self)
        await manager.connect(host: address.host, port: address.port)
        return manager
    }
    
    @discardableResult
    public func connectClient(to address: Core.ServerAddress) async throws -> Managers.ClientManager {
        let client = await createClientManager(to: address)
        logger.info("client connected to \(address)")
        return client
    }
}
