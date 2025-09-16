//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/06/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelXML {
    public struct XMLContentEncoder: ContentEncoder {
        public let encoder: XMLEncoder
        
        public init(encoder: XMLEncoder = .init()) {
            self.encoder = encoder
        }
        
        public func encode<E>(_ encodable: E, headers: inout HTTPHeaders) throws -> ByteBuffer where E: Encodable {
            let data = try encoder.encode(encodable, withRootKey: "root", header: KernelXML.Header(version: 1.0))
            headers.contentType = .xml
            var buffer = ByteBufferAllocator().buffer(capacity: data.count)
            buffer.writeBytes(data)
            return buffer
        }
        
        public func encode<E>(_ encodable: E, to body: inout ByteBuffer, headers: inout HTTPHeaders) throws where E : Encodable {
            let data = try encoder.encode(encodable, withRootKey: "root", header: KernelXML.Header(version: 1.0))
            headers.contentType = .xml
            body.writeBytes(data)
        }
    }
}
