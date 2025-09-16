//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import Vapor
//import KernelSwiftCommon
import KernelSwiftCommon

public protocol AbstractRouteContext {
    static var requestBodyType: Any.Type { get }
    static var queryParamsType: Any.Type { get }
    static var defaultContentType: HTTPMediaType? { get }
    static var requestQueryParams: [AbstractQueryParam] { get }
    static var responseBodyTuples: [(statusCode: Int, contentType: HTTPMediaType?, responseBodyType: Any.Type)] { get }
    static var requestBodyTuples: [(contentType: HTTPMediaType?, requestBodyType: Any.Type)] { get }
}

public enum DefaultRouteCollectionContext {
    case root
}

public protocol ContextSwitchingRouteCollection: RouteCollection {
    associatedtype RouteCollectionContext: Equatable
    var routeCollectionContext: RouteCollectionContext { get }
    static var openAPITag: String { get }
    static var resolvedOpenAPITag: String { get }
    init(forContext routeCollectionContext: RouteCollectionContext)
}

extension ContextSwitchingRouteCollection {
    public static var resolvedOpenAPITag: String { openAPITag }
}

public protocol FeatureRouteCollection: RouteCollection {
    associatedtype Feature: FeatureRoutes
}

extension ContextSwitchingRouteCollection where Self: FeatureRouteCollection {
    public static var resolvedOpenAPITag: String { "[\(Feature.featureTag)] \(openAPITag)" }
    public static var featureTag: String { Feature.featureTag }
}

public protocol FeatureRoutes {
    static var featureTag: String { get }
    associatedtype FeatureContainer: KernelServerPlatform.FeatureContainer
    static var app: Application { get }
}

extension FeatureRoutes {
    public static var app: Application { KernelDI.inject(\.vapor) }
    public static var featureContainer: FeatureContainer { app.kernelDI(FeatureContainer.self) }
}

extension FeatureRouteCollection {
    public var featureContainer: Feature.FeatureContainer { Feature.featureContainer }
    public typealias FeatureContainer = Feature.FeatureContainer
}

//extension ContextSwitchingRouteCollection {
//    public typealias RouteCollectionContext = DefaultRouteCollectionContext
//}

public protocol AbstractJSONRouteContext: AbstractRouteContext {}

extension AbstractJSONRouteContext {
    public static var defaultContentType: HTTPMediaType? { .json }
}

public protocol RouteContext: AbstractRouteContext, Sendable {
    associatedtype RequestBodyType: Decodable = KernelSwiftCommon.Networking.HTTP.EmptyRequest
    associatedtype QueryParamsType: Decodable = KernelSwiftCommon.Networking.HTTP.EmptyQuery
    associatedtype PathParamsType: Decodable = KernelSwiftCommon.Networking.HTTP.EmptyPath
    associatedtype ResponseBodyType: Content = KernelSwiftCommon.Networking.HTTP.EmptyResponse
//    associatedtype PlatformActionType: KernelPlatformAction = EmptyKernelPlatformAction
    static var shared: Self { get }
    init()
}

extension RouteContext {
    public typealias WithStatus<Status: _KernelHTTPStatusRepresentable> = RouteContextWithStatus<Self, Status>
}
extension RouteContext where ResponseBodyType == KernelSwiftCommon.Networking.HTTP.EmptyResponse {
    public var ok: ResponseContext<ResponseBodyType> { .success(.ok) }
    public var accepted: ResponseContext<ResponseBodyType> { .success(.accepted) }
}
extension TypedRequest where Context.ResponseBodyType == KernelSwiftCommon.Networking.HTTP.EmptyResponse {
//    public let success: ResponseContext<ResponseBodyType> {.success(Status.status)
    
    public func respondOk() async throws -> Response {
        return try await response.ok.encode(.init())
    }
    
    public func respondAccepted() async throws -> Response {
        return try await response.accepted.encode(.init())
    }
}

@dynamicMemberLookup
public struct RouteContextWithStatus<Context: RouteContext, Status: _KernelHTTPStatusRepresentable>: RouteContext {
    public typealias RequestBodyType = Context.RequestBodyType
    public typealias QueryParamsType = Context.QueryParamsType
    public typealias PathParamsType = Context.PathParamsType
    public typealias ResponseBodyType = Context.ResponseBodyType
    public var underlyingContext: Context = .init()
    public init() {}
    
