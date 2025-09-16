//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation

//public protocol BKHttpRouter: URLRequestConvertible {
//    var baseURLString: String { get }
//    var path: String { get }
//    var method: HTTPMethod { get }
//    var headers: HTTPHeaders? { get }
//    var parameters: Parameters? { get }
//    
//    func body() throws -> Data?
//    func request(usingHttpService service: BKHttpService) throws -> DataRequest
//}
//
//extension BKHttpRouter {
//    var parameters: Parameters? { return nil }
//    func body() throws -> Data? { return nil }
//    
//    public func asURLRequest() throws -> URLRequest {
//        var url = try baseURLString.asURL()
//        url.appendPathComponent(path)
//        var comp = URLComponents(url: url, resolvingAgainstBaseURL: false)!
//        comp.queryItems = parameters?.map { element in URLQueryItem(name: element.key, value: "\(element.value)") }
//        let composedUrl = try comp.asURL()
//        
//        var request = try URLRequest(url: composedUrl, method: method, headers: headers)
//        request.httpBody = try body()
//        return request
//    }
//    
//    public func request(usingHttpService service: BKHttpService) throws -> DataRequest {
//        return try service.request(asURLRequest())
//    }
//}
