//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/11/2024.
//

import Vapor
import Queues
import KernelSwiftCommon

public protocol OAuth1ClientAPIPlatformAction: ClientAPIPlatformAction {
    static var skipSignedHeader: Bool { get }
    static var encodeEmptyRequest: Bool { get }
    func makeCustomHeaders<ErrorType: Codable>(for context: PlatformAction.ClientAPI.OAuth1Context<ErrorType>) async throws -> HTTPHeaders
}

extension OAuth1ClientAPIPlatformAction {
    public static var skipSignedHeader: Bool { false }
    public static var encodeEmptyRequest: Bool { false }
    
    public func makeCustomHeaders<ErrorType: Codable>(for context: PlatformAction.ClientAPI.OAuth1Context<ErrorType>) async throws -> HTTPHeaders {
        return HTTPHeaders()
    }
    
    @discardableResult
    public func perform<ErrorType: Codable>(
        for context: PlatformAction.ClientAPI.OAuth1Context<ErrorType>
    ) async throws -> ResponseBody {
        var builtHeaders = try await makeCustomHeaders(for: context)
        builtHeaders.add(contentsOf: try await context.makeHeaders())
        let builtHostUrl = try await context.getHostUrl()
        var trackingUrl: String = ""
        var startTime: Double = 0
        var receiveTime: Double = 0
        var decodeTime: Double = 0
        
        let clientRes = try await context.client.send(
            Self.method,
            headers: builtHeaders,
            to: "\(builtHostUrl)\(partialPath)"
        ) { clientReq in
            
            if !requestBody.allPropertiesAreNil() || Self.encodeEmptyRequest {
                
                try clientReq.content.encode(requestBody, as: Self.requestContentType)
                if let clientReqBody = clientReq.body?.string {
                    KernelNetworking.logger.debug("CLIENT REQUEST BODY: \(clientReqBody)")
                }
            }
            if !queryParams.allPropertiesAreNil() {
                if let queryEncoder = Self.customQueryEncoder ?? context.queryEncoder {
                    try clientReq.query.encode(queryParams, using: queryEncoder)
                } else {
                    try clientReq.query.encode(queryParams)
                }
                KernelNetworking.logger.debug("CLIENT REQUEST QUERY: \(clientReq.query)")
            }
            trackingUrl = clientReq.url.string
            if !Self.skipSignedHeader {
                let signedHeaders = try context.makeOAuthHeaders(for: clientReq)
                clientReq.headers.add(contentsOf: signedHeaders)
            }
            startTime = ProcessInfo.processInfo.systemUptime
        }
        
        receiveTime = ProcessInfo.processInfo.systemUptime
        
        switch clientRes.status.category {
        case .success: break;
        case .clientError:
            KernelNetworking.logger.warning("FAILED CLIENT ERROR: \(trackingUrl)")
            throw Abort(clientRes.status, reason: "\(try context.errorDecoder(clientRes))")
        case .serverError:
            KernelNetworking.logger.warning("FAILED CLIENT ERROR: \(trackingUrl)")
            throw Abort(clientRes.status, reason: "\(try context.errorDecoder(clientRes))")
        default: throw Abort(clientRes.status, reason: "\(clientRes.status)")
        }
        
        if ResponseBody.self == KernelSwiftCommon.Networking.HTTP.EmptyResponse.self {
            let decoded = KernelSwiftCommon.Networking.HTTP.EmptyResponse() as! ResponseBody
            decodeTime = ProcessInfo.processInfo.systemUptime
            KernelNetworking.logger.info("HTTP: \(trackingUrl) Network:\(receiveTime - startTime) Decode:\(decodeTime - receiveTime)")
            if let responseBody = clientRes.body?.string {
                KernelNetworking.logger.debug("CLIENT RESPONSE BODY: \(responseBody)")
            }
            
            return decoded
        } else {
            guard let decoded = try? clientRes.content.decode(ResponseBody.self, using: customDecoder ?? context.contentDecoder) else {
                
                do {
                    let _ = try clientRes.content.decode(ResponseBody.self, using: customDecoder ?? context.contentDecoder)
                } catch {
                    KernelNetworking.logger.warning("FAILED DECODE: \(error)")
                    let body = clientRes.body?.string ?? ""
                    KernelNetworking.logger.warning("RAW: \(body)")
                }
                throw Abort(.unprocessableEntity, reason: "Failed to decode response")
            }
            decodeTime = ProcessInfo.processInfo.systemUptime
            KernelNetworking.logger.info("HTTP: \(trackingUrl) Network:\(receiveTime - startTime) Decode:\(decodeTime - receiveTime)")
            if let responseBody = clientRes.body?.string {
                KernelNetworking.logger.debug("CLIENT RESPONSE BODY: \(responseBody)")
            }
            return decoded
        }
    }
}