    public subscript<Value>(dynamicMember member: KeyPath<Context, Value>) -> Value {
        return underlyingContext[keyPath: member]
    }
    
    public let success: ResponseContext<ResponseBodyType> = .success(Status.status)
}

public struct GetRouteContext<ResponseBodyType: Content>: RouteContext {
    public typealias ResponseBodyType = ResponseBodyType
    public init() {}
    
    public let success: ResponseContext<ResponseBodyType> = .success(.ok)
}

public struct GetRouteContextWithStatus<ResponseBodyType: Content, CustomResponseStatus: _KernelHTTPStatusRepresentable>: RouteContext {
    public init() {}
    
    public let success: ResponseContext<ResponseBodyType> = .success(CustomResponseStatus.status)
}

public struct DefaultPaginatedQueryParams: Codable, Sendable {
    public let limit: Int
    public let offset: Int
    public let order: KPPaginationOrder
    public let orderBy: String
    public let includeDeleted: Bool
    
    public init(limit: Int, offset: Int, order: KPPaginationOrder, orderBy: String, includeDeleted: Bool) {
        self.limit = limit
        self.offset = offset
        self.order = order
        self.orderBy = orderBy
        self.includeDeleted = includeDeleted
    }
    
    enum CodingKeys: String, CodingKey {
        case limit
        case offset
        case order
        case orderBy = "order_by"
        case includeDeleted = "include_deleted"
    }
}

public struct PaginatedGetRouteContext<ResponseBodyType: Content & OpenAPIEncodableSampleable & Equatable>: DefaultPaginationRouteContextDecodable {
    
    
    public typealias QueryParamsType = DefaultPaginatedQueryParams
    
    public init() {}
    public let success: ResponseContext<KPPaginatedResponse<ResponseBodyType>> = .success(.ok)
    public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
    public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
    public var order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
    public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
    public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
}

public protocol DefaultPaginationRouteContextDecodable: RouteContext where ResponseBodyType: Content & OpenAPIEncodableSampleable & Equatable {

    var limit: QueryParam<Int> { get }
    var offset: QueryParam<Int> { get }
    var order: EnumQueryParam<KPPaginationOrder> { get }
    var orderBy: QueryParam<String> { get }
    var includeDeleted: QueryParam<Bool> { get }
}

extension DefaultPaginationRouteContextDecodable {
    public var limit: QueryParam<Int> { .init(name: "limit", defaultValue: 30) }
    public var offset: QueryParam<Int> { .init(name: "offset", defaultValue: 0) }
    public var order: EnumQueryParam<KPPaginationOrder> {  .init(name: "order", defaultValue: .init(.descending)) }
    public var orderBy: QueryParam<String> { .init(name: "order_by", defaultValue: "db_created_at") }
    public var includeDeleted: QueryParam<Bool> { .init(name: "include_deleted", defaultValue: false) }
}

extension TypedRequest {
    public func decodeDefaultPagination() -> DefaultPaginatedQueryParams where Context: DefaultPaginationRouteContextDecodable {
        .init(
            limit: query.limit ?? 30,
            offset: query.offset ?? 0,
            order: query.order?.value ?? .descending,
            orderBy: query.orderBy?.lowercaseSnakeCased() ?? "db_created_at",
            includeDeleted: query.includeDeleted ?? false
        )
    }
    
    public func decodeMappedPagination(_ propertyMap: Dictionary<String, String> = [:]) -> DefaultPaginatedQueryParams where Context: DefaultPaginationRouteContextDecodable {
        let orderBy: String
        if
            let queryOrderBy = query.orderBy,
            let mappedOrderBy = propertyMap[queryOrderBy]
        { orderBy = mappedOrderBy }
        else { orderBy = query.orderBy?.lowercaseSnakeCased() ?? "db_created_at" }
        return .init(
            limit: query.limit ?? 30,
            offset: query.offset ?? 0,
            order: query.order?.value ?? .descending,
            orderBy: orderBy,
            includeDeleted: query.includeDeleted ?? false
        )
    }
}

public struct PaginatedGetRouteContextWithStatus<
    ResponseBodyType: Content & OpenAPIEncodableSampleable & Equatable,
    CustomResponseStatus: _KernelHTTPStatusRepresentable
