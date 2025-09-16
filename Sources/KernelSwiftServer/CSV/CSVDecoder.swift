//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/05/2023.
//

import Foundation
import Vapor

extension KernelCSV {
    public final class CSVDecoder: ContentDecoder {
        internal let decoding: (Decodable & Sendable).Type
        internal let configuration: CSVCodingConfiguration
        let internalDecoder: AsynchronousDecoder
        
        public init<D>(decoding: D.Type, configuration: CSVCodingConfiguration, decodedObjectHandler: @escaping DecodedObjectHandler) where D: Decodable, D: Sendable {
            self.decoding = decoding
            self.configuration = configuration
            let safeDecodedObjectHandler: DecodedObjectHandler = { (decoded: Decodable) in
                guard let typed = decoded as? D else {
                    assertionFailure("Incompatible type presented to DecodedObjectHandler")
                    return
                }
                try await decodedObjectHandler(typed)
            }
            self.internalDecoder = .init(decoding: D.self, path: [], configuration: configuration, decodedObjectHandler: safeDecodedObjectHandler)
        }
        
        public func decode<D>(_ decodable: D.Type, from body: NIOCore.ByteBuffer, headers: NIOHTTP1.HTTPHeaders) throws -> D where D : Decodable {
            fatalError("Not implemented")
        }
        
        public func decodeRow(_ data: [UInt8], length: Int? = nil) async throws {
            try await self.internalDecoder.decode(data, length: length)
        }
    }
}
