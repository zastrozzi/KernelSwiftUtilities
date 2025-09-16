//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/02/2025.
//

import KernelSwiftCommon
import Vapor
import Distributed
import NIOWebSocket

extension KernelWebSockets.ActorSystem {
    public func makeInvocationEncoder() -> InvocationEncoder { .init() }
    
    public func actorReady<Act>(
        _ actor: Act
    ) where Act : DistributedActor, ActorID == Act.ID {
        logger.with(actor.id).trace("Actor Ready")
        if !Self.locked { lock.lock() }
        defer { if !Self.locked { lock.unlock() } }
        managedActors[actor.id] = actor
    }
    
    public func shutdownGracefully() async {
        await withDiscardingTaskGroup { group in
            for manager in self.managers {
                group.addTask { await manager.cancel() }
            }
        }
    }
    
    public func assignID<Act>(_ actorType: Act.Type) -> ActorID where Act: DistributedActor, Act.ID == ActorID {
        if let hintedId = Self.actorIdHint {
            if !Self.locked { lock.lock() }
            defer { if !Self.locked { lock.unlock() } }
            if let existingActor = managedActors[hintedId] {
                preconditionFailure("Illegal reuse of ActorIdentity (\(hintedId)). Existing: \(existingActor) | Attempted: \(actorType)")
            }
            return hintedId
        }
        let uuid = UUID().uuidString
        let typeFullName = "\(Act.self)"
        guard typeFullName.split(separator: ".").last != nil else { return .init(id: uuid) }
        return .init(id: "\(uuid)")
    }
    
    public func resignID(_ id: ActorID) {
        logger.with(id).trace("Resign ID")
        lock.lock()
        defer { lock.unlock() }
        managedActors.removeValue(forKey: id)
    }
    
    public func registerOnDemandResolver(resolver: @escaping OnDemandResolver) {
        lock.lock()
        defer { self.lock.unlock() }
        onDemandResolver = resolver
    }
}