>: RouteContext {
    public init() {}
    public let success: ResponseContext<KPPaginatedResponse<ResponseBodyType>> = .success(CustomResponseStatus.status)
    public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
    public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
    public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
    public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
    public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
}

public struct PostRouteContext<RequestBodyType: Content, ResponseBodyType: Content>: RouteContext {
    public typealias RequestBodyType = RequestBodyType
    public typealias ResponseBodyType = ResponseBodyType
    public init() {}
    public let success: ResponseContext<ResponseBodyType> = .success(.created)
}

public struct PostRouteContextWithStatus<
    RequestBodyType: Content, 
    ResponseBodyType: Content,
    CustomResponseStatus: _KernelHTTPStatusRepresentable
>: RouteContext {
    public typealias RequestBodyType = RequestBodyType
    public typealias ResponseBodyType = ResponseBodyType
    public init() {}
    public let success: ResponseContext<ResponseBodyType> = .success(CustomResponseStatus.status)
}

public struct EmptyRequestPostRouteContext<ResponseBodyType: Content>: RouteContext {
    public typealias RequestBodyType = KernelSwiftCommon.Networking.HTTP.EmptyRequest
    public typealias ResponseBodyType = ResponseBodyType
    public init() {}
    public let success: ResponseContext<ResponseBodyType> = .success(.ok)
}

public struct EmptyResponsePostRouteContext<RequestBodyType: Content>: RouteContext {
    public typealias RequestBodyType = RequestBodyType
    public typealias ResponseBodyType = KernelSwiftCommon.Networking.HTTP.EmptyResponse
    public init() {}
    public let success: ResponseContext<ResponseBodyType> = .success(.created)
}

public struct EmptyResponsePostRouteContextWithStatus<
    RequestBodyType: Content,
    CustomResponseStatus: _KernelHTTPStatusRepresentable
>: RouteContext {
    public typealias RequestBodyType = RequestBodyType
    public typealias ResponseBodyType = KernelSwiftCommon.Networking.HTTP.EmptyResponse
    public init() {}
    public let success: ResponseContext<ResponseBodyType> = .success(CustomResponseStatus.status)
}

public struct UpdateRouteContext<RequestBodyType: Content, ResponseBodyType: Content>: RouteContext {
    public typealias RequestBodyType = RequestBodyType
    public init() {}
    public let success: ResponseContext<ResponseBodyType> = .success(.ok)
}

public struct UpdateRouteContextWithStatus<
    RequestBodyType: Content, 
    ResponseBodyType: Content,
    CustomResponseStatus: _KernelHTTPStatusRepresentable
>: RouteContext {
    public typealias RequestBodyType = RequestBodyType
    public typealias ResponseBodyType = ResponseBodyType
    public init() {}
    public let success: ResponseContext<ResponseBodyType> = .success(CustomResponseStatus.status)
}

public struct EmptyRequestUpdateRouteContext<ResponseBodyType: Content>: RouteContext {
    public typealias RequestBodyType = KernelSwiftCommon.Networking.HTTP.EmptyRequest
    public typealias ResponseBodyType = ResponseBodyType
    public init() {}
    public let success: ResponseContext<ResponseBodyType> = .success(.ok)
}

public struct EmptyResponseUpdateRouteContext<RequestBodyType: Content>: RouteContext {
    public typealias RequestBodyType = RequestBodyType
    public typealias ResponseBodyType = KernelSwiftCommon.Networking.HTTP.EmptyResponse
    public init() {}
    public let success: ResponseContext<ResponseBodyType> = .success(.accepted)
}

public struct EmptyResponseUpdateRouteContextWithStatus<
    RequestBodyType: Content,
    CustomResponseStatus: _KernelHTTPStatusRepresentable
>: RouteContext {
    public typealias RequestBodyType = RequestBodyType
    public typealias ResponseBodyType = KernelSwiftCommon.Networking.HTTP.EmptyResponse
    public init() {}
    public let success: ResponseContext<ResponseBodyType> = .success(CustomResponseStatus.status)
}

public typealias EmptyUpdateRouteContext = EmptyResponseUpdateRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyRequest>

public struct DeleteRouteContext<ResponseBodyType: Content>: RouteContext {
    public typealias ResponseBodyType = ResponseBodyType
    public init() {}
    public let success: ResponseContext<ResponseBodyType> = .success(.ok)
    public let force: QueryParam<Bool> = .init(name: "force", defaultValue: false)
}

