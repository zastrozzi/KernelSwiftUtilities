//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/02/2025.
//

import KernelSwiftCommon
import Vapor
import NIO
import NIOHTTP1

extension KernelWebSockets.ActorSystem {
    public func createServerManager(at address: Core.ServerAddress) async -> Managers.ServerManager {
        let server: Managers.ServerManager = .init(system: self, on: address)
        await server.connect(host: address.host, port: address.port)
        return server
    }
    
    @discardableResult
    public func runServer(at address: Core.ServerAddress) async throws -> Managers.ServerManager {
        guard address.scheme == .insecure else { throw KernelWebSockets.TypedError(.secureServerNotSupported) }
        let server = await createServerManager(at: address)
        managers.append(server)
        return server
    }
    
    public func handleUpgradeResult(_ upgradeResult: EventLoopFuture<Core.ServerUpgradeResult>) async {
        do {
            switch try await upgradeResult.get() {
            case let .websocket(websocketChannel, remoteNodeId):
                logger.trace("Handling websocket connection")
                try await handleWebsocketChannel(websocketChannel, remoteNodeId: remoteNodeId)
                logger.trace("Done handling websocket connection")
            case let .notUpgraded(httpChannel):
                logger.trace("Handling HTTP connection")
                try await handleHTTPChannel(httpChannel)
                logger.trace("Done handling HTTP connection")
            }
        }
        catch {
            if error as? CancellationError == nil {
                logger.error("Error handling server connection: \(error)")
            }
        }
    }
    
    func closeOnError(channel: KernelWebSockets.AgentChannel) async {
        var data = channel.channel.allocator.buffer(capacity: 2)
        data.write(webSocketErrorCode: .protocolError)
        
        do {
            try? await channel.channel.writeAndFlush(Core.WireEnvelope.connectionClose)
            try await channel.channel.close(mode: .output)
        }
        catch {
            logger.error("Error closing channel after error: \(error)")
        }
    }
    
    private func handleWebsocketChannel(
        _ channel: KernelWebSockets.AgentChannel,
        remoteNodeId: Core.NodeIdentity
    ) async throws {
        let taggedLogger = logger.withOp().with(channel)
        taggedLogger.info("new client connection")
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                try await self.dispatchIncomingFrames(channel: channel, remoteNodeId: remoteNodeId)
            }
            
            try await group.next()
            group.cancelAll()
        }
        
        taggedLogger.info("client connection closed")
    }
    
    private func handleHTTPChannel(
        _ channel: KernelWebSockets.ServerHTTPChannel
    ) async throws {
        try await channel.executeThenClose { inbound, outbound in
            for try await requestPart in inbound {
                guard case .head(let head) = requestPart else { return }
                
                guard case .GET = head.method, head.headers.xKernelWebSocketsNodeIdentity != nil else {
                    return try await Self.respond405(writer: outbound)
                }
                
                var headers = HTTPHeaders()
                headers.xKernelWebSocketsNodeIdentity = nodeId
                headers.add(name: "Content-Type", value: "text/html")
                headers.add(name: "Content-Length", value: String(Self.responseBody.readableBytes))
                headers.add(name: "Connection", value: "close")
                let responseHead: HTTPResponseHead = .init(
                    version: .init(major: 1, minor: 1),
                    status: .ok,
                    headers: headers
                )
                
                try await outbound.write(contentsOf: [
                    .head(responseHead),
                    .body(Self.responseBody),
                    .end(nil)
                ])
            }
        }
    }
    
    private static func respond405(writer: KernelWebSockets.OutboundHTTPWriter) async throws
    {
        var headers = HTTPHeaders()
        headers.add(name: "Connection", value: "close")
        headers.add(name: "Content-Length", value: "0")
        let head: HTTPResponseHead = .init(
            version: .http1_1,
            status: .methodNotAllowed,
            headers: headers
        )
        
        try await writer.write(contentsOf: [.head(head), .end(nil)])
    }

    private static let responseBody: ByteBuffer = .init(string:
"""
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Swift NIO WebSocket Test Page</title>
    <script>
        var wsconnection = new WebSocket("ws://localhost:8888/websocket");
        wsconnection.onmessage = function (msg) {
            var element = document.createElement("p");
            element.innerHTML = msg.data;

            var textDiv = document.getElementById("websocket-stream");
            textDiv.insertBefore(element, null);
        };
    </script>
  </head>
  <body>
    <h1>WebSocket Stream</h1>
    <div id="websocket-stream"></div>
  </body>
</html>
"""
    )
}
