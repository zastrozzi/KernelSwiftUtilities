//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/09/2023.
//

import Foundation
import Vapor
import KernelSwiftCommon

//extension KernelSwiftCommon.TypedError: @retroactive AbortError where WrappedError: KernelSwiftCommon.ErrorTypes {
extension KernelSwiftCommon.TypedError: AbortError where WrappedError: KernelSwiftCommon.ErrorTypes {
    public var status: HTTPStatus {
        return switch httpStatus {
        case .continue                      : .continue
        case .switchingProtocols            : .switchingProtocols
        case .processing                    : .processing
        case .earlyHints                    : .custom(code: 103, reasonPhrase: "Early Hints")
        case .ok                            : .ok
        case .created                       : .created
        case .accepted                      : .accepted
        case .nonAuthoritativeInformation   : .nonAuthoritativeInformation
        case .noContent                     : .noContent
        case .resetContent                  : .resetContent
        case .partialContent                : .partialContent
        case .multiStatus                   : .multiStatus
        case .alreadyReported               : .alreadyReported
        case .imUsed                        : .imUsed
        case .multipleChoices               : .multipleChoices
        case .movedPermanently              : .movedPermanently
        case .found                         : .found
        case .seeOther                      : .seeOther
        case .notModified                   : .notModified
        case .useProxy                      : .useProxy
        case .temporaryRedirect             : .temporaryRedirect
        case .permanentRedirect             : .permanentRedirect
        case .badRequest                    : .badRequest
        case .unauthorized                  : .unauthorized
        case .paymentRequired               : .paymentRequired
        case .forbidden                     : .forbidden
        case .notFound                      : .notFound
        case .methodNotAllowed              : .methodNotAllowed
        case .notAcceptable                 : .notAcceptable
        case .proxyAuthenticationRequired   : .proxyAuthenticationRequired
        case .requestTimeout                : .requestTimeout
        case .conflict                      : .conflict
        case .gone                          : .gone
        case .lengthRequired                : .lengthRequired
        case .preconditionFailed            : .preconditionFailed
        case .payloadTooLarge               : .payloadTooLarge
        case .uriTooLong                    : .uriTooLong
        case .unsupportedMediaType          : .unsupportedMediaType
        case .rangeNotSatisfiable           : .rangeNotSatisfiable
        case .expectationFailed             : .expectationFailed
        case .imATeapot                     : .imATeapot
        case .misdirectedRequest            : .misdirectedRequest
        case .unprocessableEntity           : .unprocessableEntity
        case .locked                        : .locked
        case .failedDependency              : .failedDependency
        case .tooEarly                      : .custom(code: 425, reasonPhrase: "Too Early")
        case .upgradeRequired               : .upgradeRequired
        case .preconditionRequired          : .preconditionRequired
        case .tooManyRequests               : .tooManyRequests
        case .requestHeaderFieldsTooLarge   : .requestHeaderFieldsTooLarge
        case .unavailableForLegalReasons    : .unavailableForLegalReasons
        case .internalServerError           : .internalServerError
        case .notImplemented                : .notImplemented
        case .badGateway                    : .badGateway
        case .serviceUnavailable            : .serviceUnavailable
        case .gatewayTimeout                : .gatewayTimeout
        case .httpVersionNotSupported       : .httpVersionNotSupported
        case .variantAlsoNegotiates         : .variantAlsoNegotiates
        case .insufficientStorage           : .insufficientStorage
        case .loopDetected                  : .loopDetected
        case .notExtended                   : .notExtended
        case .networkAuthenticationRequired : .networkAuthenticationRequired
        }
    }
    
    public var reason: String {
        if httpReason.isEmptyOrBlank { status.reasonPhrase }
        else { httpReason }
    }
}
