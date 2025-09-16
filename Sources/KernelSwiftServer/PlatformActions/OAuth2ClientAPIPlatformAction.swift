//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/11/2024.
//

import Vapor
import Queues
import KernelSwiftCommon

public protocol OAuth2ClientAPIPlatformAction: ClientAPIPlatformAction {
    associatedtype AuthorisationType: Sendable, Codable
    static var defaultAuthorisationType: AuthorisationType { get }
    var authorisationType: AuthorisationType? { get set }
    static var encodeEmptyRequest: Bool { get }
}

extension OAuth2ClientAPIPlatformAction {
    public func withAuthorisationType(_ authorisationType: AuthorisationType) -> Self {
        var copy = self
        copy.authorisationType = authorisationType
        return copy
    }
    
    public static var encodeEmptyRequest: Bool { false }
    
    @discardableResult
    public func perform<ErrorType: Codable>(
        for context: PlatformAction.ClientAPI.OAuth2Context<ErrorType, AuthorisationType>,
        authedAs customAuthorisationType: AuthorisationType? = nil
    ) async throws -> ResponseBody {
        var builtHeaders = try await context.makeOAuthHeaders(authorisationType: customAuthorisationType ?? authorisationType ?? Self.defaultAuthorisationType)
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
//            print("CLIENT RES", clientRes.body?.string ?? "")
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
