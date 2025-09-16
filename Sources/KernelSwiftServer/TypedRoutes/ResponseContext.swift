//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

//import Foundation
import Vapor

public protocol AbstractResponseContextType {
    var configure: @Sendable (inout Response) -> Void { get }
    var responseBodyType: Any.Type { get }
}

public protocol ResponseContextType: AbstractResponseContextType {
    associatedtype ResponseBodyType: ResponseEncodable & AsyncResponseEncodable
}

extension ResponseContextType {
    public var responseBodyType: Any.Type { return ResponseBodyType.self }
}

public struct ResponseContext<ResponseBodyType: ResponseEncodable & AsyncResponseEncodable>: ResponseContextType, Sendable {
    public let configure: @Sendable (inout Response) -> Void
    
    public init(_ configure: @Sendable @escaping (inout Response) -> Void) {
        self.configure = { response in configure(&response) }
    }
}

extension ResponseContext {
    public static func success(_ status: HTTPResponseStatus) -> Self {
        return Self.init { response in
            response.headers.contentType = .json
            response.status = status
        }
    }
    
    public static func success(_ status: HTTPResponseStatus, _ contentType: HTTPMediaType) -> Self {
        return Self.init { response in
            response.headers.contentType = contentType
            response.status = status
        }
    }
    
    public static func error(_ status: HTTPResponseStatus) -> Self {
        return .init { response in
            response.headers.contentType = .json
            response.status = status
        }
    }
}

public struct CannedResponse<ResponseBodyType: ResponseEncodable & AsyncResponseEncodable>: ResponseContextType {
    public let configure: @Sendable (inout Response) -> Void
    public let response: Response
    
    public init(response cannedResponse: Response) {
        self.response = cannedResponse
        self.configure = { response in response = cannedResponse }
    }
}