public struct DeleteRouteContextWithStatus<ResponseBodyType: Content, CustomResponseStatus: _KernelHTTPStatusRepresentable>: RouteContext {
    public typealias ResponseBodyType = ResponseBodyType
    public init() {}
    public let success: ResponseContext<ResponseBodyType> = .success(CustomResponseStatus.status)
}

public typealias DefaultDeleteRouteContextWithForce = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>

public protocol RouteContextWithKernelPlatformAction: RouteContext {
    associatedtype PlatformActionType: KernelPlatformAction = EmptyKernelPlatformAction
}

public protocol JSONRouteContext: RouteContext & AbstractJSONRouteContext {}

extension RouteContext {
    public static var requestBodyType: Any.Type { return RequestBodyType.self }
    public static var queryParamsType: Any.Type { return QueryParamsType.self }
    public static var pathParamsType: Any.Type { return PathParamsType.self }
    public static var shared: Self { .init() }
    public static var defaultContentType: HTTPMediaType? { .json }
    
    public static var responseBodyTuples: [(statusCode: Int, contentType: HTTPMediaType?, responseBodyType: Any.Type)] {
        let context = Self.shared
        let mirror = Mirror(reflecting: context)
        
        let responseContexts = mirror.children.compactMap { property in property.value as? AbstractResponseContextType }
        
        return responseContexts
            .map { responseContext in
                var dummyResponse = Response()
                responseContext.configure(&dummyResponse)
                
                let statusCode = Int(dummyResponse.status.code)
                let contentType = dummyResponse.headers.contentType
                
                return (statusCode: statusCode, contentType: contentType, responseBodyType: responseContext.responseBodyType)
            }
    }
    
    public static var requestBodyTuples: [(contentType: HTTPMediaType?, requestBodyType: any Any.Type)] {
        []
    }
    
    public static var requestQueryParams: [AbstractQueryParam] {
        let context = Self.shared

        let mirror = Mirror(reflecting: context)

        return mirror
            .children
            .compactMap { property in property.value as? AbstractQueryParam }
    }
}

public struct PlatformActionRouteContext<PlatformAction: KernelPlatformAction>: RouteContextWithKernelPlatformAction {
    
    
    public typealias PlatformActionType = PlatformAction
    public typealias RequestBodyType = PlatformAction.KPActionRequestBody
    public typealias QueryParamsType = PlatformAction.KPActionQueryParams
    public typealias PathParamsType = PlatformAction.KPActionPathParams
    public static var shared: PlatformActionRouteContext<PlatformAction> { return Self() }
    public static var defaultContentType: HTTPMediaType? { return nil }
    public init() {}
    let success: ResponseContext<PlatformAction.KPActionResponseBody> = .success(.ok)
    
    public static var requestQueryParams: [AbstractQueryParam] {
        do {
            let randomParams = try QueryParamsType.randomInstance()
            let mirror = Mirror(reflecting: randomParams)
            let abstracts: [AbstractQueryParam]  = mirror.children.compactMap { param in
                switch type(of: param.value) {
                case is Int.Type: return QueryParam<Int>.init(name: param.label ?? "") as AbstractQueryParam
                case is String.Type: return QueryParam<String>.init(name: param.label ?? "") as AbstractQueryParam
                case is Date.Type: return QueryParam<Date>.init(name: param.label ?? "") as AbstractQueryParam
                case is UUID.Type: return QueryParam<UUID>.init(name: param.label ?? "") as AbstractQueryParam
//                case is KPPaginationOrder.Type: return QueryParam<KPPaginationOrder>.init(name: param.label ?? "") as AbstractQueryParam
                case is Optional<Int>.Type: return QueryParam<Int>.init(name: param.label ?? "") as AbstractQueryParam
                case is Optional<String>.Type: return QueryParam<String>.init(name: param.label ?? "") as AbstractQueryParam
                case is Optional<Date>.Type: return QueryParam<Date>.init(name: param.label ?? "") as AbstractQueryParam
                case is Optional<UUID>.Type: return QueryParam<UUID>.init(name: param.label ?? "") as AbstractQueryParam
                default: return nil
                }
            }
            return abstracts
        } catch let error {
            KernelNetworking.logger.report(error: error)
            return []
        }
    }
}
