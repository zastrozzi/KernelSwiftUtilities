//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2022.
//

import Foundation
import Vapor

extension HTTPStatus {
    public var category: HTTPStatusCategory {
        switch self {
            
        case
            .continue,
            .switchingProtocols,
            .processing:
            return .informational
            
        case
            .ok,
            .created,
            .accepted,
            .nonAuthoritativeInformation,
            .noContent,
            .resetContent,
            .partialContent,
            .multiStatus,
            .alreadyReported,
            .imUsed:
            return .success
            
        case
            .multipleChoices,
            .movedPermanently,
            .found,
            .seeOther,
            .notModified,
            .useProxy,
            .temporaryRedirect,
            .permanentRedirect:
            return .redirection
            
        case
            .badRequest,
            .unauthorized,
            .paymentRequired,
            .forbidden,
            .notFound,
            .methodNotAllowed,
            .notAcceptable,
            .proxyAuthenticationRequired,
            .requestTimeout,
            .conflict,
            .gone,
            .lengthRequired,
            .preconditionFailed,
            .payloadTooLarge,
            .uriTooLong,
            .unsupportedMediaType,
            .rangeNotSatisfiable,
            .expectationFailed,
            .imATeapot,
            .misdirectedRequest,
            .unprocessableEntity,
            .locked,
            .failedDependency,
            .upgradeRequired,
            .preconditionRequired,
            .tooManyRequests,
            .requestHeaderFieldsTooLarge,
            .unavailableForLegalReasons:
            return .clientError
            
        case
            .internalServerError,
            .notImplemented,
            .badGateway,
            .serviceUnavailable,
            .gatewayTimeout,
            .httpVersionNotSupported,
            .variantAlsoNegotiates,
            .insufficientStorage,
            .loopDetected,
            .notExtended,
            .networkAuthenticationRequired:
            return .serverError
            
        case .custom:
            return .other
        }
    }
}

public enum HTTPStatusCategory {
    case informational
    case success
    case redirection
    case clientError
    case serverError
    case other
}

public protocol _KernelHTTPStatusRepresentable {
    static var status: HTTPStatus { get }
}

extension HTTPStatus {
    public struct Continue: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .continue }
    public struct SwitchingProtocols: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .switchingProtocols }
    public struct Processing: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .processing }
    public struct Ok: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .ok }
    public struct Created: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .created }
    public struct Accepted: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .accepted }
    public struct NonAuthoritativeInformation: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .nonAuthoritativeInformation }
    public struct NoContent: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .noContent }
    public struct ResetContent: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .resetContent }
    public struct PartialContent: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .partialContent }
    public struct MultiStatus: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .multiStatus }
    public struct AlreadyReported: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .alreadyReported }
    public struct ImUsed: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .imUsed }
    public struct MultipleChoices: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .multipleChoices }
    public struct MovedPermanently: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .movedPermanently }
    public struct Found: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .found }
    public struct SeeOther: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .seeOther }
    public struct NotModified: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .notModified }
    public struct UseProxy: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .useProxy }
    public struct TemporaryRedirect: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .temporaryRedirect }
    public struct PermanentRedirect: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .permanentRedirect }
    public struct BadRequest: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .badRequest }
    public struct Unauthorized: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .unauthorized }
    public struct PaymentRequired: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .paymentRequired }
    public struct Forbidden: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .forbidden }
    public struct NotFound: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .notFound }
    public struct MethodNotAllowed: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .methodNotAllowed }
    public struct NotAcceptable: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .notAcceptable }
    public struct ProxyAuthenticationRequired: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .proxyAuthenticationRequired }
    public struct RequestTimeout: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .requestTimeout }
    public struct Conflict: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .conflict }
    public struct Gone: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .gone }
    public struct LengthRequired: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .lengthRequired }
    public struct PreconditionFailed: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .preconditionFailed }
    public struct PayloadTooLarge: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .payloadTooLarge }
    public struct UriTooLong: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .uriTooLong }
    public struct UnsupportedMediaType: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .unsupportedMediaType }
    public struct RangeNotSatisfiable: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .rangeNotSatisfiable }
    public struct ExpectationFailed: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .expectationFailed }
    public struct ImATeapot: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .imATeapot }
    public struct MisdirectedRequest: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .misdirectedRequest }
    public struct UnprocessableEntity: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .unprocessableEntity }
    public struct Locked: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .locked }
    public struct FailedDependency: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .failedDependency }
    public struct UpgradeRequired: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .upgradeRequired }
    public struct PreconditionRequired: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .preconditionRequired }
    public struct TooManyRequests: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .tooManyRequests }
    public struct RequestHeaderFieldsTooLarge: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .requestHeaderFieldsTooLarge }
    public struct UnavailableForLegalReasons: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .unavailableForLegalReasons }
    public struct InternalServerError: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .internalServerError }
    public struct NotImplemented: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .notImplemented }
    public struct BadGateway: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .badGateway }
    public struct ServiceUnavailable: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .serviceUnavailable }
    public struct GatewayTimeout: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .gatewayTimeout }
    public struct HttpVersionNotSupported: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .httpVersionNotSupported }
    public struct VariantAlsoNegotiates: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .variantAlsoNegotiates }
    public struct InsufficientStorage: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .insufficientStorage }
    public struct LoopDetected: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .loopDetected }
    public struct NotExtended: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .notExtended }
    public struct NetworkAuthenticationRequired: _KernelHTTPStatusRepresentable { public static let status: HTTPStatus = .networkAuthenticationRequired }
}
