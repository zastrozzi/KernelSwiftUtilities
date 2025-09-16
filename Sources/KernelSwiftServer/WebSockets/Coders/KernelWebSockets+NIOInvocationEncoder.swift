//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/02/2025.
//

import Distributed
import Foundation

extension KernelWebSockets {
    public class NIOInvocationEncoder: DistributedTargetInvocationEncoder {
        public typealias SerializationRequirement = any Codable
        var genericSubs: [String] = []
        var argumentData: [Data] = []
        
        public func recordGenericSubstitution<T>(_: T.Type) throws {
            if let name = _mangledTypeName(T.self) {
                genericSubs.append(name)
            }
        }
        
        public func recordArgument<Value: Codable>(_ argument: RemoteCallArgument<Value>) throws {
            let data = try JSONEncoder().encode(argument.value)
            argumentData.append(data)
        }
        
        public func recordReturnType<R: Codable>(_: R.Type) throws {}
        
        public func recordErrorType<E: Error>(_: E.Type) throws {}
        
        public func doneRecording() throws {}
    }
}
