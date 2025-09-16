//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/11/2024.
//

import Vapor
import Queues
import AsyncHTTPClient
import KernelSwiftCommon

public protocol ClientAPIPlatformAction: Codable, Sendable {
    associatedtype PathParams: Content = KernelSwiftCommon.Networking.HTTP.EmptyPath
    associatedtype QueryParams: Codable, Content = KernelSwiftCommon.Networking.HTTP.EmptyQuery
    associatedtype RequestBody: Content = KernelSwiftCommon.Networking.HTTP.EmptyRequest
    associatedtype ResponseBody: Content = KernelSwiftCommon.Networking.HTTP.EmptyResponse
    associatedtype APIJob: Job
    
//    var securityRequirements: [KOB_APISecurityRequirement] { get set }
    static var method: HTTPMethod { get }
    var pathParams: PathParams { get set }
    var queryParams: QueryParams { get set }
    var requestBody: RequestBody { get set }
    var partialPath: String { get }
    static var requestContentType: HTTPMediaType { get }
    
    var customDecoder: ContentDecoder? { get }
    static var customQueryEncoder: URLQueryEncoder? { get }
    
    func makeCustomHeaders<ErrorType: Codable>(for context: PlatformAction.ClientAPI.Context<ErrorType>) async throws -> HTTPHeaders
    
    init(pathParams: PathParams, queryParams: QueryParams, requestBody: RequestBody)
}

extension ClientAPIPlatformAction {
    public var customDecoder: ContentDecoder? { nil }
    public static var customQueryEncoder: URLQueryEncoder? { nil }
    public static var requestContentType: HTTPMediaType { .json }
}

extension ClientAPIPlatformAction {
    public func dispatch(to queue: Queue) async throws {
        try await queue.dispatch(APIJob.self, self as! Self.APIJob.Payload)
    }
}

extension ClientAPIPlatformAction {
    public var partialPath: String { return "" }
    
    public func makeCustomHeaders<ErrorType: Codable>(for context: PlatformAction.ClientAPI.Context<ErrorType>) async throws -> HTTPHeaders {
        return HTTPHeaders()
    }
}

extension ClientAPIPlatformAction where
    PathParams == KernelSwiftCommon.Networking.HTTP.EmptyPath,
    QueryParams == KernelSwiftCommon.Networking.HTTP.EmptyQuery,
    RequestBody == KernelSwiftCommon.Networking.HTTP.EmptyRequest
{
    public init() {
        self.init(
            pathParams: PlatformAction.ClientAPI.emptyPath,
            queryParams: PlatformAction.ClientAPI.emptyQuery,
            requestBody: PlatformAction.ClientAPI.emptyRequest
        )
    }
    
    public var pathParams: PathParams { get { .init() } set {} }
    public var queryParams: QueryParams { get { .init() } set {} }
    public var requestBody: RequestBody { get { .init() } set {} }
}

extension ClientAPIPlatformAction where
    PathParams == KernelSwiftCommon.Networking.HTTP.EmptyPath,
    QueryParams == KernelSwiftCommon.Networking.HTTP.EmptyQuery
{
    public init(requestBody: RequestBody) {
        self.init(
            pathParams: PlatformAction.ClientAPI.emptyPath,
            queryParams: PlatformAction.ClientAPI.emptyQuery,
            requestBody: requestBody
        )
    }
    
    public var pathParams: PathParams { get { .init() } set {} }
    public var queryParams: QueryParams { get { .init() } set {} }
}

extension ClientAPIPlatformAction where
    PathParams == KernelSwiftCommon.Networking.HTTP.EmptyPath,
    RequestBody == KernelSwiftCommon.Networking.HTTP.EmptyRequest
{
    public init(queryParams: QueryParams) {
        self.init(
            pathParams: PlatformAction.ClientAPI.emptyPath,
            queryParams: queryParams,
            requestBody: PlatformAction.ClientAPI.emptyRequest
        )
    }
    
    public var pathParams: PathParams { get { .init() } set {} }
    public var requestBody: RequestBody { get { .init() } set {} }
}

extension ClientAPIPlatformAction where
    QueryParams == KernelSwiftCommon.Networking.HTTP.EmptyQuery,
    RequestBody == KernelSwiftCommon.Networking.HTTP.EmptyRequest
{
    public init(pathParams: PathParams) {
        self.init(
            pathParams: pathParams,
            queryParams: PlatformAction.ClientAPI.emptyQuery,
            requestBody: PlatformAction.ClientAPI.emptyRequest
        )
    }
    
    public var queryParams: QueryParams { get { .init() } set {} }
    public var requestBody: RequestBody { get { .init() } set {} }
}

extension ClientAPIPlatformAction where
    PathParams == KernelSwiftCommon.Networking.HTTP.EmptyPath
{
    public init(queryParams: QueryParams, requestBody: RequestBody) {
        self.init(
            pathParams: PlatformAction.ClientAPI.emptyPath,
            queryParams: queryParams,
            requestBody: requestBody
        )
    }
    
    public var pathParams: PathParams { get { .init() } set {} }
}

extension ClientAPIPlatformAction where
    QueryParams == KernelSwiftCommon.Networking.HTTP.EmptyQuery
{
    public init(pathParams: PathParams, requestBody: RequestBody) {
        self.init(
            pathParams: pathParams,
            queryParams: PlatformAction.ClientAPI.emptyQuery,
            requestBody: requestBody
        )
    }
    
    public var queryParams: QueryParams { get { .init() } set {} }
}

extension ClientAPIPlatformAction where
    RequestBody == KernelSwiftCommon.Networking.HTTP.EmptyRequest
{
    public init(pathParams: PathParams, queryParams: QueryParams) {
        self.init(
            pathParams: pathParams,
            queryParams: queryParams,
            requestBody: PlatformAction.ClientAPI.emptyRequest
        )
    }
    
    public var requestBody: RequestBody { get { .init() } set {} }
}

public protocol RouteContextClientAPIPlatformAction: RouteContext {
    associatedtype ActionType: ClientAPIPlatformAction = EmptyKernelPlatformAction
}

extension ByteBuffer {
    public var string: String {
        .init(decoding: self.readableBytesView, as: UTF8.self)
    }
}


extension ClientAPIPlatformAction {
    @discardableResult
    public func perform<ErrorType: Codable>(for context: PlatformAction.ClientAPI.Context<ErrorType>) async throws -> ResponseBody {
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
            if !requestBody.allPropertiesAreNil() {
                try clientReq.content.encode(requestBody, as: Self.requestContentType)
                if let clientReqBody = clientReq.body?.string {
                    KernelNetworking.logger.info("CLIENT REQUEST BODY: \(clientReqBody)")
                }
            }
            if !queryParams.allPropertiesAreNil() {
                if let queryEncoder = Self.customQueryEncoder ?? context.queryEncoder {
                    try clientReq.query.encode(queryParams, using: queryEncoder)
                } else {
                    try clientReq.query.encode(queryParams)
                }
                KernelNetworking.logger.info("CLIENT REQUEST QUERY: \(clientReq.query)")
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
