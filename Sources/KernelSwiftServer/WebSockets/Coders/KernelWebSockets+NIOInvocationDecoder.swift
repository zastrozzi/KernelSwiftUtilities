//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import Foundation
import Distributed
import Logging
import NIOCore
import NIOWebSocket

extension KernelWebSockets {
    public class NIOInvocationDecoder: DistributedTargetInvocationDecoder {
        public typealias SerializationRequirement = any Codable
        
        let decoder: JSONDecoder
        let envelope: Core.RemoteCallEnvelope
        let logger: Logger
        var argumentsIterator: Array<Data>.Iterator
        
        init(
            system: ActorSystem,
            envelope: Core.RemoteCallEnvelope
            
        ) {
            self.envelope = envelope
            self.logger = system.logger
            self.argumentsIterator = envelope.args.makeIterator()
            let decoder = JSONDecoder()
            decoder.userInfo[.actorSystemKey] = system
            self.decoder = decoder
        }
        
        public func decodeGenericSubstitutions() throws -> [Any.Type] {
            envelope.genericSubs.compactMap { _typeByName($0) }
        }
        
        public func decodeNextArgument<Argument: Codable>() throws -> Argument {
            let taggedLogger = logger.withOp()
            
            guard let data = argumentsIterator.next() else {
                taggedLogger.trace("none left")
                throw TypedError.insufficientEnvelopeArgs(Argument.self)
            }
            
            do {
                let value = try decoder.decode(Argument.self, from: data)
                taggedLogger.trace("decoded: \(value)")
                return value
            }
            catch {
                taggedLogger.trace("error: \(error)")
                throw error
            }
        }
        
        public func decodeErrorType() throws -> Any.Type? { nil }
        public func decodeReturnType() throws -> Any.Type? { nil }
    }
}
