//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import NIOCore
import NIOWebSocket
import NIOHTTP1

extension KernelWebSockets {
    public typealias AgentChannel = NIOAsyncChannel<WebSocketFrame, WebSocketFrame>
    public typealias OutboundWriter = NIOAsyncChannelOutboundWriter<WebSocketFrame>
    public typealias InboundStream = NIOAsyncChannelInboundStream<WebSocketFrame>
    public typealias ServerListeningChannel = NIOAsyncChannel<EventLoopFuture<Core.ServerUpgradeResult>, Never>
    public typealias ServerHTTPChannel = NIOAsyncChannel<HTTPServerRequestPart, HTTPClientResponsePart>
    public typealias OutboundHTTPWriter = NIOAsyncChannelOutboundWriter<HTTPClientResponsePart>
}

extension KernelWebSockets.AgentChannel {
    var remoteDescription: String {
        "\(channel.remoteAddress?.description ?? "unknown")"
    }
}

extension KernelWebSockets {
    final class HTTPByteBufferResponsePartHandler: ChannelOutboundHandler {
        typealias OutboundIn = HTTPPart<HTTPResponseHead, ByteBuffer>
        typealias OutboundOut = HTTPServerResponsePart
        
        func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
            let part = unwrapOutboundIn(data)
            switch part {
            case .head(let head):
                context.write(wrapOutboundOut(.head(head)), promise: promise)
            case .body(let buffer):
                context.write(wrapOutboundOut(.body(.byteBuffer(buffer))), promise: promise)
            case .end(let trailers):
                context.write(wrapOutboundOut(.end(trailers)), promise: promise)
            }
        }
    }
}
