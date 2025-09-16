//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/06/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelXML {
    public struct XMLContentDecoder: ContentDecoder {
        public let decoder: XMLDecoder
        
        public init(
            trimValueWhitespaces: Bool = true,
            removeWhitespaceElements: Bool = false
        ) {
            self.decoder = .init(trimValueWhitespaces: trimValueWhitespaces, removeWhitespaceElements: removeWhitespaceElements)
        }
        
        public func decode<D>(_ decodable: D.Type, from body: ByteBuffer, headers: HTTPHeaders) throws -> D where D: Decodable {
            guard let data = body.getData(at: 0, length: body.readableBytes) else {
                throw Abort(.badRequest, reason: "Invalid XML body")
            }
            return try decoder.decode(D.self, from: data)
        }
    }
}
