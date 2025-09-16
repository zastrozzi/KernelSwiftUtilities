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
    public func resolve<Act>(
        id: ActorID,
        as _: Act.Type
    ) throws -> Act? where Act: DistributedActor, Act.ID == ActorID {
        if !Self.locked { lock.lock() }
        defer { if !Self.locked { lock.unlock() } }
        let taggedLogger = logger.with(id).withOp()
        
        guard let found = managedActors[id] else {
            taggedLogger.trace("Actor not local")
            if let onDemandResolver {
                taggedLogger.trace("On Demand Resolver Present")
                
                let resolvedOnDemandActor = Self.$locked.withValue(true) { onDemandResolver(id) }
                if let resolvedOnDemandActor {
                    taggedLogger.trace("attempt to resolve on-demand as \(resolvedOnDemandActor)")
                    if let wellTyped = resolvedOnDemandActor as? Act {
                        taggedLogger.trace("resolved on-demand as \(Act.self)")
                        return wellTyped
                    }
                    else {
                        taggedLogger.error("resolved on demand, but wrong type: \(type(of: resolvedOnDemandActor))")
                        throw KernelWebSockets.TypedError.resolveFailed(id)
                    }
                }
                else { taggedLogger.trace("resolve on demand") }
            }
            
            taggedLogger.trace("resolved as remote")
            return nil
        }
        
        guard let wellTyped = found as? Act else {
            throw KernelWebSockets.TypedError.resolveFailedToMatchActorType(found: type(of: found), expected: Act.self)
        }
        logger.trace("RESOLVED LOCAL: \(wellTyped)")
        return wellTyped
    }
    
    func resolveAny(id: ActorID) -> (any DistributedActor)? {
        lock.lock()
        defer { lock.unlock() }
        
        let taggedLogger = logger.with(id).withOp()
        
        guard let resolved = managedActors[id] else {
            if let onDemandResolver {
                taggedLogger.trace("On Demand Resolver Present")
                return Self.$locked.withValue(true) {
                    if let resolvedOnDemandActor = onDemandResolver(id) {
                        taggedLogger.trace("Resolved ON DEMAND as \(resolvedOnDemandActor)")
                        return resolvedOnDemandActor
                    }
                    else {
                        taggedLogger.trace("not resolved")
                        return nil
                    }
                }
            }
            else { taggedLogger.trace("no onDemandResolver") }
            
            taggedLogger.trace("definitely remote")
            return nil
        }
        
        taggedLogger.trace("resolved as \(resolved)")
        return resolved
    }
}
