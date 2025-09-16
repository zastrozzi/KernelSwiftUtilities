//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 12/09/2024.
//

import KernelSwiftCommon
import Vapor
import OpenAPIKit30

public protocol OpenAPIContent: Codable, Equatable, Content, OpenAPIEncodableSampleable {}

extension OpenAPI.ContentType {
    public static func fromHTTP(_ mediaType: HTTPMediaType) -> Self {
        return mediaType.openAPIContentType ?? .init(rawValue: mediaType.serialize()) ?? .other("\(mediaType.type)/\(mediaType.subType)")
    }
}
