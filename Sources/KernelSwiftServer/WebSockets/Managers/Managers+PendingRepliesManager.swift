//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelWebSockets.Managers {
    public actor PendingRepliesManager {
        private var callContinuations: [Core.CallID: EnvironmentContinuation<Data, Error>] = [:]
        
        public func expectReply(with continuation: EnvironmentContinuation<Data, Error>) -> Core.CallID {
            let callId: Core.CallID = .init()
            callContinuations[callId] = continuation
            return callId
        }
        
        public func receivedReply(for callId: Core.CallID, data: Data) throws {
            guard let continuation = callContinuations.removeValue(forKey: callId) else {
                throw KernelWebSockets.TypedError(.missingReplyContinuation, arguments: [callId])
            }
            continuation.resume(returning: data)
        }
        
        public func receivedError(for callId: Core.CallID, error: Error) throws {
            guard let continuation = callContinuations.removeValue(forKey: callId) else {
                throw KernelWebSockets.TypedError(.missingReplyContinuation, arguments: [callId])
            }
            continuation.resume(throwing: error)
        }
        
        nonisolated public func sendMessage(
            _ handler: @Sendable @escaping (Core.CallID) async throws -> Void
        ) async throws -> Data {
            try await withThrowingEnvironmentContinuation { continuation in
                Task {
                    let callId = await self.expectReply(with: continuation)
                    do { try await handler(callId) }
                    catch { try await self.receivedError(for: callId, error: error) }
                }
            }
        }
    }
}
