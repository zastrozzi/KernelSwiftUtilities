//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation
import KernelSwiftCommon

@available(*, deprecated)
public protocol KernelSwiftHttpHeader: Printable {
    var key: String { get }
    var value: String? { get }
}

@available(*, deprecated)
extension KernelSwiftHttpHeader {
    public var debugDescription: String {
        return "\(key):\(value?.debugDescription ?? "no value")"
    }
}

@available(*, deprecated)
public enum HeaderType: String {
    case accept = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case acceptLanguage = "Accept-Language"
    case authorization = "Authorization"
    case contentLength = "Content-Length"
    case contentType = "Content-Type"
    case connection = "Connection"
}
